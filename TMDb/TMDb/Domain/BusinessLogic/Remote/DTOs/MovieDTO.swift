//
//  MovieDTO.swift
//  TMDb
//
//  Created by Renato Machado Filho on 19/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//
import Foundation

struct MovieDTO {
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [GenreDTO]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompanyDTO]?
    let productionCountries: [ProductionCountryDTO]?
    let releaseDate: Date?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguageDTO]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieDTO: DTO {
    typealias M = Movie

    init(model: Movie?) {
        adult = nil
        backdropPath = model?.backdropPath
        budget = model?.budget
        genres = model?.genres.compactMap(GenreDTO.init)
        homepage = nil
        id = model?.id
        imdbID = nil
        originalLanguage = nil
        originalTitle = model?.originalTitle
        overview = model?.overview
        popularity = model?.popularity
        posterPath = model?.posterPath
        productionCompanies = nil
        productionCountries = nil
        releaseDate = model?.releaseDate
        revenue = nil
        runtime = nil
        spokenLanguages = nil
        status = nil
        tagline = nil
        title = model?.title
        video = nil
        voteAverage = model?.voteAverage
        voteCount = model?.voteCount
    }

    func parseToModel() -> Movie {
        return .init(backdropPath: backdropPath.or(""),
                     budget: budget.or(0),
                     genres: genres.or([]).compactMap({ $0.parseToModel() }),
                     id: id.or(0),
                     originalTitle: originalTitle.or(""),
                     overview: overview.or(""),
                     popularity: popularity.or(0),
                     posterPath: posterPath.or(""),
                     releaseDate: releaseDate,
                     title: title.or(""),
                     voteAverage: voteAverage.or(0),
                     voteCount: voteCount.or(0),
                     isFavorite: false)
    }
}


