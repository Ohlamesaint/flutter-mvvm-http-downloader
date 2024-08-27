package com.example.perfect_corp_homework.download.api

import com.example.perfect_corp_homework.download.exception.BadRequestError
import com.example.perfect_corp_homework.download.exception.JsonSerializationError
import com.example.perfect_corp_homework.download.exception.NoInternetError
import com.example.perfect_corp_homework.download.exception.UnSupportImageTypeError
import com.example.perfect_corp_homework.download.exception.UnknownError

class MethodChannelResponse<T>(serviceResult: ServiceResult<T>) {

    val statusCode: Int = when(serviceResult.error) {
        is UnSupportImageTypeError -> 10000
        is BadRequestError -> 10001
        is NoInternetError -> 10002
        is UnknownError -> 10003
        is JsonSerializationError -> 10004
        is Exception -> 10003
        else -> 0
    }
    val errorMessage: String? = serviceResult.error?.message
    val data: T? = serviceResult.data
}