package com.example.perfect_corp_homework.util

import android.os.Environment
import java.io.BufferedInputStream
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.util.UUID

class FileUtil private constructor() {

    companion object {

        private val externalStorageDirectory = Environment.getExternalStorageDirectory()
        private val downloadCacheDirectory = Environment.getDownloadCacheDirectory()

        fun combineFiles (fileSegments: List<File>, newPath: String) : File {
            val combinedFile = File(newPath)

        }

        fun storeByteStreamToFile(input: InputStream, filename: String, index: Int) {

            downloadCacheDirectory.mkdirs()

            val targetFile = downloadCacheDirectory.
            val bis = BufferedInputStream(input)
            val output = FileOutputStream()
        }

        fun generateFilename() : String {
            return UUID.randomUUID().toString()
        }





    }
}