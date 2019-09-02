//
//  DeepLinkSchemeURL.swift
//  MarvelHeroes
//
//  Created by Renato De Souza Machado Filho on 08/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

class DeepLinkSchemeURL: DeepLinkSource {
    static func deepLinkRoute(with data: Any) -> DeepLinkRoute? {
        guard let url = data as? URL, let host = DeepLinkHostType(rawValue: url.host.or("")) else { return nil }
        switch host {
        case .details:
            guard let characterId = url.queryParameters?["characterId"] else {
                return nil
            }
            return DeepLinkRouteDetails(value: characterId)
        }
    }
}
