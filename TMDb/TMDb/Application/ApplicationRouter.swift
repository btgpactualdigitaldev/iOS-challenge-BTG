//
//  ApplicationRouter.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

struct ApplicationRouter {
    static func setup(windows: inout UIWindow?) {
        windows = UIWindow(frame: UIScreen.main.bounds)
        let repository: MovieRemoteRepository           = .init()
        let tabBarController: UITabBarController        = .init()
        tabBarController.tabBar.isTranslucent           = false
        tabBarController.tabBar.barTintColor            = .chocolateCosmosThemeColor
        tabBarController.tabBar.tintColor               = .goldThemeColor
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.viewControllers                = [HomeRouter.viewController(repository: repository), FavoritesRouter.viewController(repository: repository)]
        tabBarController.selectedIndex                  = 0
        windows?.rootViewController                     = tabBarController
        windows?.makeKeyAndVisible()
    }
}
