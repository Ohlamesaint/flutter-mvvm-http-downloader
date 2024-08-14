package com.example.perfect_corp_homework.util

import kotlinx.coroutines.CancellableContinuation
import kotlinx.coroutines.CompletionHandler
import kotlinx.coroutines.delay
import kotlinx.coroutines.suspendCancellableCoroutine
import okhttp3.Call
import okhttp3.Callback
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import java.io.IOException
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.random.Random
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.BufferedInputStream
import java.io.FileOutputStream
import java.io.InputStream


class NetworkUtil private constructor() {

    companion object {


        suspend fun getTargetLength(urlString: String): String {

            val request = Request.Builder().head().url(urlString).build()
            try {
                val response = OkHttpClient().newCall(request).await()
                return response.headers["content-length"] as String
            } catch (e: Exception) {
                println(e.message)
                return e.message as String
            }

        }

        suspend fun downloadWithRange(urlString: String, start: Int, end: Int, index: Int, ): InputStream {
            val request = Request.Builder().url(urlString).build()

            val response = OkHttpClient().newCall(request).await();

            if(response.body == null) {
                throw Exception("No Data")
            }
            return response.body!!.byteStream()
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