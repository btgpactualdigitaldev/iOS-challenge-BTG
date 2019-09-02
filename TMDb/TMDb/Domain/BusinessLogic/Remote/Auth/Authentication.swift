//
//  Authentication.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation
import Keys

struct Authentication {
    static var parameters: [String: String] {
        var parameters: [String: String] = [:]
        let keys: TMDbKeys = TMDbKeys()
        parameters["api_key"] = keys.publicAPIKey
        return parameters
    }
}

