//
//  Service.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

protocol Service {
    var baseURL:    URL { get }
    var path:       String { get }
    var version:    String { get }
    var httpMethod: HTTPMethod { get }
    var task:       HTTPTask { get }
    var headers:    HTTPHeaders? { get }
    var auth:       HTTPAuth? { get }
    var decoder:    JSONDecoder { get }
    func errorFor(statusCode: Int) -> CustomError?
}
