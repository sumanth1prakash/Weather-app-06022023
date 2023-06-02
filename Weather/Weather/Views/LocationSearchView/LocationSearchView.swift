//
//  LocationSearchView.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import SwiftUI
import MapKit
import Combine

struct LocationSearchView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [LocationResult] = []
    private let searchCompleter = MKLocalSearchCompleter()
    @ObservedObject private var searchCompleterDelegate: SearchCompleterDelegate
    let countryCode = "US"
    @State var location:LocationDataManager?
    @Binding var isPresented: Bool
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @State var locationResult: LocationResult?
    
    init(selectedCoordinate: Binding<CLLocationCoordinate2D?>, location: LocationDataManager? = nil, isPresented: Binding<Bool>) {
        _isPresented = isPresented
        _selectedCoordinate = selectedCoordinate
        searchCompleterDelegate = SearchCompleterDelegate()
        self.location = location
        searchCompleterDelegate.latitude = location?.currentLocation?.coordinate.latitude ?? 0
        searchCompleterDelegate.longitude = location?.currentLocation?.coordinate.longitude ?? 0
    }
    
    var body: some View {
        VStack {
            SearchBar(searchQuery: $searchQuery)
                .onChange(of: searchQuery) { query in
                    searchCompleter.queryFragment = query
                }
            
            List(searchResults, id: \.self) { result in
                Button(action: {
                    searchCompleter.queryFragment = ""
                    searchCompleter.cancel()
                    let searchRequest = MKLocalSearch.Request()
                    searchRequest.naturalLanguageQuery = result.name
                    searchRequest.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                    let search = MKLocalSearch(request: searchRequest)
                    search.start { response, error in
                        if let placemark = response?.mapItems.first?.placemark {
                            selectedCoordinate = placemark.coordinate
                            isPresented = false
                        }
                    }
                }) {
                    VStack(alignment: .leading) {
                        Text(result.name)
                            .font(.headline)
                        Text("\(result.city), \(result.state)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            searchCompleter.delegate = searchCompleterDelegate
        }
        .onReceive(searchCompleterDelegate.objectWillChange) {
            self.searchResults = searchCompleterDelegate.searchResults
        }
    }
}

class SearchCompleterDelegate: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    private var cancellables = Set<AnyCancellable>()
    var countryCode = "US"
    @Published var searchResults: [LocationResult] = []
    var latitude: Double = 0
    var longitude: Double = 0
    override init() {
        super.init()
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = completer.queryFragment
            let regionRadius: CLLocationDistance = 5000
            let userLocation = CLLocation(latitude: latitude, longitude: longitude)
            let coordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            searchRequest.region = coordinateRegion
            
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                guard let mapItems = response?.mapItems else {
                    debugPrint("Search error: \(error?.localizedDescription ?? "")")
                    return
                }
                
                let filteredResults = mapItems.filter { $0.placemark.countryCode == self.countryCode }
                
                let locationResults = Array(filteredResults.prefix(100)).map { mapItem -> LocationResult in
                    let name = mapItem.name ?? ""
                    let city = mapItem.placemark.locality ?? ""
                    let state = mapItem.placemark.administrativeArea ?? ""
                    let latitude = mapItem.placemark.coordinate.latitude
                    let longitude = mapItem.placemark.coordinate.longitude
                    return LocationResult(name: name, city: city, state: state, latitude: latitude, longitude: longitude)
                }
                
                self.searchResults = locationResults
            }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        debugPrint("\(error.localizedDescription)")
    }
}

