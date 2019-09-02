//
//  MovieEntity+CoreDataClass.swift
//  
//
//  Created by Renato Machado Filho on 19/08/19.
//
//

import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {

    static func parseToEntity(_ model: Movie?, context: NSManagedObjectContext) -> MovieEntity {
        let model = model.or(.init())
        let entity = MovieEntity(context: context)
        entity.id = Int64(truncatingIfNeeded: model.id)
        entity.backdropPath = model.backdropPath
        entity.budget = Int64(truncatingIfNeeded: model.budget)
        entity.originalTitle = model.originalTitle
        entity.overview = model.overview
        entity.title = model.title
        entity.voteAverage = model.voteAverage
        entity.releaseDate = model.releaseDate as NSDate?
        entity.voteCount = Int64(truncatingIfNeeded: model.voteCount)
        let genres = model.genres.compactMap({ GenresEntity.parseToEntity($0, context: context) })
        entity.genres = Set(genres)
        entity.isFavorite = model.isFavorite

        return entity
    }

    func parseToModel() -> Movie {
        return .init(backdropPath: backdropPath.or(""),
                     budget: Int(truncatingIfNeeded: budget),
                     genres: genres.or([]).compactMap({ $0.parseToModel() }),
                     id: Int(truncatingIfNeeded: id),
                     originalTitle: originalTitle.or(""),
                     overview: overview.or(""),
                     popularity: popularity,
                     posterPath: posterPath.or(""),
                     releaseDate: releaseDate as Date?,
                     title: title.or(""),
                     voteAverage: voteAverage,
                     voteCount: Int(truncatingIfNeeded: voteCount),
                     isFavorite: isFavorite)
    }

    static func get(_ item: Movie) -> Movie? {
        let context = DatabaseController.getContext()
        var model: Movie?

        do {
            let entities = try context.fetch(MovieEntity.fetchRequest(with: "id == \(item.id)"))
            if let entity = entities.first as? MovieEntity {
                model = entity.parseToModel()
            }
        } catch {
            NSLog("Core Data error: \(error.localizedDescription)")
        }

        return model
    }
}
