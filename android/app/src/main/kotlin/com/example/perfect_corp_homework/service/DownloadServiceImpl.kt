package com.example.perfect_corp_homework.service

import com.example.perfect_corp_homework.MainActivity
import com.example.perfect_corp_homework.api.ServiceResult
import com.example.perfect_corp_homework.model.DownloadEntity
import com.example.perfect_corp_homework.model.DownloadStatus
import com.example.perfect_corp_homework.repository.DownloadRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.slf4j.LoggerFactory
import java.util.function.Consumer
import kotlin.coroutines.CoroutineContext

class DownloadServiceImpl constructor(private val downloadRepository: DownloadRepository): DownloadService {

    private val log = LoggerFactory.getLogger("DownloadServiceImpl")

    private var id2DownloadEntity = mutableMapOf<String, DownloadEntity>()

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main

    override suspend fun createDownload(urlString: String) : ServiceResult<Int>{

        try {
            val downloadEntity = async(Dispatchers.Default) {
                downloadRepository.fetchImageMetadata(
                    urlString = urlString,)
            }.await()

            id2DownloadEntity+=(downloadEntity.downloadID to downloadEntity)
            withContext(Dispatchers.Main) {
                MainActivity.sendProgressEvent(id2DownloadEntity.values.toList())
            }

            startDownload(downloadEntity)

            return ServiceResult<Int>(data = calculateOngoingDownload())
        } catch (e: Exception) {
            return ServiceResult<Int>(error = e)
        }
    }


    val updateProgress = { pair: Pair<String, Int> ->
        id2DownloadEntity[pair.first]!!.updateProgress(pair.second)
        MainActivity.sendProgressEvent(id2DownloadEntity.values.toList())
    }

    private fun calculateOngoingDownload(): Int {
        return id2DownloadEntity.values.filter { it ->  it.status == DownloadStatus.ongoing}.size
    }


    override suspend fun startDownload(downloadEntity: DownloadEntity): Unit {
        try {
            launch(Dispatchers.Default) {
                withContext(Dispatchers.Main) {
                    downloadEntity.status = DownloadStatus.ongoing
                    MainActivity.sendProgressEvent(id2DownloadEntity.values.toList())
                }
                downloadRepository.fetchImageWithUrl(downloadEntity = downloadEntity, updateProgress)
            }
        } catch (e: Exception) {
            throw e
        }
    }


    private fun ongoingDownloadCount(): Int {
        return id2DownloadEntity.values.filter { it.status == DownloadStatus.ongoing }.size
    }

    override suspend fun pauseDownload(downloadID: String): ServiceResult<Int> {
        val target = id2DownloadEntity[downloadID]
        target!!.pauseDownload()
        withContext(Dispatchers.Main){
            MainActivity.sendProgressEvent(id2DownloadEntity.values.toList())
        }
        return ServiceResult(ongoingDownloadCount())
    }

    override suspend fun resumeDownload(downloadID: String): ServiceResult<Int> {
        val target = id2DownloadEntity[downloadID]
        target!!.resumeDownload()
        withContext(Dispatchers.Main){
            MainActivity.sendProgressEvent(id2DownloadEntity.values.toList())
        }
        return ServiceResult(ongoingDownloadCount())
    }

    override suspend fun cancelDownload(downloadID: String): ServiceResult<Int> {
        val target = id2DownloadEntity[downloadID]
        target!!.cancelDownload()
        withContext(Dispatchers.Main){
            MainActivity.sendProgressEvent(id2DownloadEntity.values.toList())
        }
        return ServiceResult(ongoingDownloadCount())
    }

    override suspend fun manualPauseDownload(downloadID: String): ServiceResult<Int> {
        val target = id2DownloadEntity[downloadID]
        target!!.manualPauseDownload()
        withContext(Dispatchers.Main){
            MainActivity.sendProgressEvent(id2DownloadEntity.values.toList())
        }
        return ServiceResult(ongoingDownloadCount())
    }
}