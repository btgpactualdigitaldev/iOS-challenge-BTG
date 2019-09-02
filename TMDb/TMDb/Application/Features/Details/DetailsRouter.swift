//
//  DetailsRouter.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class DetailsRouter: AbstractRouter {

    /**
     It creates all VIPER modules and inject necessary dependencies
     */
    class func viewController(data: Movie, repository: MovieRepository) -> UIViewController {
        let vc = DetailsViewController()
        let r  = DetailsRouter(rootViewController: vc)
        let i  = DetailsInteractor(data: data, repository: repository)
        let p  = DetailsPresenter(interactor: i, router: r)
        
        vc.presenter = p
        return vc
    }
}
