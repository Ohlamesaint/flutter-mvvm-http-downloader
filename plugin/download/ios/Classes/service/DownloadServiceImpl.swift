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
            if(error is AppError) {
                return ServiceResult<Int>(error: error as! AppError)
            }
            return ServiceResult<Int>(error: AppError.UnknownError(error.localizedDescription))
        }
        
    }
    
    func updateProgress() async {
        do {
            try await MainActor.run {
                DownloadPlugin.progressEventSink!(try JSONSerialization.jsonObject(with: try JSONEncoder().encode(Array(id2DownloadEntity.values.sorted(by: { d1, d2 in
                    d1.createAt<d2.createAt
                })))))
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
        } catch {
            
        }
        
        
    }
    
    func resumeDownload(downloadID: String) async -> ServiceResult<Int> {
        let target = id2DownloadEntity[downloadID]
        target!.resumeDownload()
        await updateProgress()
        return ServiceResult<Int>(data: _calculateOngoingDownload())
    }
    
    func cancelDownload(downloadID: String) async -> ServiceResult<Int> {
        let target = id2DownloadEntity[downloadID]
        do{
            try target!.cancelDownload()
        } catch {
            return ServiceResult(error: AppError.UnknownError(error.localizedDescription))
        }
        
        await updateProgress()
        return ServiceResult<Int>(data: _calculateOngoingDownload())
        
    }
    
    func pauseDownload(downloadID: String) async -> ServiceResult<Int> {
        let target = id2DownloadEntity[downloadID]
        target!.pauseDownload()
        await updateProgress()
        return ServiceResult<Int>(data: _calculateOngoingDownload())
    }
    
    func manualPauseDownload(downloadID: String) async -> ServiceResult<Int> {
        let target = id2DownloadEntity[downloadID]
        target!.manualPausedDownload()
        await updateProgress()
        return ServiceResult<Int>(data: _calculateOngoingDownload())
    }
    
    
    
    
}
