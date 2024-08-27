//
//  ConcurrentDownloadControlEntity.swift
//  download
//
//  Created by 陳力聖 on 2024/8/24.
//

import Foundation

class ConcurrentDownloadControlEntity: DownloadControlEntity {
    
    let groupTask: ThrowingTaskGroup<(URL, Int), any Error>?

    init(groupTask: ThrowingTaskGroup<(URL, Int), any Error>?) {
        self.groupTask = groupTask
    }
    
    func pauseDownload() {
        fatalError("Unsupport method for concurrent download!")
    }
    
    func cancelDownload() {
        groupTask?.cancelAll()
    }

    
    func resumeDownload() {
        fatalError("Unsupport method for concurrent download!")
    }
    
    
}
