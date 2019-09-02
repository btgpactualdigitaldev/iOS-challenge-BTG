//
//  ViewConfigurator.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

protocol ViewConfigurator: class {
    func setup()
    func prepareViews()
    func addViewHierarchy()
    func setupConstraints()
    func configureViews()
    func configureBindings()
}

extension ViewConfigurator {
    func setup() {
        prepareViews()
        addViewHierarchy()
        setupConstraints()
        configureViews()
        configureBindings()
    }
}
