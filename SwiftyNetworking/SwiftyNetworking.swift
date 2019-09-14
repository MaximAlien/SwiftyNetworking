//
//  SwiftyNetworking.swift
//  SwiftyNetworking
//
//  Created by Maxim Makhun on 11/4/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

import Foundation

class SwiftyNetworking {
    
    static func sendRequestThroughProtocol() {
        print("Started protocol request")
        
        // register custom protocol
        URLProtocol.registerClass(URLSessionProtocol.self)
        
        // make session task synchronous
        let semaphore = DispatchSemaphore(value: 0)
        
        // make request
        let session = URLSession.shared
        let sessionDataTask = session.dataTask(with: Constants.requestURL) { (data, response, error) in
            if let error = error {
                print("Error occured: \(error.localizedDescription)")
                return
            }

            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                print("Status code: \(httpResponse.statusCode) after request to: \(httpResponse.url!)")
            }

            semaphore.signal()
        }
        sessionDataTask.resume()
        
        // wait for completion
        semaphore.wait()
        
        URLProtocol.unregisterClass(URLSessionProtocol.self)
        
        print("Finished protocol request")
    }
    
    static func sendRequestAndCache() {
        print("Started cache request")
        
        // make session task synchronous
        let semaphore = DispatchSemaphore(value: 0)
        
        // make request
        let session = URLSession.shared
        var sessionTask: URLSessionTask = URLSessionTask()

        sessionTask = session.dataTask(with: Constants.requestURL) { (data, response, error) in
            if let error = error {
                print("Error occured: \(error.localizedDescription)")
            }

            if let data = data {
                URLCacheManager.sharedInstance.cacheData(for: sessionTask, data: data)
                print("Original data: \(data)")
            }

            // attempt to load data from cache
            if let cachedData = URLCacheManager.sharedInstance.cache(for: sessionTask) {
                print("Cached data: \(cachedData)")
            } else {
                print("Cached response data not found")
            }

            print("Waiting for cache to expire...")
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + Constants.cacheExpirationDuration + 5.0) {
                // attempt to load data from cache
                if let cachedData = URLCacheManager.sharedInstance.cache(for: sessionTask) {
                    print("Cached data: \(cachedData)")
                } else {
                    print("Cache has expired")
                }

                semaphore.signal()
            }
        }
        sessionTask.resume()
        
        // wait for completion
        semaphore.wait()
        
        print("Finished cache request")
    }
}
