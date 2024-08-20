//
//  MethodChannelResponse.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/20.
//

import Foundation


class MethodChannelResponse<T> {
    
    let statusCode: Int
    let errorMessage: String?
    let data: T?
    
    init (serviceResult: ServiceResult<T>) {
        guard serviceResult.error == nil else {
            switch(serviceResult.error!) {
            case .UnsupportedMediaTypeError:
                statusCode = 10000
            case .BadRequestError:
                statusCode = 10001
            case .UnknownError(_):
                statusCode = 10003
            }
            data = nil
            errorMessage = serviceResult.error!.message
            return
        }
        
        statusCode = 0
        data = serviceResult.data
        errorMessage = ""
    }
}
