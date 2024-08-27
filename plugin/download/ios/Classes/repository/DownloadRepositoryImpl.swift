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
            if(downloadEntity.isConcurrent) {
                try await _concurrentFetchDownload(baseOn: downloadEntity, notifier: updateProgress)
            } else {
                try _sequentialFetchDownload(baseOn: downloadEntity, notifier: updateProgress)
            }
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
        let observation = Operation.observationInfo()
        
        override func main() {        
            NetworkUtil.downloadWithRangeWithCompletion(source: URL(string: url)!, from: startByte, to: endByte, destination: tempFileSegment) { data, response, error in
                do {
                    FileUtil.storeByteStreamToFile(from: data!, to: self.tempFileSegment)
                    print("\(self.startByte)-\(self.endByte) finished, length \(try Data(contentsOf: self.tempFileSegment.absoluteURL).count)")
                } catch {
                    
                }
                
                self.finish()
            }
        }
    }
    
    actor FileSegmentActor {
        var fileSegments: [URL] = []
        
        func getFiles() async -> [URL] {
            return fileSegments
        }
        
        func addFile(file: URL) async {
            fileSegments.append(file)
        }
    }
    
    // based on AsyncSequence
    private func _sequentialFetchDownload(baseOn downloadEntity: DownloadEntity, notifier updateProgress: @escaping () async -> Void) throws {
        let fileSegmentActor = FileSegmentActor()

    
        let totalRequest = (downloadEntity.totalLength + LENGTH_PER_REQUEST - 1) / LENGTH_PER_REQUEST
        

        var operations: [Operation] = []
        for index in (0..<totalRequest) {
            let fileSegmentName = "\(index)_\(downloadEntity.fileEntity.filename)"
            let tempFileSegment = FileUtil.createTempFile(withName: fileSegmentName, andType: "tmp")
            let (start, end, len) = self._generateFetchRange(at: index, with: downloadEntity.totalLength)
            let operation = RangeDownloadOperation(startByte: start, endByte: end, tempFileSegment: tempFileSegment, url: downloadEntity.url)
            operation.completionBlock = {
                downloadEntity.updateProgress(length: len)
                Task.detached{
                    await fileSegmentActor.addFile(file: tempFileSegment)
                }
                Task.detached{@MainActor in await updateProgress()}
                
            }
            operations.append(operation)
            
        }
        let queue = OperationQueue()
        downloadEntity.downloadControlEntity = SequentialDownloadControlEntity(queue: queue)
        queue.maxConcurrentOperationCount = 1
        queue.addOperations(operations, waitUntilFinished: true)
        queue.addBarrierBlock{
            Task.detached{
                try await FileUtil.combineFiles(fileSegments: (await fileSegmentActor.getFiles()).sorted(by: {f1, f2 in
                    return Int(f1.lastPathComponent.split(separator: "_")[0])! <
                    Int(f2.lastPathComponent.split(separator: "_")[0])!
                }), to: URL(string: downloadEntity.fileEntity.temporaryImagePath)!)
                try await self._finalizeDownload(on: downloadEntity, notifier: updateProgress)
            }
        }
        
        queue.isSuspended = false
        
    }
        
    // Based on TaskGroup
    private func _concurrentFetchDownload(baseOn downloadEntity: DownloadEntity, notifier updateProgress: @escaping () async -> Void) async throws {
        
        var fileSegments: [URL] = []
        
        let totalRequest = (downloadEntity.totalLength + LENGTH_PER_REQUEST - 1) / LENGTH_PER_REQUEST
        
        try await withThrowingTaskGroup(of: (URL, Int).self) { group in
            downloadEntity.downloadControlEntity = ConcurrentDownloadControlEntity(groupTask: group)
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
        
        try await FileUtil.combineFiles(fileSegments: fileSegments.sorted(by: {f1, f2 in
            return Int(f1.lastPathComponent.split(separator: "_")[0])! <
            Int(f2.lastPathComponent.split(separator: "_")[0])!
        }), to: URL(string: downloadEntity.fileEntity.temporaryImagePath)!)

        try await _finalizeDownload(on: downloadEntity, notifier: updateProgress)
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



