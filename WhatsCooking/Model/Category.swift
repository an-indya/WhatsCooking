//
//  Category.swift
//  WhatsCooking
//
//  Created by Anindya Sengupta on 5/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import CoreData

final class Category: NSManagedObject {
    @NSManaged public fileprivate(set) var name: String

    static func insert(into context: NSManagedObjectContext, name: String) -> Category {
        let category: Category = context.insertObject()
        category.name = name
        return category
    }
}

extension Category: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
}
