//
//  FileEntity.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/20.
//

import Foundation

class FileEntity {
    let filename: String
    let fileType: String
    let temporaryImagePath: String
    
    init(filenme: String, fileType: String, temporaryImagePath: String) {
        self.filename = filenme
        self.fileType = fileType
        self.temporaryImagePath = temporaryImagePath
    }
}
