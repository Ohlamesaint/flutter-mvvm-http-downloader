//
//  SequentialDownloadControlEntity.swift
//  download
//
//  Created by 陳力聖 on 2024/8/24.
//

import Foundation

class SequentialDownloadControlEntity: DownloadControlEntity {
    
    let queue: OperationQueue
    let fileSegmentActor: FileSegmentActor
    
    init(queue: OperationQueue, fileSegmentActor: FileSegmentActor) {
        self.queue = queue
        self.fileSegmentActor = fileSegmentActor
    }
    
    func pauseDownload() {
        queue.isSuspended = true
    }
    
    func cancelDownload() {
        queue.cancelAllOperations()
        Task.detached{
            await self.fileSegmentActor.removeAllFiles()
        }
    }
    
    
    func resumeDownload() {
        queue.isSuspended = false
    }
    
    
}
