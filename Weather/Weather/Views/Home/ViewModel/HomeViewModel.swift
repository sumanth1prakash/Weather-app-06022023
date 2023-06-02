//
//  HomeViewModel.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import SwiftUI
import CoreLocation
import Combine
import MapKit

public class HomeScreenViewModel : ObservableObject {
    weak var locationManager: LocationDataManager?
    @Published var weatherData : WeatherResponseBody?
    @Published var locationDetails : [LocationDetailsResponse]?
    @Published var forecastDetails : ForecastDetails?
    @Published var hourDetails: [Forecast] = [Forecast]()
    @Published var dailyDetails: [DailyForecast] = [DailyForecast]()
    @Published var isLoading: Bool = false
    @Published var units: String = "imperial"
    @Published var userLocationLoading: Bool = false
    @Published var forecastLoading: Bool = false
    @Published var weatherLoading: Bool = false
    private var isLoadingCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var annotations : [LocationWrapper] = []
    
    init(locationManager: LocationDataManager? = nil) {
        self.locationManager = locationManager
        
        self.isLoadingCancellable = $userLocationLoading
            .combineLatest($weatherLoading)
            .combineLatest($forecastLoading)
            .map { (($0.0, $0.1), $1) }
            .sink { [weak self] value in
                guard let self = self else { return }
                let ((userLocationLoading, weatherLoading), forecastLoading) = value
                self.isLoading = userLocationLoading || weatherLoading || forecastLoading
            }
    }
    
    private func getLatLongs() -> (Double, Double) {
        var latitude: Double = locationManager?.currentLocation?.coordinate.latitude ?? 0
        var longitude: Double = locationManager?.currentLocation?.coordinate.longitude ?? 0
        if let coordinates = selectedCoordinate {
            latitude = coordinates.latitude
            longitude = coordinates.longitude
        }
        return (latitude, longitude)
    }
    
    private func getWeatherData() {
        weatherLoading = true
        let latLongs = getLatLongs()
        Webservices().getCurrentLocation(latitiude:  latLongs.0, longitude:  latLongs.1, unit: units) { [weak self]
            (response, error) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if error == nil {
                    self.weatherData = response
                }
                self.weatherLoading = false
            }
        }
    }
    
    private func getCityDetails() {
        userLocationLoading = true
        let latLongs = getLatLongs()
        Webservices().getCityDetails(latitiude: latLongs.0, longitude: latLongs.1) { [weak self]
            (response, error) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if error == nil {
                    self.locationDetails = response
                }
                self.userLocationLoading = false
            }
            
        }
    }
    
    private func getForecastDetails() {
        forecastLoading = true
        let latLongs = getLatLongs()
        Webservices().getForecastDetails(latitiude: latLongs.0, longitude: latLongs.1, unit: units) { [weak self]
            (response, error) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if error == nil {
                    self.forecastDetails = response
                    self.hourDetails = self.forecastDetails?.hourly ?? []
                    self.dailyDetails = self.forecastDetails?.daily ?? []
                }
                self.forecastLoading = false
            }
            
        }
    }
    
    private func loadJson() -> ForecastDetails? {
        if let url = Bundle.main.url(forResource: "Forecast", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(ForecastDetails.self, from: data)
            } catch {
                print("Error!! Unable to parse  Forecast.json")
            }
        }
        return nil
    }
    
    func getImageURL(imageName: String)-> String {
        return Constants.imageURL + imageName +  "@2x.png"
    }
    
    func onViewEvent(_ event: ViewLifecycleEvents?) {
        guard let event = event else {
            return
        }
        switch event {
        case .viewWillAppear:
            self.makeAPICalls()
            break
        case .viewDidAppear:
            break
        case .viewWillDisappear:
            break
        case .viewDidDisappear:
            break
        case .viewDidLoad:
            break
            
        }
    }
    
    func makeAPICalls() {
        annotations = [
            LocationWrapper(coordinate: CLLocationCoordinate2D(latitude: locationManager?.currentLocation?.coordinate.latitude ?? 0, longitude: locationManager?.currentLocation?.coordinate.longitude ?? 0)),
               ]
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationManager?.currentLocation?.coordinate.latitude ?? 0, longitude: locationManager?.currentLocation?.coordinate.longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.getWeatherData()
        self.getCityDetails()
        self.getForecastDetails()
        /*self.forecastDetails = self.loadJson()
        guard let forecast = self.forecastDetails else { return }
        self.hourDetails = forecast.hourly ?? []
        self.dailyDetails = forecast.daily ?? []*/
    }
    
    func getMinMaxTemp(item: DailyForecast) -> (Double, Double) {
        guard let temp = item.temp else { return (0, 0) }
        return (((temp.min ?? 0) / (temp.max ?? 0)), temp.max ?? 0)
    }
    
    func fillProgressColor(item: DailyForecast) -> (Double, Double) {
        guard let temp = item.temp else { return (0, 0) }
        return (temp.min ?? 0, temp.max ?? 0)
    }
    
    func getHourFromTimestamp(timeStamp : Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh a"
        var hour = dayTimePeriodFormatter.string(from: date)
        hour = hour.replacingOccurrences(of: " ", with: "")
        hour = hour.removingPrefixes(["0"])
        return hour
    }
    
    func getDayNameFromTimeStamp(timeStamp : Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEE"
        return dayTimePeriodFormatter.string(from: date)
    }
}
