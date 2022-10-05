//
//  Comments.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/2/22.
//

import Foundation

// MARK: - Comment
struct Comment: Codable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
    
    init(postId: Int, id: Int, name: String, email: String, body: String) {
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
}
