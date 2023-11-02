//
//  HttpClient.swift
//  YT-Vapor-iOS-App
//
//  Created by Pedro Franco on 13/10/23.
//

import Foundation

enum HttpMethods: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "Content-Type"
}

enum HttpError: Error {
    case badUrl, badResponse, errorDecodingData, invalidURL
}

// Singleton
class HttpClient {
    private init() { }
    
    static let shared = HttpClient()
    
    func fetch<T: Codable>(url: URL) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Checando se a resposta é 200 (OK)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
        // Tenta decodar o objeto genérico que está vindo
        guard let object = try? JSONDecoder().decode([T].self, from: data) else {
            throw HttpError.errorDecodingData
        }
        
        return object
    }
    
    func sendData<T: Codable>(to url: URL, object: T, httpMehotd: String) async throws {
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMehotd
        
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        
        request.httpBody = try? JSONEncoder().encode(object)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }
    
    func delete(at id: UUID, url: URL) async throws {
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethods.DELETE.rawValue
        
        // _ for the data and finally the response (tuple)
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }
    
}
