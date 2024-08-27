package com.example.perfect_corp_homework.download.service

import android.util.Log
import com.example.perfect_corp_homework.download.api.ServiceResult
import com.example.perfect_corp_homework.download.DownloadPlugin
import com.example.perfect_corp_homework.download.model.DownloadEntity
import com.example.perfect_corp_homework.download.model.DownloadStatus
import com.example.perfect_corp_homework.download.repository.DownloadRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.slf4j.LoggerFactory
import kotlin.coroutines.CoroutineContext

class DownloadServiceImpl constructor(private val downloadRepository: DownloadRepository):
    DownloadService {

    private val log = LoggerFactory.getLogger("DownloadServiceImpl")

    private var id2DownloadEntity = mutableMapOf<String, DownloadEntity>()

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main

    override suspend fun createDownload(urlString: String, isConcurrent: Boolean) : ServiceResult<Int> {

        try {
            val downloadEntity = async(Dispatchers.IO) {
                downloadRepository.configureDownload(
                    urlString = urlString, isConcurrent = isConcurrent)
            }.await()
            id2DownloadEntity+=(downloadEntity.downloadID to downloadEntity)
            DownloadPlugin.sendProgressEvent(id2DownloadEntity.values.toList())

            startDownload(downloadEntity)
            return ServiceResult<Int>(data = calculateOngoingDownload())
        } catch (e: Exception) {
            Log.d("createDownload", e.message!!)
            return ServiceResult<Int>(error = e)
        }
    }


    val updateProgress = { pair: Pair<String, Int> -> {

        id2DownloadEntity[pair.first]!!.updateProgress(pair.second)
        DownloadPlugin.sendProgressEvent(id2DownloadEntity.values.toList())
    }}

    private fun calculateOngoingDownload(): Int {
        return id2DownloadEntity.values.filter { it ->  it.status == DownloadStatus.ongoing}.size
    }


    override suspend fun startDownload(downloadEntity: DownloadEntity): Unit {
        try {
            downloadEntity.status = DownloadStatus.ongoing
            DownloadPlugin.sendProgressEvent(id2DownloadEntity.values.toList())
            launch (Dispatchers.IO){
                downloadRepository.fetchImageWithUrl(downloadEntity = downloadEntity, updateProgress)
            }

        } catch (e: Exception) {
            throw e
        }
    }


    private fun ongoingDownloadCount(): Int {
        return id2DownloadEntity.values.filter { it.status == DownloadStatus.ongoing }.size
    }

    override fun pauseDownload(downloadID: String): ServiceResult<Int> {
        val target = id2DownloadEntity[downloadID]
        target!!.pauseDownload()
        DownloadPlugin.sendProgressEvent(id2DownloadEntity.values.toList())
        return ServiceResult(ongoingDownloadCount())
    }

    override suspend fun resumeDownload(downloadID: String): ServiceResult<Int> {
        val target = id2DownloadEntity[downloadID]
        launch (Dispatchers.IO){
            target!!.resumeDownload()
        }
        DownloadPlugin.sendProgressEvent(id2DownloadEntity.values.toList())
        return ServiceResult(ongoingDownloadCount())
    }

    override  fun cancelDownload(downloadID: String): ServiceResult<Int> {
        val target = id2DownloadEntity[downloadID]
        target!!.cancelDownload()
        DownloadPlugin.sendProgressEvent(id2DownloadEntity.values.toList())
        return ServiceResult(ongoingDownloadCount())
    }

    override  fun manualPauseDownload(downloadID: String): ServiceResult<Int> {
        val target = id2DownloadEntity[downloadID]
        target!!.manualPauseDownload()
        DownloadPlugin.sendProgressEvent(id2DownloadEntity.values.toList())
        return ServiceResult(ongoingDownloadCount())
    }
}