package com.example.perfect_corp_homework.model

import FileEntity

class DownloadEntity(
    downloadID: String,
    url: String,
    totalLength: Int,
    currentLength: Int = 0,
    status: DownloadStatus = DownloadStatus.PENDING,

    fileEntity: FileEntity

){}

