//
//  AbstractPresenter.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
/**
 Protocol used by the Presenter to comunicate with the View Controller
 */
public protocol AbstractPresenterDelegate: class {}

class AbstractPresenter<I, R: AbstractRouter>: AbstractInteractorDelegate {

    var interactor: I
    var router: R?
    
    public init(interactor i: I, router r: R) {
        self.interactor = i
        self.router = r
    }
    
    func onSessionError() {
        self.router?.onSessionError()
    }
    
    func goBackView(){
        self.router?.goBackView()
    }
}
