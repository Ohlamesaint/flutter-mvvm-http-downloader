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


extension FileEntity: Encodable {
    enum CodingKeys: String, CodingKey {
        case filename
        case fileType
        case temporaryImagePath
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(filename, forKey: .filename)
        try container.encode(fileType, forKey: .fileType)
        try container.encode(temporaryImagePath.replacingOccurrences(of: "file://", with: ""), forKey: .temporaryImagePath)
    }
}
