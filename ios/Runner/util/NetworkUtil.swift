//
//  NetworkUtil.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

class NetworkUtil {
    private init() {}
    static func getContentLength(from url: URL, completion: @escaping (Int64?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        
        let task = URLSession.shared.dataTask(with: request) {
            _, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Download error: \(String(describing: error))")
                completion(nil)
                return
            }
            if #available(iOS 13, *) {
                completion(Int64(httpResponse.value(forHTTPHeaderField: "Content-Length") ?? "0"))
            } else {
                completion(Int64(httpResponse.value(forKey: "Content-Length") as? String ?? "0"))
            }
        }
    }
    
    static func downloadWithRange(source url: URL, from start: Int, to end: Int, destination tempFile: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("bytes=\(start)-\(end)", forHTTPHeaderField: "Range")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil else {
                print("Download error: \(String(describing: error))")
                return
            }
            
            let fileHandle: FileHandle?
        }
    }
    
}


protocol Base {
    
}

class Car {
    var proto: Base?
    
}
