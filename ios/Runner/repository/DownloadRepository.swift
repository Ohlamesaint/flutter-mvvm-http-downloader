//
//  DownloadRepository.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

protocol DownloadRepository {
    func configureDownload(from url: String) async throws -> DownloadEntity
    
    func fetchImage(baseOn downloadEntity: DownloadEntity) throws
}
