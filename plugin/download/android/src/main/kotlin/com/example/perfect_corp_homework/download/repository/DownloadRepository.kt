package com.example.perfect_corp_homework.download.repository

import com.example.perfect_corp_homework.download.model.DownloadEntity
import java.util.function.Consumer

interface DownloadRepository {
    suspend fun configureDownload(urlString: String, isConcurrent: Boolean): DownloadEntity
    suspend fun fetchImageWithUrl(downloadEntity: DownloadEntity, updateProgress: (Pair<String, Int>) -> () -> Unit): Unit
}