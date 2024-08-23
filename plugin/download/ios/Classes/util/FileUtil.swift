//
//  FileUtil.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

class FileUtil {
    private init() {}

    
    static func combineFiles(fileSegments: [URL], to destination: URL, chunkSize: Int = 500000) async throws {
        FileManager.default.createFile(atPath: destination.path, contents: nil)
        
        
        let writer = try FileHandle(forWritingTo: destination)
        
        defer {
            do{
                try writer.close()
            } catch {
                
            }
        }
        
        for fileSegment in fileSegments {
            print("combineFile: \(fileSegment.lastPathComponent)), currentLength: \(try writer.offset())")
            try writer.seekToEnd()
            try writer.write(contentsOf: try Data(contentsOf: fileSegment.absoluteURL))
            try FileManager.default.removeItem(at: fileSegment)
        }
    }
    
    static func storeByteStreamToFile(from input: Data, to file: URL) {
        do {
            
            let fileHandle = try FileHandle(forWritingTo: file)
            try fileHandle.seekToEnd()
            try fileHandle.write(contentsOf: input)
            try fileHandle.close()
            print("\(file.absoluteString) ++ \(file.dataRepresentation.count) with \(input.count)")
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
        
        FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        
        return fileURL
        
    }

    static func generateFileName() -> String {
        return UUID.init().uuidString
    }
}
