//
//  ViewController.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ViewConfigurator, DeepLinker {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func prepareViews() {}
    func addViewHierarchy() {}
    func setupConstraints() {}
    func configureViews() {}
    func configureBindings() {}
    func execute(deepLink: DeeplinkType) {}
}
