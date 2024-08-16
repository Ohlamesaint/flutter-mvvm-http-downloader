package com.example.perfect_corp_homework.model

import FileEntity
import com.example.perfect_corp_homework.repository.Waiter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.broadcast
import kotlinx.coroutines.sync.Mutex
import java.io.File

class DownloadEntity(
    val downloadID: String,
    val url: String,
    val totalLength: Int,
    var currentLength: Int = 0,
    var status: DownloadStatus = DownloadStatus.pending,
    var channel: Channel<Unit>  = Channel<Unit>(),
    var scope: CoroutineScope? = null,
    val fileEntity: FileEntity,
){
//    val waiter: Waiter = Waiter()

    fun updateProgress (length: Int) {
        currentLength+=length
        if(currentLength==totalLength){
            status = DownloadStatus.done
        }
    }

    fun pauseDownload() {
        status = DownloadStatus.paused
    }

    fun cancelDownload() {
        status = DownloadStatus.canceled
        File(fileEntity.temporaryImagePath).delete()
        scope?.cancel()
    }

    fun manualPauseDownload() {
        status = DownloadStatus.manualPaused
    }

    fun resumeDownload() {
        status = DownloadStatus.ongoing
        channel.broadcast()
    }
//
//    fun pauseDownload() {
//        waiter.
//    }

}

