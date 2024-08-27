package com.example.perfect_corp_homework.download.model

import com.example.perfect_corp_homework.download.model.FileEntity
import com.example.perfect_corp_homework.download.model.DownloadControlEntity
import com.example.perfect_corp_homework.download.model.DownloadStatus

import java.io.File

class DownloadEntity(
    val downloadID: String,
    val url: String,
    val totalLength: Int,
    var currentLength: Int = 0,
    var status: DownloadStatus = DownloadStatus.pending,
    var isConcurrent: Boolean,
    var downloadControlEntity: DownloadControlEntity? = null,
    val fileEntity: FileEntity,
){

    fun updateProgress (length: Int) {
        currentLength+=length
        if(currentLength==totalLength){
            status = DownloadStatus.done
            downloadControlEntity!!.downloadFinished()
        }
    }

    fun pauseDownload() {
        status = DownloadStatus.paused
        downloadControlEntity!!.pauseDownload()
    }

    fun cancelDownload() {
        status = DownloadStatus.canceled
        File(fileEntity.temporaryImagePath).delete()
        downloadControlEntity!!.cancelDownload()
    }

    fun manualPauseDownload() {
        downloadControlEntity!!.pauseDownload()
        status = DownloadStatus.manualPaused
    }

    suspend fun resumeDownload() {
        downloadControlEntity!!.resumeDownload()
        status = DownloadStatus.ongoing
    }

}

