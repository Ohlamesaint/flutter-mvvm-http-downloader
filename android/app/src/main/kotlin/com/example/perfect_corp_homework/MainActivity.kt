package com.example.perfect_corp_homework

import android.os.Handler
import androidx.annotation.NonNull
import com.example.perfect_corp_homework.api.MethodChannelResponse
import com.example.perfect_corp_homework.model.DownloadEntity
import com.example.perfect_corp_homework.repository.DownloadRepositoryImpl
import com.example.perfect_corp_homework.service.DownloadService
import com.example.perfect_corp_homework.service.DownloadServiceImpl
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import org.slf4j.LoggerFactory

class MainActivity: FlutterActivity() {
    companion object {
        private val METHOD_CHANNEL = "http_downloader/download"
        private val PROGRESS_EVENT_CHANNNEL = "http_downloader/download/progress"
        private val FINISH_EVENT_CHANNEL = "http_downloader/download/finished"

        private val downloadService: DownloadService = DownloadServiceImpl(DownloadRepositoryImpl())
        private val log = LoggerFactory.getLogger("MainActivity")

        private var progressEventSink: EventChannel.EventSink? = null
        var finishedEventSink: EventChannel.EventSink? = null


        private val gson = Gson()

        val updateProgress = { downloads: List<DownloadEntity> ->
            log.info(downloads.toString())
            log.info((progressEventSink==null).toString())
            progressEventSink!!.success(gson.toJson(downloads))
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        var progressEventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, PROGRESS_EVENT_CHANNNEL).setStreamHandler(
            object: EventChannel.StreamHandler{
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    log.info("progressEventChannel Constructed")
                    progressEventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    progressEventSink = null
                }
            }
        )

        var finishedEventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, FINISH_EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    log.info("finishedEventChannel Constructed")
                    finishedEventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    finishedEventSink = null
                }
            }
        )

        // background isolate configuration
        val taskQueue =
            flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL, StandardMethodCodec.INSTANCE,
            taskQueue).setMethodCallHandler {
            call, result ->
            when(call.method) {
                "createDownload" -> runBlocking {
                    val urlString: String = call.argument<String>("urlString") as String
                    launch(Dispatchers.IO) {
                        val serviceResult = downloadService.createDownload(urlString = urlString)
                        val methodChannelResponse = MethodChannelResponse<Int>(serviceResult)
                        val jsonString = gson.toJson(methodChannelResponse)
                        result.success(jsonString)
                    }
                }
                "pauseDownload" -> {
                    val downloadID: String = call.argument<String>("downloadID") as String
                    val serviceResult = downloadService.pauseDownload(downloadID = downloadID)
                    val methodChannelResponse = MethodChannelResponse<Int>(serviceResult)
                    val jsonString = gson.toJson(methodChannelResponse)
                    result.success(jsonString)
                }
                "resumeDownload" -> {
                    val downloadID: String = call.argument<String>("downloadID") as String
                    val serviceResult = downloadService.resumeDownload(downloadID = downloadID)
                    val methodChannelResponse = MethodChannelResponse<Int>(serviceResult)
                    val jsonString = gson.toJson(methodChannelResponse)
                    result.success(jsonString)
                }
                "cancelDownload" -> {
                    val downloadID: String = call.argument<String>("downloadID") as String
                    val serviceResult = downloadService.cancelDownload(downloadID = downloadID)
                    val methodChannelResponse = MethodChannelResponse<Int>(serviceResult)
                    val jsonString = gson.toJson(methodChannelResponse)
                    result.success(jsonString)
                }
                "manualPauseDownload" -> {
                    val downloadID: String = call.argument<String>("downloadID") as String
                    val serviceResult = downloadService.pauseDownload(downloadID = downloadID)
                    val methodChannelResponse = MethodChannelResponse<Int>(serviceResult)
                    val jsonString = gson.toJson(methodChannelResponse)
                    result.success(jsonString)
                }
            }

        }
    }
}