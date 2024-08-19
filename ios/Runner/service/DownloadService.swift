//
//  DownloadService.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

protocol DownloadService{
    
    func createDownload()
    func resumeDownload()
    func cancelDownload()
    func pauseDownload()
    func manualPauseDownload()
}
