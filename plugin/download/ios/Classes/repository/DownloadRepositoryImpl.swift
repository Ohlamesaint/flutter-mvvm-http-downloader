//
//  DownloadRepositoryImpl.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

class DownloadRepositoryImpl: DownloadRepository {
    
    private let LENGTH_PER_REQUEST = 500000
    
    func configureDownload(from urlString: String, isConcurrent: Bool) async throws -> DownloadEntity {
        
        guard let url = URL(string: urlString) else {
            throw AppError.BadRequestError
        }
        
        let response = try await NetworkUtil.getHeaders(from: url)
        
        
        let contentLengthInfo = response.value(forHTTPHeaderField: "Content-Length")
        let mimeType = response.mimeType
        let acceptRangesInfo = response.value(forHTTPHeaderField: "Accept-Ranges")
        
        let contentLength = contentLengthInfo == nil ? 0 : Int(contentLengthInfo!)
        let acceptRange = acceptRangesInfo == nil ? false :  acceptRangesInfo!=="bytes"
        
        // TODO: use stream for acceptRange
        
        let filename = FileUtil.generateFileName()
        let fileType = url.pathExtension
        let tempDownloadFileString = FileUtil.createTempFile(withName: filename, andType: fileType)
        let fileEntity = FileEntity(
            filenme: filename, fileType: fileType, temporaryImagePath: tempDownloadFileString.absoluteString)
        
        let downloadEntity = DownloadEntity(downloadID: filename, url: urlString, totalLength: contentLength!, fileEntity: fileEntity, isConcurrent: isConcurrent)
        
        
        return downloadEntity
        
    }
    
    
    
    func fetchImage(baseOn downloadEntity: DownloadEntity, updateProgress: @escaping () async -> Void ) throws {
        
        
        Task {
            var fileSegments: [URL]
            if(downloadEntity.isConcurrent) {
                fileSegments = try await _concurrentFetchDownload(baseOn: downloadEntity, notifier: updateProgress)
            } else {
                fileSegments = try await _sequentialFetchDownload(baseOn: downloadEntity, notifier: updateProgress)
            }
            
            try await FileUtil.combineFiles(fileSegments: fileSegments.sorted(by: {f1, f2 in
                return Int(f1.lastPathComponent.split(separator: "_")[0])! <
                Int(f2.lastPathComponent.split(separator: "_")[0])!
            }), to: URL(string: downloadEntity.fileEntity.temporaryImagePath)!)
    
            try await _finalizeDownload(on: downloadEntity, notifier: updateProgress)
        }
    }
    
    class RangeDownloadOperation: AsyncOperation {
        let startByte: Int
        let endByte: Int
        let tempFileSegment: URL
        let url: String
        
        init(startByte: Int, endByte: Int, tempFileSegment: URL, url: String) {
            self.startByte = startByte
            self.endByte = endByte
            self.tempFileSegment = tempFileSegment
            self.url = url
        }
        
        override func start() {
            NetworkUtil.downloadWithRangeWithCompletion(source: URL(string: url)!, from: startByte, to: endByte, destination: tempFileSegment) { data, response, error in
                self.finish()
            }
        }
    }
    
    // based on AsyncSequence
    private func _sequentialFetchDownload(baseOn downloadEntity: DownloadEntity, notifier updateProgress: @escaping () async -> Void) async throws -> [URL] {
    
        var fileSegments: [URL] = []
        
        let totalRequest = (downloadEntity.totalLength + LENGTH_PER_REQUEST - 1) / LENGTH_PER_REQUEST
        
        let queue = OperationQueue()
        queue.isSuspended = false
        queue.maxConcurrentOperationCount = 1
        
        for index in (0..<totalRequest) {
            let fileSegmentName = "\(index)_\(downloadEntity.fileEntity.filename)"
            let tempFileSegment = FileUtil.createTempFile(withName: fileSegmentName, andType: "tmp")
            let (start, end, len) = self._generateFetchRange(at: index, with: downloadEntity.totalLength)
            let operation = RangeDownloadOperation(startByte: start, endByte: end, tempFileSegment: tempFileSegment, url: downloadEntity.url)
            operation.completionBlock = {
                downloadEntity.updateProgress(length: len)
                fileSegments.append(tempFileSegment.absoluteURL)
                Task.detached{@MainActor in await updateProgress()}
            }
            queue.addOperation(operation)
        }
        
        return fileSegments
        
    }
        
    // Based on TaskGroup
    private func _concurrentFetchDownload(baseOn downloadEntity: DownloadEntity, notifier updateProgress: @escaping () async -> Void) async throws -> [URL] {
        
        var fileSegments: [URL] = []
        
        let totalRequest = (downloadEntity.totalLength + LENGTH_PER_REQUEST - 1) / LENGTH_PER_REQUEST
        
        try await withThrowingTaskGroup(of: (URL, Int).self) { group in
            downloadEntity.groupTask = group
            for index in (0..<totalRequest) {
                group.addTask {
                    let fileSegmentName = "\(index)_\(downloadEntity.fileEntity.filename)"
                    let tempFileSegment = FileUtil.createTempFile(withName: fileSegmentName, andType: "tmp")
                    
                    let (start, end, length) = self._generateFetchRange(at: index, with: downloadEntity.totalLength)
                    
                    await NetworkUtil.downloadWithRange(source: URL(string: downloadEntity.url)!, from: start, to: end, destination: tempFileSegment)
                    return (tempFileSegment.absoluteURL, length)
                }
            }
            for try await (tempFileURL, len) in group {
                downloadEntity.updateProgress(length: len)
                fileSegments.append(tempFileURL)
                Task.detached{@MainActor in await updateProgress()}
                // notify new progress
            }
        }
        return fileSegments
    }
    
    private func _finalizeDownload(on downloadEntity: DownloadEntity, notifier updateProgress: @escaping () async -> Void) async throws {
        try await MainActor.run{
            downloadEntity.status = DownloadStatus.done
            DownloadPlugin.finishEventSink!(try JSONSerialization.jsonObject(with: try JSONEncoder().encode(downloadEntity)))
            Task.detached{@MainActor in await updateProgress()}
        }
    }
    
    private func _generateFetchRange(at index: Int, with totalLength: Int) -> (Int, Int, Int) {
        let start = index * self.LENGTH_PER_REQUEST
        let end = Swift.min((index+1)*self.LENGTH_PER_REQUEST-1, totalLength-1)
        let length = end-start+1
        return (start, end, length)
    }
    
    
}



open class AsyncOperation: Operation {
    private let lockQueue = DispatchQueue(label: "lockQueue", attributes: .concurrent)

    override open var isAsynchronous: Bool {
        return true
    }

    private var _isExecuting: Bool = false
    override open private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished: Bool = false
    override open private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override open func start() {
        guard !isCancelled else {
            finish()
            return
        }

        isFinished = false
        isExecuting = true
        main()
    }

    override open func main() {
        /// Use a dispatch after to mimic the scenario of a long-running task.
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
            print("Executing")
            self.finish()
        })
    }

    open func finish() {
        isExecuting = false
        isFinished = true
    }
}
