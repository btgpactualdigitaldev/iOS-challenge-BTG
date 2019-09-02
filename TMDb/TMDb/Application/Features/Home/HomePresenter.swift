//
//  HomePresenter.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

protocol HomePresenterDelegate: class {
    typealias DataSourceType = [Movie]
    func dataSourceDidUpdate(result: PaginationResultType)
    func presentFeedbackLoading(isLoading: Bool)
    func hidePaginationIndicator()
    func onError(title: String?, message: String?)
}

class HomePresenter: AbstractPresenter<HomeInteractor, HomeRouter> {
    
    public weak var delegate: HomePresenterDelegate?
    
    func route(deepLink: DeeplinkType) {
        delegate?.presentFeedbackLoading(isLoading: true)
        switch deepLink {
        case .details(let id):
            interactor.requestDetails(id: id) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    self.didSelectItem(value)
                case .failure(let error):
                    self.delegate?.onError(title:  "Ops! :(", message: error.description)
                    self.delegate?.presentFeedbackLoading(isLoading: false)
                }
            }
        }
    }

    func getDelegate(vc: (CardInteractionDelegate & PaginationDelegate)?) -> HomeCollectionDelegate {
        return interactor.requestDelegateFor(vc)
    }

    func getDataSource(vc: CardInteractionDelegate?) -> HomeCollectionDataSource {
        return interactor.requestDataSourceFor(vc)
    }

    func fetchData(by query: String? = nil, for page: Int, isPullRefresh: Bool = false, completionHandler: (() -> Void)? = nil) {
        if page == 1 && (isPullRefresh == false && query == nil) {
            delegate?.presentFeedbackLoading(isLoading: true)
        }

        interactor.requestData(by: query, for: page, completionHandler: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.delegate?.dataSourceDidUpdate(result: value)
            case .failure(let error):
                self.delegate?.onError(title:  "Ops! :(", message: error.description)
                self.delegate?.hidePaginationIndicator()
            }
            self.delegate?.presentFeedbackLoading(isLoading: false)
            completionHandler?()
        })
    }

    func addToFavorites(_ item: Movie) {
        interactor.addToFavorites([item])
    }

    func addToFavorites(_ items: [Movie]) {
        items.forEach({ $0.isFavorite = true })
        interactor.addToFavorites(items)
        delegate?.dataSourceDidUpdate(result: .newData)
    }
    
    func removeFromFavorites(_ item: Movie) {
        interactor.removeFromFavorites([item])
    }

    func removeFromFavorites(_ items: [Movie]) {
        items.forEach({ $0.isFavorite = false })
        interactor.removeFromFavorites(items)
    }
    
    func filterDataBy(_ query: String) {
        fetchData(by: query, for: 1, completionHandler: nil)
    }
    
    func searchWasCanceled() {
        fetchData(for: 1, completionHandler: nil)
    }

    func reloadData() {
        interactor.reloadDataWithFavoritedItems()
    }
    
    func didSelectItem(_ item: Movie) {
        delegate?.presentFeedbackLoading(isLoading: true)
        interactor.requestDetails(id: item.id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.router?.presentDetailsScreen(value)
            case .failure:
                break
            }
            self.delegate?.presentFeedbackLoading(isLoading: false)
        }
    }
}
