//
//  Movie.swift
//  TMDb
//
//  Created by Renato Machado Filho on 19/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation
import MobileCoreServices

class Movie: NSObject, Model, Favoritable  {
    var backdropPath: String
    var budget: Int
    var genres: [Genre]
    var id: Int
    var originalTitle, overview: String
    var popularity: Double
    var posterPath: String
    var releaseDate: Date?
    var title: String
    var voteAverage: Double
    var voteCount: Int
    var isFavorite: Bool

    required override init() {
        backdropPath = ""
        budget = 0
        genres = []
        id = 0
        originalTitle = ""
        overview = ""
        popularity = 0
        posterPath = ""
        releaseDate = Date()
        title = ""
        voteAverage = 0
        voteCount = 0
        isFavorite = false
    }

    init(backdropPath: String, budget: Int, genres: [Genre], id: Int, originalTitle: String, overview: String, popularity: Double, posterPath: String, releaseDate: Date?, title: String, voteAverage: Double, voteCount: Int, isFavorite: Bool) {
        self.backdropPath = backdropPath
        self.budget = budget
        self.genres = genres
        self.id = id
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.isFavorite = isFavorite
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? Movie {
            if other.id == self.id {
                return true
            }
        }
        return false
    }

    func getPosterFullImagePath() -> URL {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + backdropPath) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
}

extension Movie: NSItemProviderWriting, NSItemProviderReading {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeData as String)]
    }

    static var readableTypeIdentifiersForItemProvider: [String]  {
        return [(kUTTypeData) as String]
    }

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {

        let progress = Progress(totalUnitCount: 100)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(self)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        return progress
    }

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let subject = try decoder.decode(self, from: data)
            return subject
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
