//
//  LocationCacheTests.swift
//  WeatherTests
//
//  Created by Sumanth Pammi on 5/31/23.
//

import XCTest
@testable import Weather

class LocationCacheTests: XCTestCase {
    
    var local: LocationCache!
    
    override func setUp() {
        super.setUp()
        local = LocationCache()
    }
    
    override func tearDown() {
        local.clearCache()
        local = nil
        super.tearDown()
    }
    
    func testCacheAndRetrieveLocation() {
        let latitude: Double = 37.7749
        let longitude: Double = -122.4194
        
        local.cache(latitude: latitude, longitude: longitude)
        let cachedLocation = local.getCachedLocation()
        
        XCTAssertNotNil(cachedLocation)
        XCTAssertEqual(cachedLocation?.latitude, latitude)
        XCTAssertEqual(cachedLocation?.longitude, longitude)
    }
    
    func testClearCache() {
        let latitude: Double = 37.7749
        let longitude: Double = -122.4194
        local.cache(latitude: latitude, longitude: longitude)
        
        local.clearCache()
        let cachedLocation = local.getCachedLocation()
        
        XCTAssertNil(cachedLocation)
    }
}
