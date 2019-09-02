//
//  DeepLinkRouteDetails.swift
//  MarvelHeroes
//
//  Created by Renato De Souza Machado Filho on 08/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

struct DeepLinkRouteDetails: DeepLinkRoute {
    var value: String
    
    init(value: String = "") {
        self.value = value
    }
    
    func start() {
        guard let tabBarController = UIApplication.shared.getWindow()?.rootViewController as? UITabBarController else {
            return
        }
        
        tabBarController.presentedViewController?.dismiss(animated: false, completion: nil)
        tabBarController.selectedIndex = 0
        
        guard let navController = tabBarController.viewControllers?.first as? UINavigationController,
              let homeController = navController.viewControllers.first as? ViewController else {
            return
        }
        navController.popToRootViewController(animated: false)
        homeController.execute(deepLink: .details(id: Int(value).or(0)))
    }
}
