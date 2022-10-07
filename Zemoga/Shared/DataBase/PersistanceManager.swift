//
//  PersistanceManager.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/6/22.
//

import CoreData
import Foundation

class PersistanceManager {
    
    static let shared = PersistanceManager()
    var container: NSPersistentContainer!
    private var data = [NSManagedObject]()
    
    @discardableResult
    private init() {
        // Create the persistent container and point to the xcdatamodeld - so matches the xcdatamodeld filename
        container = NSPersistentContainer(name: "Zemoga")
        
        // load the database if it exists, if not create it.
        container.loadPersistentStores { storeDescription, error in
            // resolve conflict by using correct NSMergePolicy
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                log.error("An error occurred loading loadPersistentStores: \(error)")
            }
        }
    }
    
    func saveContext(entityName: String) {
        if container.viewContext.hasChanges {
            do {
                log.info("Data saved successfull.")
                try container.viewContext.save()
            } catch {
                log.error("An error occurred while saving data: \(error)")
            }
        }
    }
    
    func loadPostData() -> [NSManagedObject] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        
        do {
            data = try container.viewContext.fetch(request)
            return data
        } catch {
            log.error("An error occurred while loading data: \(error)")
            return data
        }
    }
}
