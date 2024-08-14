package com.example.perfect_corp_homework.repository

import android.util.Log
import com.example.perfect_corp_homework.util.NetworkUtil
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.isActive
import kotlinx.coroutines.job
import kotlinx.coroutines.withContext
import org.slf4j.Logger
import org.slf4j.LoggerFactory

import kotlin.math.min

var log: Logger = LoggerFactory.getLogger("DownloadRepository")

class DownloadRepositoryImpl() : DownloadRepository {

    private val LENGTH_PER_REQUEST: Int = 100000

    override suspend fun fetchImageWithUrl(urlString: String): String {
        val contentLength = NetworkUtil.getTargetLength(urlString).toInt()
        coroutineScope{


            val channel = Channel<Int>()

            val totalRequest =  contentLength / LENGTH_PER_REQUEST +1

            val requests = List(totalRequest) { it }
            val deferred = requests.map {requestIndex -> async {
                val fileData = NetworkUtil.downloadWithRange(
                    urlString = urlString,
                    start = requestIndex * LENGTH_PER_REQUEST,
                    end = min((requestIndex + 1) * LENGTH_PER_REQUEST, contentLength),
                    index = requestIndex
                )


                log.info("${coroutineContext[CoroutineName.Key]} is executing on thread : ${Thread.currentThread().name}, request $requestIndex completed, finished with length $length")
                channel.send(length)
            }}






            var progress: Int = 0
            repeat(totalRequest) {
                val completedRequest = channel.receive()
                progress += completedRequest
                print(progress)
            }

        }
        return contentLength.toString()
    }
}