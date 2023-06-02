//
//  HomeViewTests.swift
//  WeatherTests
//
//  Created by Sumanth Pammi on 5/31/23.
//

import XCTest
import SwiftUI
import ViewInspector
import MapKit
@testable import Weather

class HomeViewTests: XCTestCase {

    func testView_WhenLoaded_ShouldHaveCorrectInitialState() throws {
        // Create the HomeView instance
        let sut = HomeView()
            .environmentObject(HomeScreenViewModel())

        // Inspect the view using ViewInspector
        let view = try sut.inspect().find(HomeView.self)
        let viewModel = try view.actualView().self[keyPath: \.screenViewModel]


        // Verify the initial state of the view
        XCTAssertNil(viewModel.weatherData)
        XCTAssertNil(viewModel.locationDetails)
        XCTAssertTrue(viewModel.hourDetails.isEmpty)
        XCTAssertTrue(viewModel.dailyDetails.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(try view.actualView().isShowingLocation)
        XCTAssertNil(try view.actualView().selectedCoordinate)
    }
}

