//
//  NetworkRouter.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

class NetworkRouter<S: Service>: Router {
    private var task: URLSessionTask?
    
    func perform(_ service: S, completion: @escaping RouterCompletion) {
        let session: URLSession = .shared
        
        do {
            let request = try buildRequestFrom(service)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
                NetworkLogger.log(response: urlResponse, data: data)
                completion(data, urlResponse, error)
            })
        } catch let error {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    func buildRequestFrom(_ service: S) throws -> URLRequest {
        var fullUrl: URL = service.baseURL
        
        if !service.path.isEmpty {
            fullUrl = service.baseURL.appendingPathComponent(service.path)
        }
        
        var request: URLRequest = URLRequest(url: fullUrl,
                                             cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                             timeoutInterval: 10)
        request.httpMethod = service.httpMethod.rawValue
        
        do {
            switch service.task {
            case .request:
                request.setValue(NetworkConstants.ContentType.json.rawValue,
                                forHTTPHeaderField: NetworkConstants.HTTPHeaderField.contentType.rawValue)
            case .requestWith(let urlParameters,
                              let bodyParameters):
                
                try configureWith(urlParameters: urlParameters,
                                  bodyParameters: bodyParameters,
                                  request: &request)
                
            case .requestWithAdditional(let auth,
                                        let urlParameters,
                                        let bodyParameters):

                try configureWith(urlParameters: urlParameters,
                                  bodyParameters: bodyParameters,
                                  request: &request)
                switch auth {
                case .url(let parameters)?:
                    setAdditionalAuth(parameters, request: &request)
                case .header(let parameters)?:
                    setAdditionalHeaders(parameters, request: &request)
                case .none:
                    break
                }
            }
            return request
        } catch let error {
            throw error
        }
    }
    
    final fileprivate func configureWith(urlParameters: Parameters?, bodyParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let parameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: parameters)
            }
            
            if let parameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: parameters)
            }
        } catch let error {
            throw error
        }
    }
    
    final fileprivate func setAdditionalHeaders(_ headers: HTTPHeaders?, request: inout URLRequest) {
        guard let headers: HTTPHeaders = headers else {
            return
        }
        
        headers.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

    final fileprivate func setAdditionalAuth(_ parameters: Parameters, request: inout URLRequest) {
        guard let url = request.url else { return }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

        if urlComponents?.queryItems == nil {
           urlComponents?.queryItems = []
        }

        let queryItems = parameters.compactMap {
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }

        urlComponents?.queryItems?.append(contentsOf: queryItems)
        request.url = urlComponents?.url
    }
}
