//
//  LineView.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import SwiftUI

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dashes: [CGFloat] = [8, 4]
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        
        return path
            .strokedPath(StrokeStyle(lineWidth: 1, dash: dashes))
    }
}

struct SolidLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        
        return path
    }
}
