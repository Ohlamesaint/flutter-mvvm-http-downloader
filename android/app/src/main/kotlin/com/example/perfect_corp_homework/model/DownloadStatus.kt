package com.example.perfect_corp_homework.model

enum class DownloadStatus {
    pending, ongoing, paused,
    manualPaused,
    canceled,
    failed,
    done;
}