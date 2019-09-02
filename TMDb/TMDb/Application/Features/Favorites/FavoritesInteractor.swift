//
//  FavoritesInteractor.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class FavoritesInteractor: AbstractInteractor {

    private var favoritesCollectionDataSource: FavoritesDataSource!
    private var favoritesCollectionDelegate: FavoritesDelegate!
    private var repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func requestDataSourceFor(_ vc: CardInteractionDelegate?) -> FavoritesDataSource {
        let items = FavoritesEntity.getModel().items.or([])
        favoritesCollectionDataSource = .init(data: items, handlerDelegate: vc)
        return favoritesCollectionDataSource
    }

    func requestDelegateFor(_ vc: CardInteractionDelegate?) -> FavoritesDelegate {
        favoritesCollectionDelegate = .init(dataProvider: self, handlerDelegate: vc)
        return favoritesCollectionDelegate
    }

    func filterDataBy(_ query: String) {
        favoritesCollectionDataSource.filterDataBy(query)
    }

    func updateData() {
        favoritesCollectionDataSource.set(newData: repository.fetchFavorites())
    }

    func addToFavorites(_ items: [Movie]) {
        repository.saveAsFavorites(items)
    }
    
    func removeFromFavorites(_ item: Movie) {
        item.isFavorite = false
        repository.deleFromFavorites([item])
        updateData()
    }
}

extension FavoritesInteractor: DataSourceProvider {
    func getNumberOfItemsIn(section: Int) -> Int {
        return favoritesCollectionDataSource.getNumberOfItemsIn(section: section)
    }

    func getData() -> DataDiplayedType<Movie> {
        return favoritesCollectionDataSource.getData()
    }

    func insert(_ item: Movie, at index: IndexPath) {
        favoritesCollectionDataSource.insert(item, at: index)
    }
}
