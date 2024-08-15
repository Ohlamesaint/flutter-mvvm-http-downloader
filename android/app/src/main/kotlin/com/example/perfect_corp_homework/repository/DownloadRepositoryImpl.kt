package com.example.perfect_corp_homework.repository


import FileEntity
import android.os.Build
import android.webkit.MimeTypeMap
import androidx.annotation.RequiresApi
import com.example.perfect_corp_homework.MainActivity
import com.example.perfect_corp_homework.model.DownloadEntity
import com.example.perfect_corp_homework.model.DownloadStatus
import com.example.perfect_corp_homework.util.FileUtil
import com.example.perfect_corp_homework.util.NetworkUtil
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.withContext
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.io.File
import java.nio.file.Files
import java.util.function.Consumer
import kotlin.math.min
import kotlin.system.measureTimeMillis

var log: Logger = LoggerFactory.getLogger("DownloadRepository")

class DownloadRepositoryImpl() : DownloadRepository {

    private val LENGTH_PER_REQUEST: Int = 500000

    override suspend fun fetchImageMetadata(urlString: String): DownloadEntity {
        val headers = NetworkUtil.getHeaders(urlString) ?: TODO("Handle Error")

        val contentLengthInfo = headers["Content-Length"]
        val mimeTypeInfo = headers["Content-Type"]
        val acceptRangesInfo = headers["Accept-Ranges"]

        val contentLength = contentLengthInfo?.toInt() ?: 0
        val isAcceptRange = acceptRangesInfo == "bytes"

        if(!isAcceptRange) {
            TODO("Handle Exception")
        }

        val mime = MimeTypeMap.getSingleton()

        val filename = FileUtil.generateRandomFilename()
        val fileExtension = mime.getExtensionFromMimeType(mimeTypeInfo)!!

        val tempImageFile = withContext(Dispatchers.IO) {
            File.createTempFile("${filename}_", ".${fileExtension}")
        }
        val fileEntity = FileEntity(
            filename = filename,
            fileType = fileExtension,
            thumbnailPath = "",
            imagePath = "",
            temporaryImagePath = tempImageFile.absolutePath
        )

        val downloadEntity = DownloadEntity(
            downloadID = filename,
            url = urlString,
            totalLength = contentLength,
            fileEntity = fileEntity,

            )
        return downloadEntity
    }


    @RequiresApi(Build.VERSION_CODES.O)
    override suspend fun fetchImageWithUrl(downloadEntity: DownloadEntity, updateProgress: Consumer<Pair<String, Int>>): Unit {

        val totalRequest =  downloadEntity.totalLength / LENGTH_PER_REQUEST +1

        val requests = List(totalRequest) { it }

        val time = measureTimeMillis {
            coroutineScope {
                val channel = Channel<Int>()
                val tempDirectory = Files.createTempDirectory(downloadEntity.fileEntity.filename)

                requests.map { requestIndex ->


                    async {
                        val tempFileSegment = File.createTempFile(
                            "${requestIndex}_${downloadEntity.fileEntity.filename}_",
                            null,
                            tempDirectory.toFile()
                        )
                        val start = requestIndex * LENGTH_PER_REQUEST
                        val end = min(
                            (requestIndex + 1) * LENGTH_PER_REQUEST - 1,
                            downloadEntity.totalLength-1
                        )
                        val length = end-start+1
                        NetworkUtil.downloadWithRange(
                            urlString = downloadEntity.url,
                            start = start,
                            end = end,
                            file = tempFileSegment
                        )
                        channel.send(length)
                    }
                }

                repeat(totalRequest) { index ->
                    val progress = channel.receive()
                    withContext(Dispatchers.Main) {
                        updateProgress.accept(Pair(downloadEntity.downloadID, progress))
                        if(index==totalRequest-1) {
                            MainActivity.finishedEventSink!!.success(MainActivity.gson.toJson(downloadEntity))
                        }
                    }
                }
                FileUtil.combineFiles(
                    tempDirectory.toFile().listFiles()!!.toMutableList().sortedBy { it.name.split('_')[0].toInt()  },
                    File(downloadEntity.fileEntity.temporaryImagePath)
                )
                log.info("file ${downloadEntity.fileEntity.temporaryImagePath} download complete")

            }

        }
        log.info("Elapsed Time: $time milliseconds, Total Bytes: ${downloadEntity.totalLength}")
    }
}

class Waiter(private val channel: Channel<Unit> = Channel<Unit>()) {
    suspend fun doWait() { channel.receive() }
    fun doNotify() {
        channel.trySend(Unit).isSuccess
    }
}