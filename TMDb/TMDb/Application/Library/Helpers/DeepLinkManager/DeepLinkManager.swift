//
//  DeepLinkManager.swift
//  MarvelHeroes
//
//  Created by Renato De Souza Machado Filho on 08/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

class DeepLinkManager {
    static let shared: DeepLinkManager = .init()
    
    private init() {}
    
    @discardableResult
    func handleDeeplink(url: URL) -> Bool {
        let deepLinkSource = DeepLinkSchemeURL.deepLinkRoute(with: url)
        deepLinkSource?.start()
        return deepLinkSource != nil
    }
}
