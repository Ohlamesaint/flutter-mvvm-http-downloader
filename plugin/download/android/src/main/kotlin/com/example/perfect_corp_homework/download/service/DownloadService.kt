package com.example.perfect_corp_homework.download.service

import com.example.perfect_corp_homework.download.api.ServiceResult
import com.example.perfect_corp_homework.download.model.DownloadEntity
import kotlinx.coroutines.CoroutineScope

interface DownloadService: CoroutineScope{
    suspend fun createDownload(urlString: String, isConcurrent: Boolean): ServiceResult<Int>
    suspend fun startDownload(downloadEntity: DownloadEntity): Unit
    suspend fun pauseDownload(downloadID: String): ServiceResult<Int>
    suspend fun resumeDownload(downloadID: String): ServiceResult<Int>
    suspend fun cancelDownload(downloadID: String): ServiceResult<Int>
    suspend fun manualPauseDownload(downloadID: String): ServiceResult<Int>
}