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
    case NoInternetError
    
    var message: String {
        switch self {
        case .BadRequestError:
            return Constants.kBadRequestErrorMessage
        case .UnsupportedMediaTypeError:
            return Constants.kUnSupportMediaTypeErrorMessage
        case .NoInternetError:
            return Constants.kNoInternetErrorMessage
        case .UnknownError(let message):
            return message
        }
    }
    
}
