//
//  URLCacheManagerTests.swift
//  SwiftyNetworking
//
//  Created by Maxim Makhun on 11/19/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

import XCTest

class URLCacheManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThat_dataRequest_shouldHandleCacheReuse() {
        print("Started cache request")
        
        // make session task synchronous
        let expectation: XCTestExpectation = self.expectation(description: "Simple request expectation")
        
        // make request
        let session = URLSession.shared
        var sessionTask: URLSessionTask = URLSessionTask()
        
        sessionTask = session.dataTask(with: Constants.requestURL) { (data, response, error) in
            XCTAssertNil(error, "Error should be nil")

            if let data = data {
                URLCacheManager.sharedInstance.cacheData(for: sessionTask, data: data)
                print("Original data: \(data)")
            } else {
                XCTAssertNotNil(data, "Data should not be nil")
            }

            // attempt to load data from cache
            if let cachedData = URLCacheManager.sharedInstance.cache(for: sessionTask) {
                print("Cached data: \(cachedData)")
            } else {
                print("Cached response data not found")
                XCTAssertFalse(true, "Cached response should be found")
            }
            
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                XCTAssertEqual(httpResponse.statusCode, 200, "Response status code should be 200 - OK")
            } else {
                XCTAssertNotNil(response, "Response should not be nil")
            }
            
            expectation.fulfill()
        }
        sessionTask.resume()

        // wait for expectation with timeout
        self.waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error, "Web resource is not accessible")
        }
        
        // remove all cached response data
        URLCacheManager.sharedInstance.removeAllCachedResponses()
        
        let cachedData = URLCacheManager.sharedInstance.cache(for: sessionTask)
        XCTAssertNil(cachedData, "Cached data should be nil")
        
        print("Finished cache request")
    }
}
