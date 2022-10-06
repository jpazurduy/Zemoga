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
                print("Unresolved error \(error)")
            }
        }
    }
    
    func saveContext(entityName: String) {
        if container.viewContext.hasChanges {
            do {
                print ("Saved")
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func loadPostData() -> [NSManagedObject] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
//        let sort = NSSortDescriptor(key: "gitcommit.committer.date", ascending: false)
//        request.sortDescriptors = [sort]
        
        do {
            // fetch is performed on the NSManagedObjectContext
            data = try container.viewContext.fetch(request)
            print("Got \(data.count) commits")
            return data
            //tableView.reloadData()
        } catch {
            print("Fetch failed")
            return data
        }
    }
}
