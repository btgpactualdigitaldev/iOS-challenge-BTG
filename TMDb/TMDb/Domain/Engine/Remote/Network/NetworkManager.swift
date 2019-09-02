//
//  NetworkManager.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class NetworkManager<S: Service>: Network {
    var router: NetworkRouter<S>

    init() {
        router = .init()
    }

    func request<T: Decodable>(service: S, result: @escaping (Result<T>) -> Void) {
        let router: NetworkRouter = NetworkRouter<S>()
        
        router.perform(service) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = error {
                    let errorCode = (error as NSError).code
                    result(.failure(self.handlerNetworkErrorFor(statusCode: errorCode)))
                    return
                }
                
                guard let response = urlResponse as? HTTPURLResponse else {
                    result(.failure(NetworkError.castResponse))
                    return
                }
                
                switch response.statusCode {
                case 200...299:
                    guard let responseData = data else {
                        result(.failure(NetworkError.noData))
                        return
                    }
                    
                    do {
                        let objectDecodabled = try service.decoder.decode(T.self, from: responseData)
                        result(.success(objectDecodabled))
                    } catch {
                        result(.failure(NetworkError.unableToDecode))
                    }
                    
                default:
                    guard let requesterError = service.errorFor(statusCode: response.statusCode) else {
                        result(.failure(self.handlerNetworkErrorFor(statusCode: response.statusCode)))
                        return
                    }
                    result(.failure(requesterError))
                }
            }
        }
    }
    
    fileprivate func handlerNetworkErrorFor(statusCode: Int) -> CustomError {
        switch statusCode {
        case 404:         return NetworkError.notFounded
        case 401...500:   return NetworkError.authentication
        case 501...599:   return NetworkError.badRequest
        case 600:         return NetworkError.outdated
        case -1001,-1009: return NetworkError.connection
        default: return NetworkError.failed
        }
    }
}
