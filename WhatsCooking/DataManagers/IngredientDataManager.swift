//
//  IngredientDataManager.swift
//  WhatsCooking
//
//  Created by Anindya Sengupta on 5/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import CoreData

final class IngredientDataManager {

    class func insertIngredient (with name: String, measure: String, meal: Meal){
        if let managedObjectContext = CoreDataManager.shared.managedObjectContext {
            managedObjectContext.performChanges {
                _ = Ingredient.insert(into: managedObjectContext, name: name, measure: measure, meal: meal)
            }
        }
    }

    class func updateIngredient(ingredient: Ingredient) {
        Ingredient.update(ingredient: ingredient)
    }

    class func deleteAllIngredients () {
        if let managedObjectContext = CoreDataManager.shared.managedObjectContext {
            managedObjectContext.performChanges {
                Ingredient.deleteAll(context: managedObjectContext)
            }
        }
    }
    
}
