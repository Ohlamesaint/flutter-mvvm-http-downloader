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
    let isConcurrent: Bool
    var status: DownloadStatus = DownloadStatus.pending
    let createAt = Date()
    var downloadControlEntity: DownloadControlEntity?
    

    
    
    init(downloadID: String, url: String, totalLength: Int, fileEntity: FileEntity, isConcurrent: Bool) {
        self.downloadID = downloadID
        self.url = url
        self.totalLength = totalLength
        self.fileEntity = fileEntity
        self.isConcurrent = isConcurrent
    }
    
    func updateProgress(length: Int) {
        currentLength += length
    }
        
    
    func pauseDownload() {
        downloadControlEntity!.pauseDownload()
        status = DownloadStatus.paused
    }
    
    func cancelDownload() throws {
        downloadControlEntity!.cancelDownload()
        try fileEntity.removeTempFile()
        status = DownloadStatus.canceled
    }
    
    func manualPausedDownload() {
        downloadControlEntity!.pauseDownload()
        status = DownloadStatus.manualPaused
    }
    
    func resumeDownload() {
        downloadControlEntity!.resumeDownload()
        status = DownloadStatus.ongoing
    }
    
}


enum DownloadStatus: String, Encodable {
    case pending = "pending", paused = "paused", ongoing = "ongoing", manualPaused = "manualPaused", canceled = "canceled", failed = "failed", done = "done"
}


extension DownloadEntity: Encodable {
    enum CodingKeys: String, CodingKey {
        case downloadID
        case url
        case totalLength
        case currentLength
        case status
        case fileEntity
        case isConcurrent
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(downloadID, forKey: .downloadID)
        try container.encode(url, forKey: .url)
        try container.encode(totalLength, forKey: .totalLength)
        try container.encode(currentLength, forKey: .currentLength)
        try container.encode(status, forKey: .status)
        try container.encode(fileEntity, forKey: .fileEntity)
        try container.encode(isConcurrent, forKey: .isConcurrent)
    }
}
