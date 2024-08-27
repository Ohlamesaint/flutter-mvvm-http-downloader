package com.example.perfect_corp_homework.download.model

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancel
import kotlinx.coroutines.channels.Channel

class SequentialDownloadControlEntity(val channel: Channel<Unit>, val downloadScope: CoroutineScope): DownloadControlEntity{


    override suspend fun resumeDownload() {
        channel.send(Unit)
    }

    override fun pauseDownload() {

    }

    override fun cancelDownload() {
        downloadScope.cancel()
    }

    override fun downloadFinished() {
        channel.close()
    }


}