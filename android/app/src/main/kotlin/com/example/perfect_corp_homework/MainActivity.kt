package com.example.perfect_corp_homework

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL = "http_downloader/download"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessager, METHOD_CHANNEL).setMethodCallHandler {
            call, result ->
            when(call.method) {
                "getDownloadListStream" -> print("getDownloadListStream")
                "createDownload" -> print("createDownload")
                "pauseDownload" -> print("pauseDownload")
                "resumeDownload" -> print("resumeDownload")
                "cancelDownload" -> print("cancelDownload")
                "finishDownload" -> print("finishDownload")
            }

        }
    }
}
