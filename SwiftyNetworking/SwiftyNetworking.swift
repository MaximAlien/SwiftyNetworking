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
        print("Started request")
        
        // register custom protocol
        URLProtocol.registerClass(URLSessionProtocol.self)
        
        // make session task synchronous
        let semaphore = DispatchSemaphore(value: 0)
        
        // make request
        let session = URLSession.shared
        let sessionTask = session.dataTask(with: URL.init(string: "https://www.google.com/")!) { (data, response, error) in
            if (error == nil) {
                let httpResponse = response as! HTTPURLResponse
                print("Status code: \(httpResponse.statusCode) after request to: \(httpResponse.url)")
            }
            
            semaphore.signal()
        }
        sessionTask.resume()
        
        // wait for completion
        semaphore.wait()
        
        URLProtocol.unregisterClass(URLSessionProtocol.self)
        
        print("Finished request")
    }
}
