//
//  ServiceResult.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation


class ServiceResult<T> {
    
    let isSuccess: Bool
    let error: Error?
    let data: T?
    
    init(error: Error) {
        self.isSuccess = false
        self.error = error
        self.data = nil
    }
    
    init(data: T) {
        self.isSuccess = true
        self.error = nil
        self.data = data
    }
}
