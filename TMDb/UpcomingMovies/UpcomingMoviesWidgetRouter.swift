//
//  UpcomingMoviesWidgetRouter.swift
//  HeroesOfTheDay
//
//  Created by Renato De Souza Machado Filho on 06/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class UpcomingMoviesWidgetRouter: AbstractRouter {
    func showDetailsFor(_ item: Movie, context: NSExtensionContext?) {
        if let url = URL(string: "marvel-heroes-app://app-details?characterId=\(item.id)") {
            context?.open(url, completionHandler: nil)
        }
    }
}
