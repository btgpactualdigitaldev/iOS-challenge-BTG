//
//  AbstractInteractor.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

protocol AbstractInteractorDelegate {
    func onSessionError()
}

class AbstractInteractor {
    
    weak var delegate: AnyObject?

    func onSessionError() {
        (self.delegate as? AbstractInteractor)?.onSessionError()
    }
}
