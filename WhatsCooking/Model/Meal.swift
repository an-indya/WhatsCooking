//
//  Meal.swift
//  WhatsCooking
//
//  Created by Anindya Sengupta on 5/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

final class Meal: NSManagedObject {
    @NSManaged public fileprivate(set) var id: String
    @NSManaged public fileprivate(set) var title: String
    @NSManaged public var thumbnail: Data?
    @NSManaged public fileprivate(set) var instruction: String
    @NSManaged public fileprivate(set) var sourceURL: String
    @NSManaged public fileprivate(set) var thumbURL: String
    @NSManaged public fileprivate(set) var ingredients: Set<Ingredient>?


    static func insert(into context: NSManagedObjectContext, id: String, title: String, thumbnail: Data?, instruction: String, sourceURL: String, thumbURL: String) -> Meal {
        let meal: Meal = context.insertObject()
        meal.id = id
        meal.title = title
        meal.thumbnail = thumbnail
        meal.instruction = instruction
        meal.sourceURL = sourceURL
        meal.thumbURL = thumbURL
        return meal
    }


    static func deleteAll (context: NSManagedObjectContext) {
        delete(context)
    }
}

extension Meal: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true)]
    }
}
