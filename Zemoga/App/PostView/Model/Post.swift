//
//  Post.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/1/22.
//

import Foundation

struct Posts: Codable {
    let posts: [Post]
}

struct Post: Codable {
    let userId :Int
    let id: Int
    let title: String
    let body: String
    var isLiked: Bool = false

    private enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
}
