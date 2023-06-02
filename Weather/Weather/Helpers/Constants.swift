//
//  Constants.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import Foundation

enum InfoConfig {
    
    static func environmentHeaders(_ bundle: Bundle = .main, headerKeys: [String]) -> [String: String] {
        return getValue(for: "LSEnvironment", bundle: bundle, headerKeys: headerKeys)
    }
    
    private static func getValue(for key: String, bundle: Bundle = .main, headerKeys: [String]) -> [String: String] {
        var result: [String: String] = [:]
        let configDictionary = getConfigDictionary(bundle: bundle)
        
        if let dict = configDictionary[key] as? [String: String] {
            for (key, value) in dict {
                headerKeys.forEach { (headerKey) in
                    if headerKey == key {
                        result[key] = value
                    }
                }
            }
        }
        
        return result
    }
    
    private static func getConfigDictionary(bundle: Bundle) -> NSDictionary {
        if let path = bundle.path(forResource: "Info", ofType: "plist") {
            guard let dictionary = NSDictionary(contentsOfFile: path) else { return [:] }
            return dictionary
        }
        return [:]
    }
}

struct Constants {
    static let api_key = InfoConfig.environmentHeaders(headerKeys: ["api-key"])
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    static let geoCodeReverseURL = "http://api.openweathermap.org/geo/1.0/reverse?"
    static let forecastURL = "https://api.openweathermap.org/data/3.0/onecall?"
    static let imageURL = "https://openweathermap.org/img/wn/"
}
