//
//  NetworkManager+Detail.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/3/22.
//

import Foundation

extension NetworkManager {
    
    func requestAuthor<U: Encodable>(authorId: Int32, parameters: U, completion: @escaping ResultCompletion<Author, Error>) {
        let path = Path.getAuthor(id: authorId)
        sendRequest(pathURL: path, parameters: parameters, method: HttpMethod.get) { (result: Result<Author, Error>) in
            switch result {
            case .success:
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
    
    func requestComments<U: Encodable>(postId: Int32, parameters: U, completion: @escaping ResultCompletion<[Comment], Error>) {
        let path = Path.getComments(postId: postId)
        sendRequest(pathURL: path, parameters: parameters, method: HttpMethod.get) { (result: Result<[Comment], Error>) in
            switch result {
            case .success:
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
}
