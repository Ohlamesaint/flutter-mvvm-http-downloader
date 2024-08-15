package com.example.perfect_corp_homework.service

import com.example.perfect_corp_homework.api.ServiceResult
import com.example.perfect_corp_homework.model.DownloadEntity
import kotlinx.coroutines.CoroutineScope
import java.util.function.Consumer

interface DownloadService: CoroutineScope{
    suspend fun createDownload(urlString: String): ServiceResult<Int>
    suspend fun startDownload(downloadEntity: DownloadEntity): Unit
    fun pauseDownload(downloadID: String): ServiceResult<Int>
    fun resumeDownload(downloadID: String): ServiceResult<Int>
    fun cancelDownload(downloadID: String): ServiceResult<Int>
    fun manualPauseDownload(downloadID: String): ServiceResult<Int>
}