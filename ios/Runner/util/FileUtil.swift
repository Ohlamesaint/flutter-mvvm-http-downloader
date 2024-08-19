//
//  FileUtil.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

class FileUtil {
    private init() {}
    static func combineFiles(fileSegments: [URL], to destination: URL, chunkSize: Int = 1000000) async throws {
        FileManager.default.createFile(atPath: destination.path, contents: nil)
        
        
        let writer = try FileHandle(forWritingTo: destination)
        defer {
            if #available(iOS 13.0, *) {
                do{
                    try writer.close()
                } catch {
                    print("file close failed")
                }
            } else {
                writer.closeFile()
            }
        }
        
        for fileSegment in fileSegments {
            let fileData = try Data(contentsOf: fileSegment)
            
            writer.seekToEndOfFile()
            writer.write(fileData)
        }
    }
}
