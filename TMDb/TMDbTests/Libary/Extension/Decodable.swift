//
//  Decodable.swift
//  TMDbTests
//
//  Created by Renato De Souza Machado Filho on 08/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

public extension Decodable {
    static func fromJSON<T: Decodable>(_ fileName: String, fileExtension: String = "json", decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let url = Bundle.allBundles.first(where: { $0.bundlePath.contains("xctest") })?.url(forResource: fileName, withExtension: fileExtension) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
