//
//  Paths.swift
//  App
//
//  Created by Jorge Azurduy.
//

import Foundation

struct Path {
    
    // Production
    static let baseURL = "https://jsonplaceholder.typicode.com"
    
    static let posts = baseURL + "/posts"
    
    static func getAuthor(id: Int32) -> String {
        return baseURL + "/users/\(id)"
    }
    
    static func getComments(postId: Int32) -> String {
        return baseURL + "/comments?postId=\(postId)"
    }
}
