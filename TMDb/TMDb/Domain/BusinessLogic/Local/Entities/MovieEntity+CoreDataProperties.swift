//
//  MovieEntity+CoreDataProperties.swift
//  
//
//  Created by Renato Machado Filho on 19/08/19.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var budget: Int64
    @NSManaged public var id: Int64
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var title: String?
    @NSManaged public var releaseDate: NSDate?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int64
    @NSManaged public var popularity: Double
    @NSManaged public var isFavorite: Bool
    @NSManaged public var genres: Set<GenresEntity>?

}

// MARK: Generated accessors for genres
extension MovieEntity {

    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: GenresEntity)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: GenresEntity)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)

}
