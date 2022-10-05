//
//  PostViewModel.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/1/22.
//

import Foundation

protocol PostViewModelDelegate: AnyObject {
    func updateView(posts: [Post])
    func showError(error: String)
}

class PostViewModel {
    weak var delegate: PostViewModelDelegate?
    var posts: [Post] = []
    
    func requestPosts() {
        NetworkManager.shared.requestPosts(parameters: "") { response in
            DispatchQueue.main.async { [unowned self] in
                switch response {
                case .success(let value):
                    log.info("Login successful: \(Date().description)")
                    posts = value
                    self.delegate?.updateView(posts: value)
                case .failure(let error):
                    log.info("Login Error: " + error.localizedDescription)
                    self.delegate?.showError(error: "Error: \(error.localizedDescription): \(error)")
                }
            }
        }
    }
}
