//
//  WebService.swift
//  App
//
//  Created by Jorge Azurduy on 10/1/22.
//

import CoreData
import Foundation
import UIKit

enum HttpMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

enum WebError: Error {
    case requestFailed(Error)
    case serverError(statusCode: Int)
    case badURL
    case unknown(Error)
    case noData
    case noConnection
}

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}

typealias ResultCompletion<T, Error> = (Result<T, Error>) -> Void

class NetworkManager {

    private var sessionConfiguration = URLSessionConfiguration.default
    private var session: URLSession?
    private var dataTask: URLSessionDataTask?
    private var contentType = "application/json"
    
    static let shared = NetworkManager()
    
    @discardableResult
    private init(sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default,
                 timeout: Double = 10.0) {
        
        self.sessionConfiguration = sessionConfiguration
        self.sessionConfiguration.timeoutIntervalForRequest = timeout
        self.sessionConfiguration.timeoutIntervalForResource = timeout
        self.session = URLSession(configuration: self.sessionConfiguration)
    }
    
    func printJSON(data: Data, path: String, method: HttpMethod) {
        print()
        print("\(method.rawValue.uppercased()): \(path)")
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print(String(decoding: jsonData, as: UTF8.self))
        } else {
            print("JSON malformed data.")
        }
    }

    func sendRequest<T: Decodable, U: Encodable>(pathURL: String,
                                                 parameters: U?,
                                                 method: HttpMethod,
                                                 completion: @escaping (Result<T, Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: pathURL) else {
                log.error("Invalid URL path: -> \(pathURL)")
                completion(.failure(WebError.badURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            if let params = parameters, method != .get {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try? encoder.encode(params)
                //print(String(data: jsonData!, encoding: .utf8)!)
                request.httpBody = jsonData
            }

            dataTask = session?.dataTask(with: request) { (data, response, error) in

                if let error = error {
                    log.error(error.localizedDescription)
                    log.error("Error getting data information from: -> \(pathURL)")
                    completion(.failure(WebError.requestFailed(error)))
                    return
                }

                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    log.error("HTTP status code error \(response.statusCode) from: -> \(pathURL)")
                    completion(.failure(WebError.serverError(statusCode: response.statusCode)))
                    return
                }

                guard let data = data else {
                    log.error("There is no data from the request: -> \(pathURL)")
                    completion(.failure(WebError.noData))
                    return
                }
                            
                do {
                    //self.printJSON(data: data, path: pathURL, method: method)
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = PersistanceManager.shared.container.viewContext
                    let decode = try decoder.decode(T.self, from: data)
                    
                    DispatchQueue.main.async {
                        PersistanceManager.shared.saveContext(entityName: "\(T.self)")
                        completion(.success(decode))
                    }
                } catch {
                    log.error("Error decoding data from: -> \(pathURL)")
                    completion(.failure(WebError.unknown(error)))
                }
            }
            dataTask?.resume()
        } else {
            log.error("There is no internet connection available.")
            completion(.failure(WebError.noConnection))
        }
    }
    
    func sendRequest<T: Decodable, U: Encodable>(pathURL: String,
                                                 parameters: U?,
                                                 method: HttpMethod,
                                                 completion: @escaping (Result<[T], Error>) -> Void) {
        
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: pathURL) else {
                log.error("Invalid URL path: -> \(pathURL)")
                completion(.failure(WebError.badURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            if let params = parameters, method != .get {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try? encoder.encode(params)
                //print(String(data: jsonData!, encoding: .utf8)!)
                request.httpBody = jsonData
            }
            
            dataTask = session?.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    log.error(error.localizedDescription)
                    log.error("Error getting data information from: -> \(pathURL)")
                    completion(.failure(WebError.requestFailed(error)))
                    return
                }
                
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    log.error("HTTP status code error \(response.statusCode) from: -> \(pathURL)")
                    completion(.failure(WebError.serverError(statusCode: response.statusCode)))
                    return
                }
                
                guard let data = data else {
                    log.error("There is no data from the request: -> \(pathURL)")
                    completion(.failure(WebError.noData))
                    return
                }
                
                do {
                    //self.printJSON(data: data, path: pathURL, method: method)
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = PersistanceManager.shared.container.viewContext
                    let decode = try decoder.decode([T].self, from: data)
                    
                    DispatchQueue.main.async {
                        PersistanceManager.shared.saveContext(entityName: "\(T.self)")
                        completion(.success(decode))
                    }
                } catch {
                    log.error("Error decoding data from: -> \(pathURL)")
                    completion(.failure(WebError.unknown(error)))
                }
            }
            dataTask?.resume()
        } else {
            log.error("There is no internet connection available.")
            completion(.failure(WebError.noConnection))
        }
    }
}
