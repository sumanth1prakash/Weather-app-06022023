//
//  ContentView.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import SwiftUI

struct ContentView: View {
    @State private var animationName: String = "splash"
    @State private var yOffset: CGFloat = -500
    @State private var isActive = false
    @StateObject var locationDataManager = LocationDataManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    LottieAnimationView(fileName: $animationName, loopMode: true)
                               .frame(width: geometry.size.width, height: geometry.size.height)
                               .aspectRatio(contentMode: .fill)
                               .clipped()
                               
                       }
                Text("Hello Weather!")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .offset(x: 0, y: yOffset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2.0)) {
                            yOffset = -50
                        }
                    }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear() {
            startTimer()
        }
    }

    //MARK: - startTimer
    
    func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let screen = Screens.homeScreen(dependencies: locationDataManager)
            let navi = UINavigationController(rootViewController: screen)
            NavigationManager.shared.performNavigation(to: navi, navigationType: .present(mode: .fullScreen), animated: true, completion: nil)
        }
    }
}
