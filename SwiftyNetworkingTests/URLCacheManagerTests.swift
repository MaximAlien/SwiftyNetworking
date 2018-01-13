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
        let expectation: XCTestExpectation = self.expectation(description: "Simple request expectation.")
        
        // make request
        let session = URLSession.shared
        var sessionTask: URLSessionTask = URLSessionTask()
        
        sessionTask = session.dataTask(with: URL.init(string: "https://www.google.com/")!) { (data, response, error) in
            XCTAssertNil(error, "Request should end up without an error.")
            
            var respData: Data
            
            if (error == nil) {
                respData = data!
                URLCacheManager.sharedInstance.cacheData(for: sessionTask, data: respData)
            } else {
                respData = URLCacheManager.sharedInstance.cache(for: sessionTask)!
            }
            
            XCTAssertNotNil(respData, "Data should have non nil value.")
            print("Data: \(respData)")
            
            var httpResponse: HTTPURLResponse
            httpResponse = response as! HTTPURLResponse
            
            XCTAssertTrue(httpResponse.statusCode == 200, "Response status code should be 200 - OK.")
            
            expectation.fulfill()
        }
        sessionTask.resume()

        // wait for expectation with timeout
        self.waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error, "Google is not accessible.")
        }
        
        // remove all cached response data
        URLCacheManager.sharedInstance.removeAllCachedResponses()
        
        let cachedData = URLCacheManager.sharedInstance.cache(for: sessionTask)
        XCTAssertNil(cachedData, "Cached data should be nil.")
        
        print("Finished cache request")
    }
}
