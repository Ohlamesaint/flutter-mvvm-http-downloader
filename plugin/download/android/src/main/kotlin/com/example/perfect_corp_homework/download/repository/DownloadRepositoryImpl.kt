package com.example.perfect_corp_homework.download.repository


import com.example.perfect_corp_homework.download.model.FileEntity
import android.os.Build
import android.webkit.MimeTypeMap
import androidx.annotation.RequiresApi
import com.example.perfect_corp_homework.download.DownloadPlugin
import com.example.perfect_corp_homework.download.model.ConcurrentDownloadControlEntity
import com.example.perfect_corp_homework.download.model.SequentialDownloadControlEntity
import com.example.perfect_corp_homework.download.model.DownloadEntity
import com.example.perfect_corp_homework.download.model.DownloadStatus
import com.example.perfect_corp_homework.download.util.FileUtil
import com.example.perfect_corp_homework.download.util.NetworkUtil
import io.flutter.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.io.File
import java.nio.file.Files
import java.util.function.Consumer
import kotlin.io.path.deleteIfExists
import kotlin.math.min

var log: Logger = LoggerFactory.getLogger("DownloadRepository")

class DownloadRepositoryImpl() : DownloadRepository {

    private val LENGTH_PER_REQUEST: Int = 500000

    override suspend fun configureDownload(urlString: String, isConcurrent: Boolean): DownloadEntity {

            val headers = NetworkUtil.getHeaders(urlString)

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
                isConcurrent = isConcurrent,
                fileEntity = fileEntity,
            )
            return downloadEntity

    }

    @RequiresApi(Build.VERSION_CODES.O)
    suspend fun sequentialDownload (downloadEntity: DownloadEntity, updateProgress: Consumer<Pair<String, Int>>): Unit {
        val totalRequest =  downloadEntity.totalLength / LENGTH_PER_REQUEST +1

        val requests = List(totalRequest) { it }

        val downloadScope =
            CoroutineScope(Dispatchers.IO)
        val channel = Channel<Unit>(0);
        val sequentialDownloadControlEntity = SequentialDownloadControlEntity(channel = channel, downloadScope = downloadScope);
        downloadEntity.downloadControlEntity = sequentialDownloadControlEntity


        downloadScope.launch {
            val tempDirectory = Files.createTempDirectory(downloadEntity.fileEntity.filename)

            Log.d("DownloadRepositoryImpl", "requests Length: ${requests.size}")
            val internalChannel = Channel<Int>(0)

            requests.map { requestIndex ->

                if(downloadEntity.status == DownloadStatus.paused) {
                    channel.receive()
                    Log.d("DownloadRepositoryImpl", "Stopped")
                }
                Log.d("DownloadRepositoryImpl", "$requestIndex request started")
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

                internalChannel.send(length)
            }

            repeat(totalRequest) { index ->
                val length = internalChannel.receive()
                withContext(Dispatchers.Main) {
                    updateProgress.accept(Pair(downloadEntity.downloadID, length))
                }
                if(index==totalRequest-1) {
                    FileUtil.combineFiles(
                        tempDirectory.toFile().listFiles()!!.toMutableList().sortedBy { it.name.split('_')[0].toInt()  },
                        File(downloadEntity.fileEntity.temporaryImagePath)
                    )
                    tempDirectory.deleteIfExists()
                    withContext(Dispatchers.Main) {
                        DownloadPlugin.finishedEventSink!!.success(DownloadPlugin.gson.toJson(downloadEntity))
                    }
                }
            }
        }



    }

    @RequiresApi(Build.VERSION_CODES.O)
    private suspend fun concurrentDownload(downloadEntity: DownloadEntity, updateProgress: Consumer<Pair<String, Int>>): Unit {
        val totalRequest =  downloadEntity.totalLength / LENGTH_PER_REQUEST +1

        val requests = List(totalRequest) { it }

        val downloadScope = CoroutineScope(Dispatchers.IO)
        val downloadControlEntity = ConcurrentDownloadControlEntity(downloadScope = downloadScope)
        downloadEntity.downloadControlEntity = downloadControlEntity
        Log.d("DownloadRepositoryImpl", "In ConcurrentDownload")


        downloadScope.launch {
            val tempDirectory = Files.createTempDirectory(downloadEntity.fileEntity.filename)
            Log.d("DownloadRepositoryImpl", "requests Length: ${requests.size}")

            requests.map { requestIndex ->

                Log.d("DownloadRepositoryImpl", "$requestIndex request started")
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
                withContext(Dispatchers.Main) {
                    updateProgress.accept(Pair(downloadEntity.downloadID, length))
                }
            }
            withContext(Dispatchers.Main) {
                FileUtil.combineFiles(
                    tempDirectory.toFile().listFiles()!!.toMutableList().sortedBy { it.name.split('_')[0].toInt()  },
                    File(downloadEntity.fileEntity.temporaryImagePath)
                )
                tempDirectory.deleteIfExists()
                DownloadPlugin.finishedEventSink!!.success(DownloadPlugin.gson.toJson(downloadEntity))
            }
        }

    }


    @RequiresApi(Build.VERSION_CODES.O)
    override suspend fun fetchImageWithUrl(downloadEntity: DownloadEntity, updateProgress: Consumer<Pair<String, Int>>): Unit {

        if(downloadEntity.isConcurrent) {
            concurrentDownload(downloadEntity = downloadEntity, updateProgress = updateProgress)
        } else {
            sequentialDownload(downloadEntity = downloadEntity, updateProgress = updateProgress)
        }
    }


}