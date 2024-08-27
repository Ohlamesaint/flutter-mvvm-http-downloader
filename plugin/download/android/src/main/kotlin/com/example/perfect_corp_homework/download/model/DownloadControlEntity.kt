package com.example.perfect_corp_homework.download.model

interface DownloadControlEntity {

    suspend fun resumeDownload();
    fun pauseDownload();
    fun cancelDownload();
    fun downloadFinished();
}