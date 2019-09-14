//
//  URLSessionProtocol.swift
//  CustomNSURLProtocol
//
//  Created by Maxim Makhun on 11/3/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

import Foundation

class URLSessionProtocol : URLProtocol, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    private var sessionTask: URLSessionTask!
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: self,
                                 delegateQueue: nil)
        self.sessionTask = session.dataTask(with: self.request)
        self.sessionTask.resume()
    }
    
    override func stopLoading() {
        self.sessionTask.cancel()
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        client?.urlProtocol(self,
                            didReceive: response,
                            cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
        
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
}
