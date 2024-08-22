//
//  MethodChannelResponse.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/20.
//

import Foundation


class MethodChannelResponse<T: Encodable>{
    
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


extension MethodChannelResponse: Encodable {
    enum CodingKeys: String, CodingKey {
        case statusCode
        case errorMessage
        case data
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(statusCode, forKey: .statusCode)
        try? container.encode(errorMessage, forKey: .errorMessage)
        try? container.encode(data, forKey: .data)
    }
}
