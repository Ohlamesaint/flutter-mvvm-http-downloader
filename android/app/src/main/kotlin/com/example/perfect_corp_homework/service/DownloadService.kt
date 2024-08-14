package com.example.perfect_corp_homework.service

import kotlinx.coroutines.CoroutineScope

interface DownloadService: CoroutineScope{
    suspend fun createDownload(urlString: String): String
    fun pauseDownload(downloadID: String)
    fun resumeDownload(downloadID: String)
    fun cancelDownload(downloadID: String)
    fun finishDownload()
    fun getDownloadListStream()
}