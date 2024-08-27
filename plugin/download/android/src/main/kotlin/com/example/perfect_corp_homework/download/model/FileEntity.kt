package com.example.perfect_corp_homework.download.model

import java.io.File

data class FileEntity(
    val filename: String,
    val fileType: String,
    val thumbnailPath: String,
    val imagePath: String,
    val temporaryImagePath: String
) {

    fun deleteTempFile() {
        File(temporaryImagePath).delete()
    }
}