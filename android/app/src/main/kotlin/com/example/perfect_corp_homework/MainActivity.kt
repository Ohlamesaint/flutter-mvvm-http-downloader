package com.example.perfect_corp_homework

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL = "http_downloader/download"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessager, METHOD_CHANNEL).setMethodCallHandler {
            call, result ->
        }
    }
}
