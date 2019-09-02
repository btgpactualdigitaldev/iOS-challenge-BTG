//
//  FavoritesEntity+CoreDataClass.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    class func fetchRequest(with query: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: query)
        return request
    }
}

@objc(FavoritesEntity)
public class FavoritesEntity: NSManagedObject {

    static func parseToEntity(_ model: Favorites?, context: NSManagedObjectContext) -> FavoritesEntity {
        let entity = FavoritesEntity(context: context)
        let setOfEntity = model?.items?.compactMap({ MovieEntity.parseToEntity($0, context: context) })
        entity.items = Set(setOfEntity.or([]))
        return entity
    }

    static func delete(_ item: Movie) {
        let context = DatabaseController.getContext()
        do {
            let entities = try context.fetch(MovieEntity.fetchRequest(with: "id == \(item.id)"))
            entities.forEach({ (entity) in
                if let entitie = entity as? MovieEntity {
                    DatabaseController.delete(object: entitie)
                }
            })
        } catch {
            NSLog("Core Data error: \(error.localizedDescription)")
        }
    }

    static func delete() {
        let context = DatabaseController.getContext()

        do {
            let entities = try context.fetch(FavoritesEntity.fetchRequest())
            if entities.count > 0 {
                if let entity = entities.first as? FavoritesEntity {
                    DatabaseController.delete(object: entity)
                }
            }
        } catch {
            NSLog("Core Data error: \(error.localizedDescription)")
        }
    }

    static func save(model: Favorites) {
        let context = DatabaseController.getContext()

        do {
            let entities = try context.fetch(FavoritesEntity.fetchRequest())
            if entities.count == 0 {
                let newEntity = FavoritesEntity(context: context)
                var newList: Set<MovieEntity> = []

                model.items?.forEach({ (item) in
                    let entity: MovieEntity = MovieEntity.parseToEntity(item, context: context)
                    newList.insert(entity)
                })

                newEntity.items = newList
                DatabaseController.saveContext()

            } else if let entity = entities.first as? FavoritesEntity {
                entity.items?.removeAll()
                var newList: Set<MovieEntity> = []

                model.items?.forEach({ (item) in
                    let entity: MovieEntity = MovieEntity.parseToEntity(item, context: context)
                    newList.insert(entity)
                })

                entity.items = newList
                DatabaseController.saveContext()
            }
        } catch {
            NSLog("Core Data error: \(error.localizedDescription)")
        }
    }

    static func getModel() -> Favorites {
        let context = DatabaseController.getContext()
        let model: Favorites = .init()

        do {
            let entities = try context.fetch(FavoritesEntity.fetchRequest())
            if let entity = entities.first as? FavoritesEntity {
                entity.items?.forEach({ (item) in
                    model.items?.append(item.parseToModel())
                })
            }
        } catch {
            NSLog("Core Data error: \(error.localizedDescription)")
        }

        model.items?.sort(by: { (item1, item2) -> Bool in
            return item1.releaseDate.or(.init()) > item2.releaseDate.or(.init())
        })

        return model
    }
}
