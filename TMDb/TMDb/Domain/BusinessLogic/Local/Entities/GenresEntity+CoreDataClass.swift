//
//  GenresEntity+CoreDataClass.swift
//  
//
//  Created by Renato Machado Filho on 19/08/19.
//
//

import Foundation
import CoreData

@objc(GenresEntity)
public class GenresEntity: NSManagedObject {
    static func parseToEntity(_ model: Genre?, context: NSManagedObjectContext) -> GenresEntity {
        let model = model.or(.init())
        let entity = GenresEntity(context: context)
        entity.id = Int64(truncatingIfNeeded: model.id)
        entity.name = model.name
        return entity
    }

    func parseToModel() -> Genre {
        return .init(id: Int(truncatingIfNeeded: id),
                     name: name.or(""))
    }
}
