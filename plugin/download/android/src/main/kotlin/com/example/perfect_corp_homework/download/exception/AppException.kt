package com.example.perfect_corp_homework.download.exception

import com.example.perfect_corp_homework.download.kBadRequestErrorMessage
import com.example.perfect_corp_homework.download.kNoInternetErrorMessage
import com.example.perfect_corp_homework.download.kUnSupportMediaTypeErrorMessage

open class AppException(): Exception()

class UnSupportImageTypeError(): AppException() {
    override val message: String
        get() = kUnSupportMediaTypeErrorMessage
}

class BadRequestError(): AppException() {
    override val message: String
        get() = kBadRequestErrorMessage
}

class NoInternetError(): AppException() {
    override val message: String
        get() = kNoInternetErrorMessage
}

class UnknownError(private var error: Exception): AppException() {
    override val message: String
            get() = "UnExpected Error: ${error.message}"
    override val cause: Throwable
        get() = error
}

class JsonSerializationError(private var error: Exception): AppException() {
    override val message: String
        get() = "JsonSerializationError: ${error.message}"
}
