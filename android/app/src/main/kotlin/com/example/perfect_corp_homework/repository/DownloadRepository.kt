package com.example.perfect_corp_homework.repository

import kotlinx.coroutines.CoroutineScope

interface DownloadRepository {
    suspend fun fetchImageWithUrl(urlString: String): String
}