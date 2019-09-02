//
//  MovieService.swift
//  TMDb
//
//  Created by Renato Machado Filho on 14/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

enum MovieService {
    case getUpcoming(page: Int)
    case getMovieDetails(id: Int)
}

extension MovieService: Service {

    var baseURL: URL {
        guard let url = URL(string: NetworkConstants.URLs.base) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }

    var version: String {
        switch self {
        case .getUpcoming,
             .getMovieDetails:
            return "/3"
        }
    }

    var path: String {
        switch self {
        case .getUpcoming:
            return version + "/movie/upcoming"
        case .getMovieDetails(let id):
            return version + "/movie/\(id)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getUpcoming,
             .getMovieDetails:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .getUpcoming(let page):
            let parameters: Parameters = ["page": page]
            return .requestWithAdditional(auth: auth, urlParameters: parameters, bodyParameters: nil)
        case .getMovieDetails:
            return .requestWithAdditional(auth: auth, urlParameters: nil, bodyParameters: nil)
        }
    }

    var auth: HTTPAuth? {
        switch self {
        case .getUpcoming,
             .getMovieDetails:
            return .url(Authentication.parameters)
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var decoder: JSONDecoder {
        let decoder: JSONDecoder = .init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }

    func errorFor(statusCode: Int) -> CustomError? {
        return nil
    }
}
