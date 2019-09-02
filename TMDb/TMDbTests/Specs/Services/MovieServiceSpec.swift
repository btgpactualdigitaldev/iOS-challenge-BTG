//
//  MovieServiceSpec.swift
//  TMDbTests
//
//  Created by Renato De Souza Machado Filho on 08/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Quick
import Nimble
@testable import TMDb

class MovieServiceSpec: QuickSpec {
    override func spec() {
        describe("Movie Service") {
            
            context("Route to get Movies", {
                
                var sut: MovieService!
                var factory: MovieServiceFactory!
                
                beforeEach {
                    sut = .getUpcoming(page: 1)
                    factory = .init(route: .getUpcoming(page: 1))
                }
                
                it("Should have the correct url contruction with ordering by recently modified", closure: {
                    factory.route = .getUpcoming(page: 1)
                    let sutService: MovieService = .getUpcoming(page: 1)
                    print(sut.baseURL.absoluteString)
                    expect(sut.baseURL.absoluteString == factory.getBaseURL()).to(beTrue())
                    expect(sut.path == factory.getPath()).to(beTrue())
                    expect(sut.version == factory.getAPIVersion()).to(beTrue())
                    expect(sut.httpMethod.rawValue == factory.getMethod()).to(beTrue())
                    expect(sut.headers == factory.getHeaders()).to(beTrue())
                    
                    switch sutService.auth {
                    case .some(.url(let parameters)):
                        let key = parameters["api_key"] as? String
                        expect(key).notTo(beNil())
                        expect(key).notTo(beEmpty())
                    default:
                        fail("Auth type not expected")
                    }
                })
            })
        }
    }
}
