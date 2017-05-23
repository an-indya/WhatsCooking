//
//  Ingredient.swift
//  WhatsCooking
//
//  Created by Anindya Sengupta on 5/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

final class Ingredient: NSManagedObject {
    @NSManaged public fileprivate(set) var name: String
    @NSManaged public fileprivate(set) var measure: String
    @NSManaged public var checked: Bool
    @NSManaged public fileprivate(set) var meal: Meal

    static func insert(into context: NSManagedObjectContext, name: String, measure: String, meal: Meal) -> Ingredient {
        let ingredient: Ingredient = context.insertObject()
        ingredient.name = name
        ingredient.measure = measure
        ingredient.meal = meal
        ingredient.checked = false
        return ingredient
    }

    static func update(ingredient: Ingredient) {
        if let managedObjectContext = CoreDataManager.shared.managedObjectContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Ingredient.entityName)
            let namePredicate = NSPredicate(format: "%K == %@", "name", ingredient.name)
            let measurePredicate = NSPredicate(format: "%K == %@", "measure", ingredient.measure)
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, measurePredicate])
            do {
                let ingredients = try managedObjectContext.fetch(fetchRequest) as! [Ingredient]
                if let ing = ingredients.first {
                    managedObjectContext.performChanges {
                        ing.checked = ingredient.checked
                    }
                }
            } catch {
                print("Fetching Failed")
            }
        }
    }

    static func deleteAll (context: NSManagedObjectContext) {
        delete(context)
    }
}

extension Ingredient: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
}
