//
//  UIColorExtension.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


extension UIColor {

    static var goldThemeColor: UIColor {
        return UIColor(hexString: "#FBCA03")
    }

    static var chocolateCosmosThemeColor: UIColor {
        return UIColor(hexString: "#4D1518")
    }
    
    static var redThemeColor: UIColor {
        return UIColor(hexString: "#ED1D24")
    }

    static var grayThemeColor: UIColor {
        return UIColor(hexString: "#3B383D")
    }

    static var darkGrayThemeColor: UIColor {
        return UIColor(hexString: "#1A191B")
    }

    static var greenConectionColor: UIColor {
        return UIColor(hexString: "#48AB4F")
    }
    
    static var redConectionColor: UIColor {
        return UIColor(hexString: "#BC2D24")
    }
}
