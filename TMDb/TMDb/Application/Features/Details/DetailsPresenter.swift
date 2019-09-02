//
//  DetailsPresenter.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class DetailsPresenter: AbstractPresenter<DetailsInteractor, DetailsRouter> {

    func getData() -> Movie? {
        return interactor.getData()
    }

    func setAsFavorite() {
        interactor.addToFavorites()
    }

    func setAsUnFavorite() {
        interactor.removeFromFavorites()
    }
}
