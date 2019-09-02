//
//  FavoritesRouter.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class FavoritesRouter: AbstractRouter {

    /**
     It creates all VIPER modules and inject necessary dependencies
     */
    class func viewController(repository: MovieRepository) -> UIViewController {
        let vc = FavoritesViewController()
        let r = FavoritesRouter(rootViewController: vc)
        let i = FavoritesInteractor(repository: repository)
        let p = FavoritesPresenter(interactor: i, router: r)
        
        vc.presenter = p
        vc.tabBarItem = .init(title: "Favorites", image: #imageLiteral(resourceName: "icon-american-cap-unselected"), tag: 1)
        vc.tabBarItem.selectedImage = #imageLiteral(resourceName: "icon-american-cap").withRenderingMode(.alwaysOriginal)

        let rootViewController : UINavigationController = UINavigationController(rootViewController: vc)
        return rootViewController
    }
    
    func presentDetailsScreen(_ item: Movie) {
        let vc = DetailsRouter.viewController(data: item, repository: MovieRemoteRepository())
        rootViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
