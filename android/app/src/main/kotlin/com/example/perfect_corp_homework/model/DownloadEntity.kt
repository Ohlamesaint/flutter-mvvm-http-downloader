package com.example.perfect_corp_homework.model

import FileEntity
import com.example.perfect_corp_homework.repository.Waiter

class DownloadEntity(
    val downloadID: String,
    val url: String,
    val totalLength: Int,
    var currentLength: Int = 0,
    var status: DownloadStatus = DownloadStatus.pending,
    val fileEntity: FileEntity,
){
//    val waiter: Waiter = Waiter()

    fun updateProgress (length: Int) {
        currentLength+=length
    }
//
//    fun pauseDownload() {
//        waiter.
//    }

}

