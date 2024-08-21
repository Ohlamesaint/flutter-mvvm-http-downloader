//
//  DownloadRepositoryImpl.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

class DownloadRepositoryImpl: DownloadRepository {
    
    private let LENGTH_PER_REQUEST = 500_000
    
    func configureDownload(from urlString: String) async throws -> DownloadEntity {
        
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
        
        let downloadEntity = DownloadEntity(downloadID: filename, url: urlString, totalLength: contentLength!, fileEntity: fileEntity)
        
        
        return downloadEntity
        
    }
    
    func fetchImage(baseOn downloadEntity: DownloadEntity) throws {
        let totalRequest = downloadEntity.totalLength / LENGTH_PER_REQUEST
        
        let dirURL = try FileUtil.createTempDirectory(withName: downloadEntity.fileEntity.filename)
        
        let queue = DispatchQueue(label: downloadEntity.downloadID)
        queue.suspend()
        
        let group = DispatchGroup()
        
        
        (0 ..< totalRequest).forEach { current in
            let fileSegmentName = "\(downloadEntity.fileEntity.filename)_\(current)"
            let tempFileSegment = FileUtil.createTempFile(withName: fileSegmentName, andType: "tmp")
            
            let start = current * LENGTH_PER_REQUEST
            let end = Swift.min((current+1)*LENGTH_PER_REQUEST-1, downloadEntity.totalLength-1)
            let length = end-start+1
            
            queue.async{
                group.enter()
                Task{
                    await NetworkUtil.downloadWithRange(source: URL(string: downloadEntity.url)!, from: start, to: end, destination: tempFileSegment)
                    // notify new progress
                    downloadEntity.currentLength+=length
                    print("\(downloadEntity.currentLength)/\(downloadEntity.totalLength)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: queue) {
            print("Done")
            downloadEntity.status = DownloadStatus.done
            // notify download finished
        }
        
        downloadEntity.dispatchQueue = queue
        downloadEntity.dispatchGroup = group
        
    }
    
    
}


//struct RangeRequests: AsyncSequence {
//    
//    typealias Element = Int
//    let totalLength: Int
//    let filename: String
//    let url: String
//    
//    struct RangeRequestIterator: AsyncIteratorProtocol {
//        
//        var current = 0
//        let totalLength: Int
//        let filename: String
//        let url: String
//        private let LENGTH_PER_REQUEST = 500_000
//        
//        mutating func next() async throws -> Int? {
//            
//            let fileSegmentName = "\(filename)_\(current)"
//            let tempFileSegment = FileUtil.createTempFile(withName: fileSegmentName, andType: "tmp")
//            
//            let start = current * LENGTH_PER_REQUEST
//            let end = Swift.min((current+1)*LENGTH_PER_REQUEST-1, totalLength-1)
//            let length = end-start+1
//            current+=1
//            do {
//                try await NetworkUtil.downloadWithRange(source: URL(string: url)!, from: start, to: end, destination: tempFileSegment)
//                return length
//            } catch {
//                throw AppError.BadRequestError
//            }
//            
//        }
//    }
//    
//    func makeAsyncIterator() -> RangeRequestIterator {
//        return RangeRequestIterator(totalLength: totalLength, filename: filename, url: url)
//    }
//}
