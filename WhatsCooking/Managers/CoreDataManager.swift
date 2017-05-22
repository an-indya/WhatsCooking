//
//  CoreDataManager.swift
//  Virtual-Tourist
//
//  Created by Anindya Sengupta on 5/4/17.
//  Copyright © 2017 Udacity. All rights reserved.
//  Inspired from objc.io - Core Data Book by Florian Kugler and Daniel Eggert

import UIKit
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    private override init() {}
    var managedObjectContext: NSManagedObjectContext!

    func createWCContainer(completion: @escaping (NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: "WhatsCooking")
        container.loadPersistentStores { _, error in
            guard error == nil else { fatalError("Failed to load store: \(String(describing: error))") }
            DispatchQueue.main.async { completion(container) }
        }
    }

}

protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed {

    public static var defaultSortDescriptors: [NSSortDescriptor] { return [] }
    public static var defaultPredicate: NSPredicate { return NSPredicate(value: true) }

    public static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = defaultPredicate
        return request
    }

    public static func sortedFetchRequest(with predicate: NSPredicate) -> NSFetchRequest<Self> {
        let request = sortedFetchRequest
        guard let existingPredicate = request.predicate else { fatalError("must have predicate") }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [existingPredicate, predicate])
        return request
    }

    public static func predicate(format: String, _ args: CVarArg...) -> NSPredicate {
        let p = withVaList(args) { NSPredicate(format: format, arguments: $0) }
        return predicate(p)
    }

    public static func predicate(_ predicate: NSPredicate) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [defaultPredicate, predicate])
    }

}


extension Managed where Self: NSManagedObject {
    static var entity: NSEntityDescription { return entity()  }
    static var entityName: String { return entity.name! }
}

extension Managed where Self: NSManagedObject {
    static func delete (_ managedObjectContext: NSManagedObjectContext, where predicate: NSPredicate? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        let batchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchRequest.resultType = .resultTypeStatusOnly
        try! managedObjectContext.execute(batchRequest)
    }
}

extension NSManagedObjectContext {
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
}

extension NSManagedObjectContext {
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    public func performChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}
