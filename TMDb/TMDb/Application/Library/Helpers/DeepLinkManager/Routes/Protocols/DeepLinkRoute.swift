//
//  DeepLinkRoute.swift
//  MarvelHeroes
//
//  Created by Renato De Souza Machado Filho on 08/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

protocol DeepLinkRoute {
    var value: String { get }
    func start()
}
