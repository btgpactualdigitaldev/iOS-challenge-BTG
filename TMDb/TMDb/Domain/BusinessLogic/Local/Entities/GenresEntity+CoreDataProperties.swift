//
//  GenresEntity+CoreDataProperties.swift
//  
//
//  Created by Renato Machado Filho on 19/08/19.
//
//

import Foundation
import CoreData


extension GenresEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenresEntity> {
        return NSFetchRequest<GenresEntity>(entityName: "GenresEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
