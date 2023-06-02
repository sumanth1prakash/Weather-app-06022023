//
//  LottieEnvironment.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import SwiftUI
import Lottie

struct LottieAnimationView: UIViewRepresentable  {
    @Binding var fileName: String
    let loopMode: Bool
    
    
    @State var animationView: AnimationView?
    typealias UIViewType = UIView
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = AnimationView()
        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode ? .loop : .playOnce
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        DispatchQueue.main.async {
            self.animationView = animationView
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // do stuff here ...
    }
}
