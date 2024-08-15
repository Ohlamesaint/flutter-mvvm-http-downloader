package com.example.perfect_corp_homework.exception

open class AppException(message: String): Exception(message)

class UnSupportImageTypeError(message: String): AppException(message)

class BadRequestError(message: String): AppException(message)

class NoInternetError(message: String): AppException(message)

class UnknownError(message: String): AppException(message)

class JsonSerializationError(message: String): AppException(message)