package com.example.perfect_corp_homework.util

import android.content.Context
import android.net.ConnectivityManager
import android.util.Log
import com.example.perfect_corp_homework.exception.BadRequestError
import com.example.perfect_corp_homework.exception.NoInternetError
import com.example.perfect_corp_homework.exception.UnknownError
import kotlinx.coroutines.CancellableContinuation
import kotlinx.coroutines.CompletionHandler
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.suspendCancellableCoroutine
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Headers
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import org.slf4j.LoggerFactory
import java.io.File
import java.io.IOException
import kotlin.coroutines.coroutineContext
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException


class NetworkUtil private constructor() {

    companion object {

        private val log = LoggerFactory.getLogger("NetworkUtil")


        suspend fun getHeaders(urlString: String): Headers {

            val request = Request.Builder().head().url(urlString).build()
            try {
                val response = OkHttpClient().newCall(request).await()
                return response.headers
            } catch (e: IllegalArgumentException) {
                throw BadRequestError()
            } catch (e: IllegalStateException) {
                throw NoInternetError()
            } catch(e: Exception) {
                throw UnknownError(e)
            }
        }

        suspend fun downloadWithRange(urlString: String, start: Int, end: Int, file: File): Unit {

            try {
                val request = Request.Builder().url(urlString).addHeader("range", "bytes=${start}-${end}").build()

                val response = OkHttpClient().newCall(request).await();

                if(response.body == null) {
                    throw Exception("No Data")
                }

                FileUtil.storeByteStreamToFile(response.body!!.byteStream(), file)

                log.info("${coroutineContext[CoroutineName.Key]} is executing on thread : ${Thread.currentThread().name}, request completed, finished with length ${start}-${end} in ${file.name}")
                response.close()
            } catch(e: IllegalStateException) {
                Log.d("NetworkUtil", "downloadWithRange: Request early canceled")
            } catch(e: Exception) {
                throw UnknownError(e)
            }


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