package com.example.perfect_corp_homework.service

import com.example.perfect_corp_homework.MainActivity
import com.example.perfect_corp_homework.api.ServiceResult
import com.example.perfect_corp_homework.model.DownloadEntity
import com.example.perfect_corp_homework.model.DownloadStatus
import com.example.perfect_corp_homework.repository.DownloadRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import org.slf4j.LoggerFactory
import java.util.function.Consumer
import kotlin.coroutines.CoroutineContext

class DownloadServiceImpl constructor(private val downloadRepository: DownloadRepository): DownloadService {

    private val log = LoggerFactory.getLogger("DownloadServiceImpl")

    private var id2DownloadEntity: Map<String, DownloadEntity> = mutableMapOf()

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main

    override suspend fun createDownload(urlString: String) : ServiceResult<Int>{

        try {
            val downloadEntity = async(Dispatchers.Default) {
                downloadRepository.fetchImageMetadata(
                    urlString = urlString,)
            }.await()

            id2DownloadEntity+=(downloadEntity.downloadID to downloadEntity)
            startDownload(downloadEntity)

            return ServiceResult<Int>(data = calculateOngoingDownload())
        } catch (e: Exception) {
            return ServiceResult<Int>(error = e)
        }
    }


    val updateProgress = { pair: Pair<String, Int> ->
        id2DownloadEntity[pair.first]!!.updateProgress(pair.second)
        MainActivity.updateProgress(id2DownloadEntity.values.toList())
    }

    private fun calculateOngoingDownload(): Int {
        return id2DownloadEntity.values.filter { it ->  it.status == DownloadStatus.ongoing}.size
    }


    override suspend fun startDownload(downloadEntity: DownloadEntity): Unit {
        try {
            launch(Dispatchers.Default) {
                downloadRepository.fetchImageWithUrl(downloadEntity = downloadEntity, updateProgress)
            }
        } catch (e: Exception) {
            throw e
        }
    }

    override fun pauseDownload(downloadID: String): ServiceResult<Int> {
        TODO("Not yet implemented")
    }

    override fun resumeDownload(downloadID: String): ServiceResult<Int> {
        TODO("Not yet implemented")
    }

    override fun cancelDownload(downloadID: String): ServiceResult<Int> {
        TODO("Not yet implemented")
    }

    override fun manualPauseDownload(downloadID: String): ServiceResult<Int> {
        TODO("Not yet implemented")
    }
}