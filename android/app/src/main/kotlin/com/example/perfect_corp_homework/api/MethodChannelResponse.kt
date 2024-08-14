package com.example.perfect_corp_homework.api

class ServiceResultToMethodChannelResponseMapper<T> {

}

class MethodChannelResponse<T> {

    val statusCode: Int
    val errorMessage: String?
    val data: T?

    constructor(statusCode: Int, errorMessage: String) {
        this.statusCode = statusCode
        this.errorMessage = errorMessage
        this.data = null
    }

    constructor(statusCode: Int, data: T) {
        this.statusCode = 0
        this.errorMessage = null
        this.data = data
    }



}