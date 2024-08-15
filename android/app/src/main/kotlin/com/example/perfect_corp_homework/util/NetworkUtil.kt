package com.example.perfect_corp_homework.util

import android.text.TextUtils
import kotlinx.coroutines.CancellableContinuation
import kotlinx.coroutines.CompletionHandler
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.delay
import kotlinx.coroutines.suspendCancellableCoroutine
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Headers
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import java.io.IOException
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

import org.slf4j.LoggerFactory
import java.io.File
import kotlin.coroutines.coroutineContext


class NetworkUtil private constructor() {

    companion object {

        private val log = LoggerFactory.getLogger("NetworkUtil")



        suspend fun getHeaders(urlString: String): Headers? {

            val request = Request.Builder().head().url(urlString).build()
            try {
                val response = OkHttpClient().newCall(request).await()
                return response.headers
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return null
        }

        suspend fun downloadWithRange(urlString: String, start: Int, end: Int, file: File): Unit {
            val request = Request.Builder().url(urlString).addHeader("range", "bytes=${start}-${end}").build()

            val response = OkHttpClient().newCall(request).await();

            if(response.body == null) {
                throw Exception("No Data")
            }

            FileUtil.storeByteStreamToFile(response.body!!.byteStream(), file)

            log.info("${coroutineContext[CoroutineName.Key]} is executing on thread : ${Thread.currentThread().name}, request completed, finished with length ${start}-${end} in ${file.name}")
            response.close()
        }
    }
}


// bridge function: extend okHttp call await functionality
internal suspend inline fun Call.await(): Response {
    return suspendCancellableCoroutine { continuation ->
        val callback = ContinuationCallback(this, continuation)
        enqueue(callback)
        continuation.invokeOnCancellation(callback)
    }
}

internal class ContinuationCallback(
    private val call: Call,
    private val continuation: CancellableContinuation<Response>
) : Callback, CompletionHandler {

    override fun onResponse(call: Call, response: Response) {
        continuation.resume(response)
    }

    override fun onFailure(call: Call, e: IOException) {
        if (!call.isCanceled()) {
            continuation.resumeWithException(e)
        }
    }

    override fun invoke(cause: Throwable?) {
        try {
            call.cancel()
        } catch (_: Throwable) {}
    }
}