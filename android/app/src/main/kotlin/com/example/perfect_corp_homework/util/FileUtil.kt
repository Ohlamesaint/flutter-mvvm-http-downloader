package com.example.perfect_corp_homework.util

import android.os.Environment
import com.example.perfect_corp_homework.repository.log
import java.io.BufferedInputStream
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.io.OutputStream
import java.util.UUID


class FileUtil private constructor() {

    companion object {

        private val externalStorageDirectory = Environment.getExternalStorageDirectory()
        private val downloadCacheDirectory = Environment.getDownloadCacheDirectory()

        fun combineFiles (fileSegments: List<File>, targetFile: File) : File {

            FileOutputStream(targetFile, true).use{ output ->
                for(fileSegment in fileSegments) {
                    fileSegment.forEachBlock(4096) { buffer, bytesRead ->
                        print(bytesRead)
                        output.write(buffer, 0, bytesRead)
                    }
                }
            }

            return targetFile
        }

        fun storeByteStreamToFile(input: InputStream, file: File) {

            val bufferedInputStream = BufferedInputStream(input)
            val output: OutputStream = FileOutputStream(file)

            val data = ByteArray(1024)

            var total: Long = 0
            var count = 0
            while ((bufferedInputStream.read(data).also { count = it }) != -1) {
                total += count
                output.write(data, 0, count)
            }

            output.flush()
            output.close()
            bufferedInputStream.close()
        }

        fun generateRandomFilename() : String {
            return UUID.randomUUID().toString()
        }





    }
}