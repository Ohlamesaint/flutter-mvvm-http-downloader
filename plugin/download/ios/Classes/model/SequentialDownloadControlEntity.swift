//
//  SequentialDownloadControlEntity.swift
//  download
//
//  Created by 陳力聖 on 2024/8/24.
//

import Foundation

class SequentialDownloadControlEntity: DownloadControlEntity {
    
    let queue: OperationQueue
    
    init(queue: OperationQueue) {
        self.queue = queue
    }
    
    func pauseDownload() {
        queue.isSuspended = true
    }
    
    func cancelDownload() {
        queue.cancelAllOperations()
    }
    
    
    func resumeDownload() {
        queue.isSuspended = false
    }
    
    
}
