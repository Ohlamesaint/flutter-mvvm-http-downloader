package com.example.perfect_corp_homework.service

import com.example.perfect_corp_homework.repository.DownloadRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlin.coroutines.CoroutineContext

class DownloadServiceImpl constructor(private val downloadRepository: DownloadRepository): DownloadService {


    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main

    override suspend fun createDownload(urlString: String) : String{

         return async (Dispatchers.Default) {
            downloadRepository.fetchImageWithUrl(urlString = urlString)
        }.await()
    }

    override fun pauseDownload(downloadID: String) {
        TODO("Not yet implemented")
    }

    override fun resumeDownload(downloadID: String) {
        TODO("Not yet implemented")
    }

    override fun cancelDownload(downloadID: String) {
        TODO("Not yet implemented")
    }

    override fun finishDownload() {
        TODO("Not yet implemented")
    }

    override fun getDownloadListStream() {
        TODO("Not yet implemented")
    }
}