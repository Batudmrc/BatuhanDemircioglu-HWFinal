//
//  Endpoint.swift
//  
//
//  Created by Batuhan Demircioğlu on 5.06.2023.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    
    func request() -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum Endpoint<T: Decodable> {
    case getResults(searchText: String)
}

extension Endpoint: EndpointProtocol  {
    var method: HTTPMethod {
        switch self {
        case .getResults:
            return .get
        }
    }
    
    var header: [String : String]? {
        return nil
    }
    
    var baseURL: String {
        switch self {
        case .getResults(searchText: let searchText):
            return "https://itunes.apple.com/search?term=\(searchText)&country=tr&media=music"
        }
    }
    
    var path: String {
        switch self {
        case .getResults:
            return ""
        }
    }
    
    func request() -> URLRequest {
        let urlString = baseURL + path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
}
