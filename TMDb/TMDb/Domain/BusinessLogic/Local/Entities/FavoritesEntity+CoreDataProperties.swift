//
//  FavoritesEntity+CoreDataProperties.swift
//  
//
//  Created by Renato Machado Filho on 19/08/19.
//
//

import Foundation
import CoreData


extension FavoritesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesEntity> {
        return NSFetchRequest<FavoritesEntity>(entityName: "FavoritesEntity")
    }

    @NSManaged public var items: Set<MovieEntity>?

}

// MARK: Generated accessors for items
extension FavoritesEntity {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: MovieEntity)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: MovieEntity)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
