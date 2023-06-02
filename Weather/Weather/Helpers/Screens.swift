//
//  Screens.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import SwiftUI
import UIKit
import Combine

struct Screens {
    static public func homeScreen(dependencies: LocationDataManager? = nil) -> Screen_UIKitHost<HomeView> {
        return HomeScreen_UIKitHost(body: HomeView(locationManager: dependencies))
    }
}


public class HomeScreen_UIKitHost<Body : View>: Screen_UIKitHost<Body> {
    
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        host(topEdgeIgnoresSafeArea: true)
        //left and right bar items color
        
        clearBackButtonText(self)
        set(navigationItem: self.navigationItem, title: "", color: UIColor.white)
        
        self.applyStyle(self.flowNavigationController!.navigationBar)
        self.navigationBarBackdropView?.backgroundColor = .black
    }
    
}
