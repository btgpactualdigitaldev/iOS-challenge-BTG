//
//  CustomError.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

protocol CustomError: Error {
    var description: String { get }
}
