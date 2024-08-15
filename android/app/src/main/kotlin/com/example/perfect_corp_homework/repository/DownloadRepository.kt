package com.example.perfect_corp_homework.repository

import com.example.perfect_corp_homework.model.DownloadEntity
import java.util.function.Consumer

interface DownloadRepository {
    suspend fun fetchImageMetadata(urlString: String): DownloadEntity
    suspend fun fetchImageWithUrl(downloadEntity: DownloadEntity, updateProgress: Consumer<Pair<String, Int>>): Unit
}