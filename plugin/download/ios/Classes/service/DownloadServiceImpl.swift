//
//  DownloadServiceImpl.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

class DownloadServiceImpl: DownloadService {
    
    
    private var id2DownloadEntity: [String: DownloadEntity] = [:]
    private let downloadRepository: DownloadRepository
    
    init(downloadRepository: DownloadRepository) {
        self.downloadRepository = downloadRepository
    }
    
    func createDownload(urlString: String, isConcurrent: Bool) async -> ServiceResult<Int> {
        do {
            let downloadEntity = try await downloadRepository.configureDownload(from: urlString, isConcurrent: isConcurrent)
            id2DownloadEntity[downloadEntity.downloadID] = downloadEntity
            
            
            await updateProgress()
            await startDownload(downloadEntity: downloadEntity)
            await updateProgress()
            
            return ServiceResult<Int>(data: _calculateOngoingDownload())
        } catch {
            return ServiceResult<Int>(error: AppError.BadRequestError)
        }
        
    }
    
    func updateProgress() async {
        do {
            try await MainActor.run {
                DownloadPlugin.progressEventSink!(try JSONSerialization.jsonObject(with: try JSONEncoder().encode(Array(id2DownloadEntity.values))))
            }
            
        } catch {
            
        }
    }
    
    private func _calculateOngoingDownload() -> Int {
        return id2DownloadEntity.values.filter{ downloadEntity in
            downloadEntity.status==DownloadStatus.ongoing
        }.count
    }
    
    func startDownload(downloadEntity: DownloadEntity) async {
        do {
            try downloadRepository.fetchImage(baseOn: downloadEntity, updateProgress: updateProgress)
            downloadEntity.status = DownloadStatus.ongoing
            // TODO: add progress
        } catch {
            
        }
        
        
    }
    
    func resumeDownload(downloadID: String) -> ServiceResult<Int> {
        let target = id2DownloadEntity[downloadID]
        target!.resumeDownload()
        // TODO: add progress
        return ServiceResult<Int>(data: _calculateOngoingDownload())
    }
    
    func cancelDownload(downloadID: String) -> ServiceResult<Int> {
        let target = id2DownloadEntity[downloadID]
        target!.cancelDownload()
        // TODO: add progress
        
        // remove all files
        return ServiceResult<Int>(data: _calculateOngoingDownload())
        
    }
    
    func pauseDownload(downloadID: String) -> ServiceResult<Int> {
        let target = id2DownloadEntity[downloadID]
        target!.pauseDownload()
        // TODO: add progress
        return ServiceResult<Int>(data: _calculateOngoingDownload())
    }
    
    func manualPauseDownload(downloadID: String) -> ServiceResult<Int> {
        let target = id2DownloadEntity[downloadID]
        target!.manualPausedDownload()
        // TODO: add progress
        return ServiceResult<Int>(data: _calculateOngoingDownload())
    }
    
    
    
    
}
