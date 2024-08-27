package com.example.perfect_corp_homework.download.model

enum class DownloadStatus {
    pending, ongoing, paused,
    manualPaused,
    canceled,
    failed,
    done;
}