//
//  URLCacheManager.swift
//  SwiftyNetworking
//
//  Created by Maxim Makhun on 11/4/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

import Foundation

class URLCacheManager : URLCache {

    override init() {
        super.init()
    }
    
    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        let cachedResponse = self.cachedResponse(for: request)
        
        return cachedResponse;
    }
    
    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        
    }
    
    public func cacheData(for task: URLSessionTask, data: Data) {
        
    }

    public func cache(for task: URLSessionTask) -> Data? {
        return nil
    }
}
