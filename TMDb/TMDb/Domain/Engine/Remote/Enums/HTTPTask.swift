//
//  HTTPTask.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

typealias Parameters  = [String:Any]
typealias HTTPHeaders = [String:String]

enum HTTPTask {
    case request
    case requestWith(urlParameters: Parameters?, bodyParameters: Parameters?)
    case requestWithAdditional(auth: HTTPAuth?, urlParameters: Parameters?, bodyParameters: Parameters?)
}
