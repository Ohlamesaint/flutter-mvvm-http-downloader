package com.example.perfect_corp_homework.api

class ServiceResult<T> {

    constructor(error: Exception) {
        this.isSuccess = false
        this.error = error
        this.data = null
    }

    constructor(data: T) {
        this.isSuccess = true
        this.error = null
        this.data = data
    }

    val isSuccess: Boolean
    val error: Exception?
    val data: T?

}