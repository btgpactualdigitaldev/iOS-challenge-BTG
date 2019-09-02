//
//  FavoritesPresenter.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class FavoritesPresenter: AbstractPresenter<FavoritesInteractor, FavoritesRouter> {

    func getDelegate(vc: CardInteractionDelegate?) -> FavoritesDelegate {
        return interactor.requestDelegateFor(vc)
    }

    func getDataSource(vc: CardInteractionDelegate?) -> FavoritesDataSource {
        return interactor.requestDataSourceFor(vc)
    }

    func reloadData() {
        interactor.updateData()
    }

    func filterDataBy(_ query: String) {
        interactor.filterDataBy(query)
    }

    func searchWasCanceled() {
        interactor.filterDataBy("")
    }

    func addToFavorites(_ items: [Movie]) {
        interactor.addToFavorites(items)
    }

    func removeFromFavorite(_ item: Movie) {
        interactor.removeFromFavorites(item)
    }
    
    func didSelectItem(_ item: Movie) {
        router?.presentDetailsScreen(item)
    }
}
