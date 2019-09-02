//
//  Router.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

typealias RouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> Void

protocol Router: class {
    associatedtype S: Service
    func perform(_ service: S, completion: @escaping RouterCompletion)
    func buildRequestFrom(_ service: S) throws -> URLRequest
    func cancel()
}
