//
//  URLCacheManager.swift
//  SwiftyNetworking
//
//  Created by Maxim Makhun on 11/4/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

import Foundation

let kCacheSize = 20 * 1024 * 1024;
let kExpirationKey = "expiration_key";

class URLCacheManager : URLCache {
    
    static let sharedInstance = URLCacheManager()

    // MARK: - Initialization methods
    
    override init() {
        super.init()
        
        let urlCache = URLCache.init(memoryCapacity: kCacheSize, diskCapacity: kCacheSize, diskPath: nil)
        URLCache.shared = urlCache
    }
    
    override init(memoryCapacity: Int, diskCapacity: Int, diskPath path: String?) {
        super.init(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: path)
    }
    
    // MARK: - Cache read/write methods
    
    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        let cachedResponse = super.cachedResponse(for: request)
        
        return cachedResponse;
    }
    
    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        var userInfo = [String : AnyObject]()
        userInfo[kExpirationKey] = Date.init() as AnyObject?
        
        let cachedURLResponse = CachedURLResponse.init(response: cachedResponse.response,
                                                       data: cachedResponse.data,
                                                       userInfo: userInfo,
                                                       storagePolicy: cachedResponse.storagePolicy)
        
        super.storeCachedResponse(cachedURLResponse, for: request)
    }
    
    // MARK: - Caching helper methods
    
    public func cacheData(for task: URLSessionTask, data: Data) {
        let cachedResponse = CachedURLResponse.init(response: task.response!, data: data)
        
        URLCacheManager.sharedInstance.storeCachedResponse(cachedResponse, for: task.currentRequest!)
    }

    public func cache(for task: URLSessionTask) -> Data? {
        return URLCacheManager.sharedInstance.cachedResponse(for: task.currentRequest!)?.data
    }
}
