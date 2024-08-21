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
            do{
                try writer.close()
            } catch {
                
            }
            
        }
        
        for fileSegment in fileSegments {
            let fileData = try Data(contentsOf: fileSegment)
            
            writer.seekToEndOfFile()
            writer.write(fileData)
        }
    }
    
    static func storeByteStreamToFile(from input: Data, to file: URL) {
        do {
            try input.write(to: file)
        } catch {
            print(error)
        }
        
    }
    
    static func createTempDirectory(withName dirName: String) throws -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        
        let dirURL = tempDirectory.appendingPathComponent(dirName)
        
        try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
        
        return dirURL
    }
    
    static func createTempFile(withName filename: String, andType filetype: String) -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        
        let fileURL = tempDirectory.appendingPathComponent(filename+"."+filetype)
        
        FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
        
        return fileURL
        
    }

    static func generateFileName() -> String {
        return UUID.init().uuidString
    }
}
