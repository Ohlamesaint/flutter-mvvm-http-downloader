package com.example.perfect_corp_homework

import androidx.annotation.NonNull
import com.example.perfect_corp_homework.repository.DownloadRepositoryImpl
import com.example.perfect_corp_homework.service.DownloadService
import com.example.perfect_corp_homework.service.DownloadServiceImpl
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL = "http_downloader/download"
    private val downloadService: DownloadService = DownloadServiceImpl(DownloadRepositoryImpl())


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val taskQueue =
            flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL, StandardMethodCodec.INSTANCE,
            taskQueue).setMethodCallHandler {
            call, result ->
            when(call.method) {
                "getDownloadListStream" -> print("getDownloadListStream")
                "createDownload" -> runBlocking {
                    val urlString: String = call.argument<String>("urlString") as String
                    launch(Dispatchers.IO) {
                        val contentLength = downloadService.createDownload(urlString = urlString)
                        result.success(contentLength)
                    }
                }
                "pauseDownload" -> print("pauseDownload")
                "resumeDownload" -> print("resumeDownload")
                "cancelDownload" -> print("cancelDownload")
                "finishDownload" -> print("finishDownload")
            }

        }
    }
}