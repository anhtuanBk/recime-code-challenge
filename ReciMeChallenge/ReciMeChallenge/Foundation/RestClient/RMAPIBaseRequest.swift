//
//  RMBaseRequest.swift
//  
//
//
//

import Foundation

public protocol RMAPIBaseRequest {
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var body: String { get }
    var queryItems: [URLQueryItem] { get }

    func buildURLRequest() -> URLRequest
}

extension RMAPIBaseRequest {
    public func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        switch method {
        case .get:
            components?.queryItems = queryItems
        default:
            fatalError()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue
                
        return urlRequest
    }
}

