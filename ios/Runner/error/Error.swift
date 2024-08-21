//
//  error.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation


enum AppError: Error {
    case BadRequestError
    case UnsupportedMediaTypeError
    case UnknownError(String)
    
    var message: String {
        switch self {
        case .BadRequestError:
            return Constants.kBadRequestErrorMessage
        case .UnsupportedMediaTypeError:
            return Constants.kUnSupportMediaTypeErrorMessage
        case .UnknownError(let message):
            return message
        }
    }
    
}
