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
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw AppError.BadRequestError
            }
            return (response as! HTTPURLResponse)
        } catch {
            if((error is URLError) && (error as! URLError).networkUnavailableReason != nil) {
                throw AppError.NoInternetError
            }
            throw AppError.UnknownError(error.localizedDescription)
        }
    }
    
    static func downloadWithRangeWithCompletion(source url: URL, from start: Int, to end: Int, destination tempFile: URL, completion handler : @escaping (Data?, URLResponse?, Error?) ->  Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("bytes=\(start)-\(end)", forHTTPHeaderField: "Range")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: handler)
        task.resume()
        
    }
    
    static func downloadWithRange(source url: URL, from start: Int, to end: Int, destination tempFile: URL) async {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("bytes=\(start)-\(end)", forHTTPHeaderField: "Range")
        
        
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard(response as? HTTPURLResponse)?.statusCode == 206 else {throw AppError.BadRequestError}
            
            FileUtil.storeByteStreamToFile(from: data, to: tempFile)

            
        } catch {
            print(error)
        }
        
    }
    
    
    
}
