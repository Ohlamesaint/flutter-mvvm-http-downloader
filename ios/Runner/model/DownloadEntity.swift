//
//  DownloadEntity.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation


class DownloadEntity {
    let downloadID: String
    let url: String
    let totalLength: Int
    var currentLength = 0
    let fileEntity: FileEntity
    var status: DownloadStatus = DownloadStatus.pending
    var groupTask: ThrowingTaskGroup<Int, any Error>? = nil

    
    
    init(downloadID: String, url: String, totalLength: Int, fileEntity: FileEntity) {
        self.downloadID = downloadID
        self.url = url
        self.totalLength = totalLength
        self.fileEntity = fileEntity
    }
    
    func updateProgress(length: Int) {
        currentLength += length
    }
        
    
    func pauseDownload() {
        status = DownloadStatus.paused
    }
    
    func cancelDownload() {
        status = DownloadStatus.canceled
        groupTask!.cancelAll()
    }
    
    func manualPausedDownload() {
        status = DownloadStatus.manualPaused
    }
    
    func resumeDownload() {
        status = DownloadStatus.ongoing
    }
    
}


enum DownloadStatus {
    case pending, paused, ongoing, manualPaused, canceled, failed, done
}
