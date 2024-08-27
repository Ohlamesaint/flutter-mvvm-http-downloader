//
//  DownloadService.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

protocol DownloadService{
    
    func createDownload(urlString: String, isConcurrent: Bool) async -> ServiceResult<Int>
    func startDownload(downloadEntity: DownloadEntity) async
    func resumeDownload(downloadID: String) async -> ServiceResult<Int>
    func cancelDownload(downloadID: String) async -> ServiceResult<Int>
    func pauseDownload(downloadID: String) async -> ServiceResult<Int>
    func manualPauseDownload(downloadID: String) async -> ServiceResult<Int>
}
