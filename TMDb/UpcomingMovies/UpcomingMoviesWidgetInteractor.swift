//
//  UpcomingMoviesWidgetInteractor.swift
//  HeroesOfTheDay
//
//  Created by Renato De Souza Machado Filho on 06/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class UpcomingMoviesWidgetInteractor: AbstractInteractor {
    private var repository: MovieRepository
    private var heroOfTheDayDataSourceAndDelegate: UpcomingMoviesWidgetDataSourceAndDelegate!

    init(repository: MovieRepository) {
        self.repository = repository
        heroOfTheDayDataSourceAndDelegate = .init()
    }

    func requestDataSourceAndDelegateFor(_ vc: UpcomingMoviesWidgetInteractionDelegate?) -> UpcomingMoviesWidgetDataSourceAndDelegate {
        heroOfTheDayDataSourceAndDelegate.delegate = vc
        return heroOfTheDayDataSourceAndDelegate
    }

    func requestData(_ completionHandler: @escaping (Result<PaginationResultType>) -> Void) {
        repository.fetchUpcoming(page: 1) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                let dataCount = value.results.count
                if dataCount > 0 {
                    self.heroOfTheDayDataSourceAndDelegate.removeAllData()
                    self.heroOfTheDayDataSourceAndDelegate?.set(newData: Array(value.results.prefix(3)))
                    completionHandler(.success(.newData))
                } else {
                    completionHandler(.success(.noData))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
