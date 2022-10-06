//
//  PostViewModel.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/1/22.
//

import Foundation
import CoreData

protocol PostViewModelDelegate: AnyObject {
    func updateView()
    func showError(error: String)
}

class PostViewModel {
    weak var delegate: PostViewModelDelegate?
    
    var posts: [NSManagedObject] = []
    var container: NSPersistentContainer!
    var likedPosts: [Int: Bool] = [:]
    
    func requestPosts() {
        NetworkManager.shared.requestPosts(parameters: "") { response in
            DispatchQueue.main.async { [unowned self] in
                switch response {
                case .success(let value):
                    log.info("Getting post information successful: \(Date().description)")
                    posts = loadPostData()
                    self.delegate?.updateView()
                case .failure(let error):
                    posts = loadPostData()
                    if !posts.isEmpty {
                        self.delegate?.updateView()
                    }
                    log.error("Error getting post information: " + error.localizedDescription)
                    self.delegate?.showError(error: "Error: \(error.localizedDescription): \(error)")
                }
            }
        }
    }
    
    func loadPostData() -> [NSManagedObject] {
        posts = PersistanceManager.shared.loadPostData()
        return posts
    }
    
    // MARK: - Custom
    func setLikedPosts() {
        var index = 0
        while index < posts.count {
            var post = posts[index] as! Post
            if likedPosts[post.id] != nil {
                (posts[index] as! Post).isLiked = likedPosts[post.id]!
            }
            index+=1
        }
    }
    
    func sortedPosts() {
        var sortedPosts: [NSManagedObject] = []
        let liked = posts.filter({($0 as! Post).isLiked == true})
        let unliked = posts.filter({($0 as! Post).isLiked == false})
        sortedPosts.append(contentsOf: liked)
        sortedPosts.append(contentsOf: unliked)
        posts = sortedPosts
    }
}
