//
//  URLType.swift
//  Farfetch
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

enum URLType: String, Codable {
    case comiclink  = "comiclink"
    case detail     = "detail"
    case wiki       = "wiki"
    case none       = ""

    init(rawValue: String) {
        switch rawValue {
        case "comiclink":
            self = .comiclink
        case "detail":
            self = .detail
        case "wiki":
            self = .wiki
        default:
            self = .none
        }
    }
}
