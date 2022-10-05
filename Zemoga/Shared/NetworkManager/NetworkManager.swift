//
//  WebService.swift
//  App
//
//  Created by Jorge Azurduy on 10/1/22.
//

import Foundation

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
                 timeout: Double = 60.0) {
        
        self.sessionConfiguration = sessionConfiguration
        self.sessionConfiguration.timeoutIntervalForRequest = timeout
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
                completion(.failure(WebError.badURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            if let params = parameters, method != .get {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try? encoder.encode(params)
                print(String(data: jsonData!, encoding: .utf8)!)
                request.httpBody = jsonData
            }

            dataTask = session?.dataTask(with: request) { (data, response, error) in

                if let error = error {
                    completion(.failure(WebError.requestFailed(error)))
                    return
                }

                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    completion(.failure(WebError.serverError(statusCode: response.statusCode)))
                    return
                }

                guard let data = data else {
                    completion(.failure(WebError.noData))
                    return
                }
                            
                do {
                    self.printJSON(data: data, path: pathURL, method: method)
                    let decoder = JSONDecoder()
                    let decode = try decoder.decode(T.self, from: data)
                    completion(.success(decode))
                } catch {
                    completion(.failure(WebError.unknown(error)))
                }
            }
            dataTask?.resume()
        }
    }
    
    func sendRequest<T: Decodable, U: Encodable>(pathURL: String,
                                                 parameters: U?,
                                                 method: HttpMethod,
                                                 completion: @escaping (Result<[T], Error>) -> Void) {
        
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: pathURL) else {
                completion(.failure(WebError.badURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            if let params = parameters, method != .get {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try? encoder.encode(params)
                print(String(data: jsonData!, encoding: .utf8)!)
                request.httpBody = jsonData
            }
            
            dataTask = session?.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    completion(.failure(WebError.requestFailed(error)))
                    return
                }
                
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    completion(.failure(WebError.serverError(statusCode: response.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(WebError.noData))
                    return
                }
                
                do {
                    self.printJSON(data: data, path: pathURL, method: method)
                    let decoder = JSONDecoder()
                    let decode = try decoder.decode([T].self, from: data)
                    completion(.success(decode))
                } catch {
                    completion(.failure(WebError.unknown(error)))
                }
            }
            dataTask?.resume()
        }
    }
}
