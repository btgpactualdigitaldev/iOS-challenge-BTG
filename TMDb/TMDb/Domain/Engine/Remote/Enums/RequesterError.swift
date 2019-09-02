//
//  RequesterError.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//
import Foundation

enum RequesterError: String, CustomError {
    case parametersNil  = "Parameters were nil."
    case encodingFailed = "Parameters encoding failed."
    case missingURL     = "URL is nil."

    var description: String {
        return rawValue
    }
}
