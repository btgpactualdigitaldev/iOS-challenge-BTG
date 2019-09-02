//
//  HomeRouter.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class HomeRouter: AbstractRouter {

    /**
     It creates all VIPER modules and inject necessary dependencies
     */
    class func viewController(repository: MovieRepository) -> UIViewController {
        let vc = HomeViewController()
        let r  = HomeRouter(rootViewController: vc)
        let i  = HomeInteractor(repository: repository)
        let p  = HomePresenter(interactor: i, router: r)
        
        vc.presenter = p
        vc.tabBarItem = .init(title: "Movies", image: #imageLiteral(resourceName: "icon-iron-man-unselected"), tag: 0)
        vc.tabBarItem.selectedImage = #imageLiteral(resourceName: "icon-iron-man").withRenderingMode(.alwaysOriginal)
        let rootViewController : UINavigationController = UINavigationController(rootViewController: vc)
        return rootViewController
    }
    
    func presentDetailsScreen(_ item: Movie) {
        let vc = DetailsRouter.viewController(data: item, repository: MovieRemoteRepository())
        rootViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
