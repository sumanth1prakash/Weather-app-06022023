//
//  HomeView.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import SwiftUI
import URLImage
import MapKit

struct HomeView: View {
    @StateObject var screenViewModel : HomeScreenViewModel = HomeScreenViewModel()
    var locationManager: LocationDataManager?
    @Environment(\.viewLifecyclePublisherKey) var viewLifecyclePublisher
    @State var animationName: String = "splash"
    @State var isShowingLocation = false
    @State var selectedCoordinate: CLLocationCoordinate2D?
    @State var tracking:MapUserTrackingMode = .follow     
    init(locationManager: LocationDataManager? = nil) {
        self.locationManager = locationManager
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            
            if screenViewModel.isLoading {
                ProgressView()
            } else {
                if let weather = screenViewModel.weatherData, let locationDetails = screenViewModel.locationDetails  {
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .center) {
                                HStack {
                                    Text((locationDetails.first?.name != nil ? (locationDetails.first?.name ?? "") : "--"))
                                        .font(.system(size: 35))
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                    
                                    Button(action: {
                                        isShowingLocation = true
                                    }) {
                                        Image(systemName: "location.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                Text((weather.main?.temp != nil ? (String(Int(weather.main?.temp ?? 0)) + "°") : "--"))
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                    .fontWeight(.regular)
                                    .padding(.top, -20)
                                HStack {
                                    Text((weather.weather?.first?.main?.capitalized ?? weather.weather?.first?.description?.capitalized) ?? "--")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                    URLImage(url: URL(string: screenViewModel.getImageURL(imageName: (self.screenViewModel.weatherData?.weather?.first?.icon ?? "")))!) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                .padding(.top, -40)
                                
                                HStack {
                                    Text("H:\(Int(weather.main?.temp_max ?? 0))°")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                    Text("L:\(Int(weather.main?.temp_min ?? 0))°")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                }
                                .padding([.top, .leading], -20)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color(red: 0.20, green: 0.41, blue: 0.69))
                                    
                                    VStack {
                                        Text("Hour Forecast")
                                            .foregroundColor(.white)
                                            .font(.body)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.center)
                                            .padding(.top, 10)
                                            
                                        DashedLine()
                                            .stroke(Color.white)
                                            .frame(height: 1)
                                            .padding([.leading, .trailing], 20)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                                LazyHStack(spacing: 16) {
                                                    ForEach(Array(zip(screenViewModel.hourDetails.indices, screenViewModel.hourDetails)), id: \.1.dt) { index, item in
                                                        VStack {
                                                            if index != 0 {
                                                                Text("\(screenViewModel.getHourFromTimestamp(timeStamp: item.dt ?? 0))")
                                                                    .font(.system(size: 15, weight: .medium, design: .default))
                                                                    .foregroundColor(.white)
                                                                    .padding(.top, 10)
                                                            } else {
                                                                Text("Now")
                                                                    .font(.system(size: 15, weight: .medium, design: .default))
                                                                    .foregroundColor(.white)
                                                                    .padding(.top, 10)
                                                            }
                                                            
                                                            URLImage(url: URL(string: screenViewModel.getImageURL(imageName: item.weather?.first?.icon ?? "" ))!) { image in
                                                                image
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .frame(width: 30, height: 30)
                                                            }
                                                            Text("\(Int(item.temp ?? 0))")
                                                                .font(.system(size: 15, weight: .medium, design: .default))
                                                                .foregroundColor(.white)
                                                                .padding(.bottom, 10)
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                        }
                                        .padding([.leading, .trailing], 20)
                                    }
                                }
                                .frame(height: 150)
                                .padding(20)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color(red: 0.20, green: 0.41, blue: 0.69))
                                    VStack {
                                        Text("Daily Forecast")
                                            .foregroundColor(.white)
                                            .font(.body)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.center)
                                            .padding(.top, 10)
                                            
                                        DashedLine()
                                            .stroke(Color.white)
                                            .frame(height: 1)
                                            .padding([.leading, .trailing], 20)
                                        
                                        VStack(alignment: .leading) {
                                            ForEach(Array(zip(screenViewModel.dailyDetails.indices, screenViewModel.dailyDetails)), id: \.1.dt) { index, item in
                                                HStack {
                                                    VStack(alignment: .leading) {
                                                        if index != 0 {
                                                            Text("\(screenViewModel.getDayNameFromTimeStamp(timeStamp: item.dt ?? 0))")
                                                                .font(.system(size: 20, weight: .medium, design: .default))
                                                                .foregroundColor(.white)
                                                                .padding(.top, 10)
                                                        } else {
                                                            Text("Today")
                                                                .font(.system(size: 20, weight: .medium, design: .default))
                                                                .foregroundColor(.white)
                                                                .padding(.top, 10)
                                                        }
                                                    }
                                                    .frame(width: 80, alignment: .leading)
                                                    Spacer()
                                                        
                                                    URLImage(url: URL(string: screenViewModel.getImageURL(imageName: item.weather?.first?.icon ?? "" ))!) { image in
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 30, height: 30)
                                                    }
                                                    Spacer()
                                                        
                                                    Text("L:\(Int(screenViewModel.getMinMaxTemp(item: item).0))°")
                                                        .font(.system(size: 18, weight: .medium, design: .default))
                                                        .foregroundColor(.white)
                                                        .padding(.top, 10)
                                                    Text("H:\(Int(screenViewModel.getMinMaxTemp(item: item).1))°")
                                                        .font(.system(size: 18, weight: .medium, design: .default))
                                                        .foregroundColor(.white)
                                                        .padding(.top, 10)
                                                }
                                                
                                                if index < screenViewModel.dailyDetails.count-1 {
                                                    SolidLine()
                                                        .stroke(Color.white, lineWidth: 2)
                                                        .frame(height: 1)
                                                } else {
                                                    Spacer()
                                                        .padding(.bottom, 10)
                                                }
                                            }
                                        }
                                        .padding([.leading, .trailing], 20)
                                    }
                                }
                                .frame(maxHeight: .infinity)
                                .padding(20)
                                
                                Map(coordinateRegion: $screenViewModel.region, interactionModes: MapInteractionModes.all, showsUserLocation: false, userTrackingMode: $tracking,annotationItems: screenViewModel.annotations) { location in
                                    MapAnnotation(coordinate: location.coordinate) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.red)
                                                .frame(width: 50, height: 50)
                                            
                                            Text("\((weather.main?.temp != nil ? (String(Int(weather.main?.temp ?? 0)) + "°") : "--"))")
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .frame(height: 250)
                                .padding([.leading, .trailing], 20)
                                
                                
                                
                                
                                
                            }
                        }
                    }
                }
            }
        }
        .onReceive(toOptionalPublisher(viewLifecyclePublisher), perform: { event in
            switch event?.simplified {
                case Optional(.viewWillAppear):
                    if let cachedLocation = LocationCache.shared.getCachedLocation() {
                        selectedCoordinate = CLLocationCoordinate2D(latitude: cachedLocation.latitude, longitude: cachedLocation.longitude)
                        screenViewModel.selectedCoordinate = selectedCoordinate
                    }
                    self.screenViewModel.locationManager = self.locationManager
                default: break
            }
            self.screenViewModel.onViewEvent(event)
        })
       
        .sheet(isPresented: $isShowingLocation) {
            LocationSearchView(selectedCoordinate: $selectedCoordinate, location: locationManager, isPresented: $isShowingLocation)
        }
        .onChange(of: isShowingLocation) { isPresented in
            if !isPresented {
                if let coordinate = selectedCoordinate {
                    screenViewModel.selectedCoordinate = coordinate
                    LocationCache.shared.cache(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    screenViewModel.makeAPICalls()
                }
            }
        }
    }
}

struct LocationWrapper: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}


struct RoundedSquare: Shape {
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let sideLength = min(rect.size.width, rect.size.height)
        let xOffset = (rect.size.width - sideLength) / 2
        let yOffset = (rect.size.height - sideLength) / 2
        
        let roundedRect = CGRect(x: xOffset, y: yOffset, width: sideLength, height: sideLength)
        let roundedPath = RoundedRectangle(cornerRadius: cornerRadius)
        
        return roundedPath.path(in: roundedRect)
    }
}
