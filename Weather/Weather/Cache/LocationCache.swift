//
//  LocationCache.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import Foundation

struct LocationCache {
    static let shared = LocationCache()
    
    private let defaults = UserDefaults.standard
    
    private let latitudeKey = "CachedLatitude"
    private let longitudeKey = "CachedLongitude"
    
    func cache(latitude: Double, longitude: Double) {
        defaults.set(latitude, forKey: latitudeKey)
        defaults.set(longitude, forKey: longitudeKey)
    }
    
    func getCachedLocation() -> (latitude: Double, longitude: Double)? {
        guard let latitude = defaults.object(forKey: latitudeKey) as? Double,
              let longitude = defaults.object(forKey: longitudeKey) as? Double else {
            return nil
        }
        return (latitude, longitude)
    }
    
    func clearCache() {
        defaults.removeObject(forKey: latitudeKey)
        defaults.removeObject(forKey: longitudeKey)
    }
}
