//
//  HomeInteractor.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class HomeInteractor: AbstractInteractor {

    private var repository: MovieRepository
    private var homeDataSource: HomeCollectionDataSource!
    private var homeDelegate: HomeCollectionDelegate!
    private var isRequesting: Bool = false
    private let dispatchGroup = DispatchGroup()

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func requestDataSourceFor(_ vc: CardInteractionDelegate?) -> HomeCollectionDataSource {
        homeDataSource = HomeCollectionDataSource(newData: [], delegate: vc)
        return homeDataSource
    }

    func requestDelegateFor(_ vc: (CardInteractionDelegate & PaginationDelegate)?) -> HomeCollectionDelegate {
        homeDelegate = HomeCollectionDelegate(dataProvider: self, handlerDelegate: vc, paginationDelegate: vc)
        return homeDelegate
    }
    
    func addToFavorites(_ items: [Movie]) {
        repository.saveAsFavorites(items)
    }

    func removeFromFavorites(_ items: [Movie]) {
        repository.deleFromFavorites(items)
    }

    func reloadDataWithFavoritedItems() {
        homeDataSource.updateWith(favorites: repository.fetchFavorites())
    }
   
    func requestData(by queryString: String? = nil, for page: Int, completionHandler: @escaping (Result<PaginationResultType>) -> Void) {
        if isRequesting {
            repository.cancelRequest()
        }
        isRequesting = true

        let isSearching = (queryString != nil) && (queryString?.isEmpty == false)
        homeDataSource.isSearchLayout = isSearching

        if isSearching {
            homeDataSource.filterDataBy(queryString!)
            return completionHandler(.success(.newData))
        }

        repository.fetchUpcoming(page: page) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                let dataCount = value.results.count
                if dataCount > 0 {
                    if page > 1 {
                        completionHandler(.success(.insertPageData(count: dataCount - 1, update: {
                            self.homeDataSource.set(newData: value.results)
                            self.reloadDataWithFavoritedItems()
                        })))
                    } else {
                        self.homeDataSource.removeAllData()
                        self.homeDataSource.set(newData: value.results)
                        self.reloadDataWithFavoritedItems()
                        completionHandler(.success(.newData))
                    }
                } else {
                    completionHandler(.success(.noData))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
            self.isRequesting = false
        }
    }
    
    func requestDetails(id: Int, completionHandler: @escaping (Result<Movie>) -> Void) {
        repository.fetchMovieDetails(id: id, completionHandler)
    }
}

extension HomeInteractor: DataSourceProvider {
    func getNumberOfItemsIn(section: Int) -> Int {
        return homeDataSource.getNumberOfItemsIn(section: section)
    }

    func getData() -> DataDiplayedType<Movie> {
        return homeDataSource.getData()
    }

    func dataIsLoading() -> Bool {
        return isRequesting
    }
}
