package com.example.perfect_corp_homework.download

import android.util.Log
import com.example.perfect_corp_homework.download.api.MethodChannelResponse
import com.example.perfect_corp_homework.download.model.DownloadEntity
import com.example.perfect_corp_homework.download.repository.DownloadRepositoryImpl
import com.example.perfect_corp_homework.download.service.DownloadService
import com.example.perfect_corp_homework.download.service.DownloadServiceImpl
import com.google.gson.Gson

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import org.slf4j.LoggerFactory

/** DownloadPlugin */
class DownloadPlugin: FlutterPlugin, MethodCallHandler {

  companion object {
    private val METHOD_CHANNEL = "http_downloader/download"
    private val PROGRESS_EVENT_CHANNNEL = "http_downloader/download/progress"
    private val FINISH_EVENT_CHANNEL = "http_downloader/download/finished"

    private val downloadService: DownloadService = DownloadServiceImpl(DownloadRepositoryImpl())
    private val log = LoggerFactory.getLogger("MainActivity")

    private var progressEventSink: EventChannel.EventSink? = null
    var finishedEventSink: EventChannel.EventSink? = null


    val gson = Gson()

    val sendProgressEvent = { downloads: List<DownloadEntity> ->
      progressEventSink!!.success(gson.toJson(downloads))
    }

    val sendFinishedEvent = { downloadEntity: DownloadEntity ->
      finishedEventSink!!.success(gson.toJson(downloadEntity))
    }
  }

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL)
    channel.setMethodCallHandler(this)


    var progressEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, PROGRESS_EVENT_CHANNNEL).setStreamHandler(
      object: EventChannel.StreamHandler{
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          log.info("progressEventChannel Constructed")
          progressEventSink = events
        }

        override fun onCancel(arguments: Any?) {
          log.info("progressEvent Canceled")
          progressEventSink = null
        }

      }
    )

    var finishedEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, FINISH_EVENT_CHANNEL).setStreamHandler(
      object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          log.info("finishedEventChannel Constructed")
          finishedEventSink = events
        }

        override fun onCancel(arguments: Any?) {
          log.info("finishedEventChannel Canceled")
          finishedEventSink = null
        }
      }
    )
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "createDownload" -> runBlocking {
        val urlString: String = call.argument<String>("urlString") as String
        val isConcurrent: Boolean = call.argument<Boolean>("isConcurrent") as Boolean

        launch(Dispatchers.Default) {

          val serviceResult = downloadService.createDownload(urlString = urlString, isConcurrent = isConcurrent)

          val methodChannelResponse = MethodChannelResponse<Int>(serviceResult)

          val jsonString = gson.toJson(methodChannelResponse)

          result.success(jsonString)
        }
      }
      "pauseDownload" -> runBlocking {
        launch(Dispatchers.Main) {
          val downloadID: String = call.argument<String>("downloadID") as String
          val serviceResult = downloadService.pauseDownload(downloadID = downloadID)
          val methodChannelResponse = MethodChannelResponse<Int>(serviceResult)
          val jsonString = gson.toJson(methodChannelResponse)
          result.success(jsonString)
        }
      }
      "resumeDownload" -> runBlocking {
        launch(Dispatchers.Main) {
          val downloadID: String = call.argument<String>("downloadID") as String
          val serviceResult = downloadService.resumeDownload(downloadID = downloadID)
          val methodChannelResponse = MethodChannelResponse<Int>(serviceResult)
          val jsonString = gson.toJson(methodChannelResponse)
          result.success(jsonString)
        }
      }
      "cancelDownload" -> runBlocking {
        launch(Dispatchers.Main) {
        val downloadID: String = call.argument<String>("downloadID") as String
        val serviceResult = downloadService.cancelDownload(downloadID = downloadID)
        val methodChannelResponse = MethodChannelResponse<Int>(serviceResult)
        val jsonString = gson.toJson(methodChannelResponse)
        result.success(jsonString)
        }
      }
      "manualPauseDownload" -> runBlocking {
        launch(Dispatchers.IO) {
          val downloadID: String = call.argument<String>("downloadID") as String
          val serviceResult = downloadService.pauseDownload(downloadID = downloadID)
          val methodChannelResponse = MethodChannelResponse<Int>(serviceResult)
          val jsonString = gson.toJson(methodChannelResponse)
          result.success(jsonString)
        }
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
