//
//  UINavigationBarExtension.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

extension UINavigationBar {
    static func setupUI() {
        let tintColor : UIColor = .white
        let barColor  : UIColor = .darkGrayThemeColor
        appearance().isTranslucent = false
        appearance().shadowImage = UIImage()
        appearance().setBackgroundImage(UIImage(), for: .default)
        appearance().tintColor = tintColor
        appearance().barTintColor = barColor
    }
    
    func setBarTransparency() {
        isTranslucent = true
        tintColor     = .white
        setBackgroundImage(.init(), for: .default)
    }
    
    func removeTranparencyFromBar() {
        isTranslucent = UINavigationBar.appearance().isTranslucent
        shadowImage   = UINavigationBar.appearance().shadowImage
        barTintColor  = UINavigationBar.appearance().barTintColor
        tintColor     = UINavigationBar.appearance().tintColor
        setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: .default), for: .default)
    }
}
