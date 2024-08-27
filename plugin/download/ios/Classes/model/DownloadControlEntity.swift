//
//  DownloadControllEntity.swift
//  download
//
//  Created by 陳力聖 on 2024/8/24.
//

import Foundation


protocol DownloadControlEntity {
    func pauseDownload()
    
    func cancelDownload()
        
    func resumeDownload()
}
