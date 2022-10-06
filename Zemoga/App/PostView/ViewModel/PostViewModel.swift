//
//  PostViewModel.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/1/22.
//

import Foundation
import CoreData

protocol PostViewModelDelegate: AnyObject {
    func updateView(posts: [Post])
    func showError(error: String)
}

class PostViewModel {
    weak var delegate: PostViewModelDelegate?
    
    var posts: [NSManagedObject] = []
    var container: NSPersistentContainer!
    
    func requestPosts() {
        NetworkManager.shared.requestPosts(parameters: "") { response in
            DispatchQueue.main.async { [unowned self] in
                switch response {
                case .success(let value):
                    log.info("Getting post information successful: \(Date().description)")
                    posts = value
                    self.delegate?.updateView(posts: value)
                case .failure(let error):
                    log.error("Error getting post information: " + error.localizedDescription)
                    self.delegate?.showError(error: "Error: \(error.localizedDescription): \(error)")
                }
            }
        }
    }
    
    func createPersistentContainer() {
        // Create the persistent container and point to the xcdatamodeld - so matches the xcdatamodeld filename
        container = NSPersistentContainer(name: "CoreDataUsingCodable")
        
        // load the database if it exists, if not create it.
        container.loadPersistentStores { storeDescription, error in
            // resolve conflict by using correct NSMergePolicy
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    func loadSavedData() {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
//        let sort = NSSortDescriptor(key: "gitcommit.committer.date", ascending: false)
//        request.sortDescriptors = [sort]
        
        do {
            // fetch is performed on the NSManagedObjectContext
            posts = try container.viewContext.fetch(request)
            print("Got \(posts.count) commits")
            //tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    // save changes from memory back to the database (from memory)
    // viewContext is checked for changes
    // then saves are comitted to the store
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                print ("Saved")
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
