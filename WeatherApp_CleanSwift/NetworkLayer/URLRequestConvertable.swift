//
//  URLRequestConvertable.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol URLRequestConvertable {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var urlQuery: [String: String] { get }
    var headers: [String: String] { get }
    var body: [String: Any] { get }
    var method: HTTPMethod { get }
}

extension URLRequestConvertable {
    
    var scheme: String { "https" }
    var host: String { "api.openweathermap.org" }
    var urlQuery: [String: String] { [:] }
    var headers: [String: String] { [:] }
    var body: [String: Any] { [:] }
    
    func asRequest() throws -> URLRequest {
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        if !urlQuery.isEmpty {
            let queryItems = urlQuery.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.queryItems = queryItems
        }
        
        //собираем урл из всех компонентов
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        
        if !body.isEmpty {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
}
