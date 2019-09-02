//
//  UpcomingMoviesWidgetPresenter.swift
//  HeroesOfTheDay
//
//  Created by Renato De Souza Machado Filho on 06/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class UpcomingMoviesWidgetPresenter: AbstractPresenter<UpcomingMoviesWidgetInteractor, UpcomingMoviesWidgetRouter> {

    init(_ vc: UIViewController) {
        super.init(interactor: .init(repository: MovieRemoteRepository()), router: .init(rootViewController: vc))
    }

    func didSelect(_ item: Movie, context: NSExtensionContext?) {
        router?.showDetailsFor(item, context: context)
    }

    func getDataSourceAndDelegate(vc: UpcomingMoviesWidgetInteractionDelegate?) -> UpcomingMoviesWidgetDataSourceAndDelegate {
        return interactor.requestDataSourceAndDelegateFor(vc)
    }

    func fetchData(_ completionHandler: @escaping (Result<PaginationResultType>) -> Void) {
        interactor.requestData({ (result) in
            switch result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                if let erro: NetworkError = error as? NetworkError {
                    switch erro {
                    case .connection:
                        break
                    default:
                        completionHandler(.failure(erro))
                    }
                }
            }
        })
    }
}
