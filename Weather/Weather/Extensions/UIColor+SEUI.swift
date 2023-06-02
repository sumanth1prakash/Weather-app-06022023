//
//  UIColor+SEUI.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import UIKit

extension UIColor {
    
    //MARK: - Colors
    
    class var gray100: UIColor {
        return UIColor.getColor(named: "gray100")
    }
    
    class var brand01: UIColor {
        return UIColor.getColor(named: "brand01")
    }
    
    class var gray700: UIColor {
        return UIColor.getColor(named: "gray700")
    }
    
    private static func getColor(named colorName: String) -> UIColor {
        let color = UIColor(named: colorName, in: nil, compatibleWith: nil)
        return color ?? .black
    }
}
