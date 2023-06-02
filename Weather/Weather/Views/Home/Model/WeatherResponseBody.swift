//
//  WeatherResponseBody.swift
//  Weather
//
//  Created by Created by Sumanth Pammi on 5/31/23.
//

import Foundation

struct WeatherResponseBody : Codable {
    
    var coord: CoordinateResponse?
    var weather: [WeatherResponse]?
    var main: MainResponse?
    var name: String?
    var wind: WindResponse?
    
    enum CodingKeys: String, CodingKey {
        case coord, weather, main, name, wind
    }
}

struct CoordinateResponse : Codable  {
    var lon: Double?
    var lat: Double?
    
    enum CodingKeys: String, CodingKey {
        case lat, lon
    }
}

struct WeatherResponse : Codable  {
    var id: Int?
    var mainlat: String?
    var description: String?
    var main: String?
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id, mainlat, main, description, icon
    }
}

struct MainResponse : Codable  {
    var temp: Double?
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Double?
    var humidity: Double?
    var sea_level: Double?
    var grnd_level: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp, feels_like, temp_min, temp_max, pressure, humidity, sea_level, grnd_level
    }
}

struct WindResponse : Codable  {
    var speed: Double?
    var deg: Double?
    var gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed, deg, gust
    }
}

struct LocationDetailsResponse : Codable {
    
    var name: String?
    var country: String?
    var state: String?
    var lat: Double?
    var lon: Double?
    
    enum CodingKeys: String, CodingKey {
        case name, country, state, lat, lon
    }
}

struct ForecastDetails: Codable {
    var lat: Double?
    var lon: Double?
    var timezone: String?
    var current: Forecast?
    var minutely: [Forecast]?
    var hourly: [Forecast]?
    var daily: [DailyForecast]?
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone, current, minutely, hourly, daily
    }
}


struct Forecast: Codable {
    var dt: Double?
    var sunrise: Double?
    var sunset: Double?
    var temp: Double?
    var feels_like: Double?
    var pressure: Double?
    var humidity: Double?
    var dew_point: Double?
    var uvi: Double?
    var clouds: Int?
    var visibility: Int?
    var wind_speed: Double?
    var wind_deg: Int?
    var weather: [WeatherResponse]?
    var precipitation: Int?
    var wind_gust: Double?
    var pop: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp, feels_like, pressure, humidity, dew_point, uvi, clouds, visibility, wind_speed, wind_deg, weather, precipitation, wind_gust, pop
    }
  
}

struct DailyForecast: Codable {
    var dt: Double?
    var sunrise: Double?
    var sunset: Double?
    var pressure: Double?
    var humidity: Double?
    var dew_point: Double?
    var uvi: Double?
    var clouds: Int?
    var visibility: Int?
    var wind_speed: Double?
    var wind_deg: Int?
    var weather: [WeatherResponse]?
    var precipitation: Int?
    var wind_gust: Double?
    var pop: Double?
    var moonrise: Int?
    var moonset: Int?
    var moon_phase: Double?
    var rain: Double?
    var temp: Temperature?
    var feels_like: Temperature?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp, feels_like, pressure, humidity, dew_point, uvi, clouds, visibility, wind_speed, wind_deg, weather, precipitation, wind_gust, pop, moonrise, moonset, moon_phase, rain
    }
}

struct Temperature: Codable {
    var day: Double?
    var min: Double?
    var max: Double?
    var night: Double?
    var eve: Double?
    var morn: Double?
    
    enum CodingKeys: String, CodingKey {
        case day, min, max, night, eve, morn
    }
}

struct LocationResult: Hashable {
    let name: String
    let city: String
    let state: String
    let latitude: Double
    let longitude: Double
}
