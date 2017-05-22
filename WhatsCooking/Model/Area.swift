//
//  Area.swift
//  WhatsCooking
//
//  Created by Anindya Sengupta on 5/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

final class Area: NSManagedObject {
    @NSManaged public fileprivate(set) var area: String

    static func insert(into context: NSManagedObjectContext, areaName: String) -> Area {
        let area: Area = context.insertObject()
        area.area = areaName
        return area
    }
}

extension Area: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "area", ascending: true)]
    }
}
