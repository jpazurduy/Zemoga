//
//  NetworkManager+Post.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/1/22.
//

import Foundation

extension NetworkManager {
    
    func requestPosts<U: Encodable>(parameters: U, completion: @escaping ResultCompletion<[Post], Error>) {
        let path = Path.posts
        sendRequest(pathURL: path, parameters: parameters, method: HttpMethod.get) { (result: Result<[Post], Error>) in
            switch result {
            case .success:
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
}
