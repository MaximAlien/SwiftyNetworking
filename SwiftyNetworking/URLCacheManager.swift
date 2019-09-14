//
//  URLCacheManager.swift
//  SwiftyNetworking
//
//  Created by Maxim Makhun on 11/4/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

import Foundation

final class URLCacheManager : URLCache {
    
    public static let sharedInstance = URLCacheManager()

    // MARK: - Initialization methods
    
    private override init() {
        super.init()
        
        let urlCache = URLCache(memoryCapacity: Constants.cacheSize, diskCapacity: Constants.cacheSize, diskPath: nil)
        URLCache.shared = urlCache
    }
    
    private override init(memoryCapacity: Int, diskCapacity: Int, diskPath path: String?) {
        super.init(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: path)
    }
    
    // MARK: - Cache read/write methods
    
    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        let cachedResponse = super.cachedResponse(for: request)

        // check whether cache has expired, if so it'll be removed
        if let expirationDate = cachedResponse?.userInfo?[Constants.cacheExpirationKey] as? Date {
            print("Cached response expiration date: \(expirationDate)")

            let currentDate: Date = Date()
            print("Current date: \(currentDate)")

            if currentDate.compare(expirationDate) == .orderedDescending {
                super.removeCachedResponse(for: request)
                return nil
            }
        }
        
        return cachedResponse
    }
    
    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        var userInfo = [String : AnyObject]()
        userInfo[Constants.cacheExpirationKey] = Date(timeIntervalSinceNow: Constants.cacheExpirationDuration) as AnyObject // expire cache after certain time
        
        let cachedURLResponse = CachedURLResponse(response: cachedResponse.response,
                                                  data: cachedResponse.data,
                                                  userInfo: userInfo,
                                                  storagePolicy: cachedResponse.storagePolicy)
        
        super.storeCachedResponse(cachedURLResponse, for: request)
    }
    
    // MARK: - Caching helper methods
    
    public func cacheData(for task: URLSessionTask, data: Data) {
        let cachedResponse = CachedURLResponse(response: task.response!, data: data)
        
        URLCacheManager.sharedInstance.storeCachedResponse(cachedResponse, for: task.currentRequest!)
    }

    public func cache(for task: URLSessionTask) -> Data? {
        return URLCacheManager.sharedInstance.cachedResponse(for: task.currentRequest!)?.data
    }
}
