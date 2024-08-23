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
    var groupTask: ThrowingTaskGroup<(URL, Int), any Error>? = nil

    
    
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


enum DownloadStatus: Encodable {
    case pending, paused, ongoing, manualPaused, canceled, failed, done
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
