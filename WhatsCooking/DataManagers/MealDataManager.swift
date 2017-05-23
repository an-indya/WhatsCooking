//
//  MealDataManager.swift
//  WhatsCooking
//
//  Created by Anindya Sengupta on 5/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import CoreData

final class MealDataManager {

    class func insertMeal (with id: String, title: String, instruction: String, thumbnail: Data?, sourceURL: String, thumbURL: String, completion: @escaping (Meal?) -> Void){

        if let managedObjectContext = CoreDataManager.shared.managedObjectContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Meal.entityName)
            let predicate = NSPredicate(format: "%K == %@", "id", id)
            fetchRequest.predicate = predicate
            do {
                let meals = try managedObjectContext.fetch(fetchRequest) as! [Meal]
                if meals.count == 0 {
                    managedObjectContext.performChanges {
                        let meal = Meal.insert(into: managedObjectContext, id: id, title: title, thumbnail: thumbnail, instruction: instruction, sourceURL: sourceURL, thumbURL: thumbURL)
                        completion(meal)
                    }
                } else {
                    completion(meals.first)
                }
            } catch {
                print("Fetching Failed")
                completion(nil)
            }
        }
    }

    class func updateMeal (id: String, with thumbnail: Data){
        if let managedObjectContext = CoreDataManager.shared.managedObjectContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Meal.entityName)
            let predicate = NSPredicate(format: "%K == %@", "id", id)
            fetchRequest.predicate = predicate
            do {
                if let meals = try managedObjectContext.fetch(fetchRequest) as? [Meal] {
                    if meals.count == 1 {
                        let meal = meals[0]
                        managedObjectContext.performChanges {
                            meal.thumbnail = thumbnail
                        }
                    }
                }

            } catch {
                print("Fetching Failed")
            }
        }
    }

    class func fetchRandomMeal(completion: (Meal?)-> Void) {
        if let managedObjectContext = CoreDataManager.shared.managedObjectContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Meal.entityName)
            do {
                if let meals = try managedObjectContext.fetch(fetchRequest) as? [Meal] {
                    let randomNumber = Int(arc4random_uniform(5) + 1)
                    if meals.count > randomNumber {
                        completion(meals[randomNumber])
                    } else {
                        completion(meals.first ?? nil)
                    }
                }
            } catch {
                print("Fetching Failed")
                completion(nil)
            }
        }
    }

    class func fetchMeal(with id: String, completion: (Meal?)-> Void) {
        if let managedObjectContext = CoreDataManager.shared.managedObjectContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Meal.entityName)
            let predicate = NSPredicate(format: "%K == %@", "id", id)
            fetchRequest.predicate = predicate
            do {
                if let meals = try managedObjectContext.fetch(fetchRequest) as? [Meal],
                    let meal = meals.first {
                    completion(meal)
                }
            } catch {
                print("Fetching Failed")
                completion(nil)
            }
        }
    }
    
}
