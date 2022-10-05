//
//  DetailViewModel.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/3/22.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func updateView(author: Author)
    func updateView(comments: [Comment])
    func showError(error: String)
}

class DetailViewModel {
    weak var delegate: DetailViewModelDelegate?
    var post: Post
    var author: Author?
    var comments: [Comment] = []
    
    init(post: Post) {
        self.post = post
    }
    
    func requestAuthor(authorId: Int) {
        NetworkManager.shared.requestAuthor(authorId: authorId, parameters: "") { response in
            DispatchQueue.main.async { [unowned self] in
                switch response {
                case .success(let value):
                    log.info("Getting author information successful: \(Date().description)")
                    author = value
                    self.delegate?.updateView(author: value)
                case .failure(let error):
                    log.info("Error getting author information : " + error.localizedDescription)
                    self.delegate?.showError(error: "Error: \(error.localizedDescription): \(error)")
                }
            }
        }
    }
    
    func requestComments(postId: Int) {
        NetworkManager.shared.requestComments(postId: postId, parameters: "") { response in
            DispatchQueue.main.async { [unowned self] in
                switch response {
                case .success(let value):
                    log.info("Getting comments information successful: \(Date().description)")
                    comments = value
                    self.delegate?.updateView(comments: value)
                case .failure(let error):
                    log.info("Error getting comments information : " + error.localizedDescription)
                    self.delegate?.showError(error: "Error: \(error.localizedDescription): \(error)")
                }
            }
        }
    }
}
