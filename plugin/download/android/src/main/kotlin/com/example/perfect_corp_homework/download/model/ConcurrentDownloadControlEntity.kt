package com.example.perfect_corp_homework.download.model

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancel

class ConcurrentDownloadControlEntity(private val downloadScope: CoroutineScope): DownloadControlEntity {

    override suspend fun resumeDownload() {

    }

    override fun pauseDownload() {

    }

    override fun cancelDownload() {
        downloadScope.cancel();
    }

    override fun downloadFinished() {

    }
}