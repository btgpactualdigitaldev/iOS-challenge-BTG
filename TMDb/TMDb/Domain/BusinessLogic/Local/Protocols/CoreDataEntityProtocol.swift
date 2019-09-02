//
//  CoreDataEntitiesProtocol.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataEntityProtocol: class {
    associatedtype M: NSObject
    static func save(model: M)
    static func getModel() -> M
}
