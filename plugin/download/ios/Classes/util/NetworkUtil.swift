//
//  NetworkUtil.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

class NetworkUtil {
    private init() {}
    static func getHeaders(from url: URL)  async throws -> HTTPURLResponse {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {throw AppError.BadRequestError}
        
        return (response as! HTTPURLResponse)
//
//        let task = URLSession.shared.dataTask(with: request) {
//            _, response, error in
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("Download error: \(String(describing: error))")
//                completion(nil)
//                return
//            }
//            completion(Int64(httpResponse.value(forHTTPHeaderField: "Content-Length") ?? "0"))
    }
    
    
    
    static func downloadWithRange(source url: URL, from start: Int, to end: Int, destination tempFile: URL) async {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("bytes=\(start)-\(end)", forHTTPHeaderField: "Range")
        
        
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("response: \((response as? HTTPURLResponse)?.statusCode)")
            guard(response as? HTTPURLResponse)?.statusCode == 206 else {throw AppError.BadRequestError}
            
            print("fine! \(data.count)")
            FileUtil.storeByteStreamToFile(from: data, to: tempFile)

            
        } catch {
            print(error)
        }
        
    }
    
    
    
}
