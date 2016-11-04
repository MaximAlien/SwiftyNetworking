//
//  SwiftyNetworkingTests.swift
//  SwiftyNetworkingTests
//
//  Created by Maxim Makhun on 11/4/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

import XCTest

class SwiftyNetworkingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
    }
    
    func testPerformanceExample() {
        self.measure {
            SwiftyNetworking.sendRequestThroughProtocol()
        }
    }
}
