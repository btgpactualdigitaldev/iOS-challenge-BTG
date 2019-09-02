//
//  MovieServiceFactory.swift
//  TMDbTests
//
//  Created by Renato De Souza Machado Filho on 08/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation
@testable import TMDb

struct MovieServiceFactory {
    enum ServiceRouteType {
        case getUpcoming(page: Int)
        case getMovieDetails(id: Int)
    }
    
    var route: ServiceRouteType
    
    init(route: ServiceRouteType) {
        self.route = route
    }
    
    func getBaseURL() -> String {
        switch route {
        case .getUpcoming,
             .getMovieDetails:
            return "https://api.themoviedb.org"
        }
    }
    
    func getAPIVersion() -> String {
        switch route {
        case .getUpcoming,
             .getMovieDetails:
            return "/3"
        }
    }
    
    func getPath() -> String {
        switch route {
        case .getUpcoming:
            return getAPIVersion() + "/movie/upcoming"
        case .getMovieDetails(let id):
            return getAPIVersion() + "/movie/\(id)"
        }
    }
    
    func getMethod() -> String {
        switch route {
        case .getUpcoming,
             .getMovieDetails:
            return "GET"
        }
    }
    
    func getHeaders() -> [String: String]? {
        return nil
    }
    
    func getAuth() -> HTTPAuth? {
        switch route {
        case .getUpcoming,
             .getMovieDetails:
            return .url(Authentication.parameters)
        }
    }
    
    func getTask() -> HTTPTask {
        switch route {
        case .getUpcoming,
             .getMovieDetails:
            return .requestWithAdditional(auth: getAuth(), urlParameters: nil, bodyParameters: nil)
        }
    }
}
