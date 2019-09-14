//
//  Constants.swift
//  SwiftyNetworking
//
//  Created by Maxim Makhun on 12/09/2019.
//  Copyright © 2019 Maxim Makhun. All rights reserved.
//

import Foundation

struct Constants {

    static let cacheSize: Int = 20 * 1024 * 1024 // megabytes
    static let cacheExpirationKey: String = "expiration_key"
    static let cacheExpirationDuration: TimeInterval = 10.0 // seconds
    static let requestURL: URL = URL(string: "https://www.google.com/")!
}
