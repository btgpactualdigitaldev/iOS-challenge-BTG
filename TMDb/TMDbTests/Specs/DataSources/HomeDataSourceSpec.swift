//
//  HomeDataSourceSpec.swift
//  TMDbTests
//
//  Created by Renato De Souza Machado Filho on 08/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Quick
import Nimble
@testable import TMDb

class HomeDataSourceSpec: QuickSpec {
    override func spec() {
        describe("Home DataSource") {
            
            context("Data source in normal layout", closure: {
                
                var factory: MoviesFactory!
                var sut: HomeCollectionDataSource!
                var expectedNumberOfItemAtFirstSection: Int!
                var expectedNumberOfItemAtSecondSection: Int!
                var expectedNumberOfSections: Int!
                var collection: UICollectionView!
                
                beforeEach {
                    expectedNumberOfItemAtFirstSection = 1
                    expectedNumberOfItemAtSecondSection = 5
                    expectedNumberOfSections = 2
                    factory = .init()
                    sut = .init(newData: [], delegate: nil)
                    collection = .init(frame: .zero, collectionViewLayout: .init())
                    let data = factory.generateListOfCharacteres(size: expectedNumberOfItemAtSecondSection).results
                    sut.set(newData: data)
                }
                
                it("Should return the isSearchLayout flag as FALSE", closure: {
                    expect(sut.isSearchLayout).notTo(beTrue())
                })
                
                it("Should return data enum type as .full", closure: {
                    let data = sut.getData()
                    switch data {
                    case .full:
                        assert(true)
                    case .filtred:
                        fail("Layout type expected is wrong")
                    }
                })
                
                it("Should return 2 sections", closure: {
                    expect(sut.numberOfSections(in: collection) == expectedNumberOfSections).to(beTrue())
                })
                
                it("Should return 1 item for section 0", closure: {
                    expect(sut.collectionView(collection, numberOfItemsInSection: 0) == expectedNumberOfItemAtFirstSection).to(beTrue())
                })
                
                it("Should return 5 items for section 1", closure: {
                    expect(sut.collectionView(collection, numberOfItemsInSection: 1) == expectedNumberOfItemAtSecondSection).to(beTrue())
                })
                
                it("Should return 10 items for section 1 when receive data from pagination", closure: {
                    let data = factory.generateListOfCharacteres(size: expectedNumberOfItemAtSecondSection).results
                    sut.set(newData: data)
                    expect(sut.collectionView(collection, numberOfItemsInSection: 1) == expectedNumberOfItemAtSecondSection * 2).to(beTrue())
                })
                
                it("Should return 0 items when remove all data", closure: {
                    sut.removeAllData()
                    expect(sut.collectionView(collection, numberOfItemsInSection: 1) == 0).to(beTrue())
                })
                
                it("Should update data with list of favorites", closure: {
                    let data = sut.getData()
                    switch data {
                    case .full(let value):
                        if let item = value[1].first {
                            item.isFavorite = true
                            sut.updateWith(favorites: [item])
                            
                            switch sut.getData() {
                            case .full(let updatedValue):
                                if let updatedItem = updatedValue[1].first(where: { $0 == item }) {
                                    expect(updatedItem.isFavorite).to(beTrue())
                                } else {
                                    fail("Item not favorited")
                                }
                            default:
                                fail("Layout type expected is wrong")
                            }
                        } else {
                            fail("Empty list not expected")
                        }
                    case .filtred:
                        fail("Layout type expected is wrong")
                    }
                })
                
                afterEach {
                    factory = nil
                    sut = nil
                    expectedNumberOfItemAtFirstSection = nil
                    expectedNumberOfItemAtSecondSection = nil
                    expectedNumberOfSections = nil
                    collection = nil
                }
            })
        }
    }
}
