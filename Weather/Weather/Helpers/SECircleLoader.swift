//
//  SECircleLoader.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import SwiftUI

public struct SECircleLoader: View {
    
    @State public var isAnimating = false
    @State private var angle: Double = 0.0
    
    private var foreverAnimation: Animation {
        Animation.linear(duration: 1.0).repeatForever(autoreverses: false)
    }
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
            ZStack {
                Color(UIColor.gray100).clipShape(Circle()).frame(width: 80, height: 80, alignment: .center)
                HStack(alignment: .center) {
                    Spacer()
                    Circle()
                        .trim(from: 0, to: 0.3)
                        .stroke(Color.brand01, lineWidth: 6.0)
                        .frame(width: 58, height: 58)
                        .rotationEffect(Angle(degrees: angle))
                        .animation(self.foreverAnimation, value: angle)
                        .onAppear {
                            DispatchQueue.main.async {
                                angle = 360
                            }
                        }
                    Spacer()
                }
            }
            Spacer()
        }
    }
}
