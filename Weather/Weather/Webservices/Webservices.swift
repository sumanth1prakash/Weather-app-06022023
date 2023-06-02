//
//  Webservices.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import Foundation
import CoreLocation

class Webservices
{
    init() {}
    var baseWebservice : BaseWebservice = BaseWebservice.init()
    
    /// This method is used to fetch all  data from API using latitude and longitude

    func getCurrentLocation(latitiude: CLLocationDegrees, longitude: CLLocationDegrees, unit: String, completion: @escaping ((WeatherResponseBody?, Error?) -> Void))  {

        let urlString = Constants.baseURL + "lat=\(latitiude)&lon=\(longitude)&appid=\(Constants.api_key["api-key"] ?? "")&units=\(unit)"
        guard let url = URL(string: urlString) else {
            completion(nil, baseWebservice.apiError)
            return
        }
        baseWebservice.executeAPIRequest(url: url) { responseData, error in
            guard let responseData = responseData else { return completion(nil, error) }
            Utilites.convertResponseToModel(type: WeatherResponseBody.self, from: responseData, completion: completion)
        }
    }
    
    func getCityDetails(latitiude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (([LocationDetailsResponse]?, Error?) -> Void)) {
         
        let urlString = Constants.geoCodeReverseURL + "lat=\(latitiude)&lon=\(longitude)&appid=\(Constants.api_key["api-key"] ?? "")"
        guard let url = URL(string: urlString) else {
            completion(nil, baseWebservice.apiError)
            return
        }
        baseWebservice.executeAPIRequest(url: url) { responseData, error in
            guard let responseData = responseData else { return completion(nil, error) }
            Utilites.convertResponseToModel(type: [LocationDetailsResponse].self, from: responseData, completion: completion)
        }
    }
    
    func getForecastDetails(latitiude: CLLocationDegrees, longitude: CLLocationDegrees, unit: String, completion: @escaping ((ForecastDetails?, Error?) -> Void)) {
         
        let urlString = Constants.forecastURL + "lat=\(latitiude)&lon=\(longitude)&appid=\(Constants.api_key["api-key"] ?? "")&units=\(unit)"
        guard let url = URL(string: urlString) else {
            completion(nil, baseWebservice.apiError)
            return
        }
        baseWebservice.executeAPIRequest(url: url) { responseData, error in
            guard let responseData = responseData else { return completion(nil, error) }
            Utilites.convertResponseToModel(type: ForecastDetails.self, from: responseData, completion: completion)
        }
    }
}
