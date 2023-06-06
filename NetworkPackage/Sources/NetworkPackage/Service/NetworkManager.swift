//
//  NetworkManager.swift
//  
//
//  Created by Batuhan Demircioğlu on 5.06.2023.
//

import Foundation

public protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint<T>, completion: @escaping (Result<T, Error>) -> Void)
}

public class NetworkManager: NetworkManagerProtocol {
    
    public static let shared = NetworkManager()
    public init() {}
    
    public func request<T: Decodable>(_ endpoint: Endpoint<T>, completion: @escaping (Result<T, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: endpoint.request()) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode >= 200, response.statusCode <= 299 else {
                completion(.failure(NSError(domain: "Invalid Response", code: 0)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Invalid Response Data", code: 0)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    public func getResults<T: Decodable>(searchText: String, completion: @escaping(Result<T, Error>) -> Void) {
        let endpoint = Endpoint<T>.getResults(searchText: searchText)
        request(endpoint, completion: completion)
    }
}
