//
//  ApiService.swift
//  Baluchon
//
//  Created by François-Xavier on 21/10/2023.
//

// APIService is a generic utility for making asynchronous HTTP requests and handling responses.
// It supports JSON decoding and provides error handling for various scenarios.

import Foundation

// enlever le static et l'url session de la méthode
// instance d'apiService

/// Performs an HTTP request and returns the result as a `Result` type.
///
/// - Parameters:
///   - url: The `EndPoint` representing the URL of the API endpoint to be called.
///   - method: The HTTP request method.
///   - parameters: Optional query parameters to include in the request.
  
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

struct APIService<T: Codable> {
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared){
        self.urlSession = urlSession
    }
        
    func performRequest(apiRequest: APIRequest) async -> Result<T, APIError> {

        // Create url with our parameters
        var components = URLComponents(string: apiRequest.url.value)
    
        if let parameters = apiRequest.parameters {
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
                
        guard let url = components?.url else {
            return .failure(.invalidUrl)
        }
                
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // Sending the request
            let (data, response) = try await urlSession.data(for: request)
                        
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unknownError)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(.invalidResponse(httpResponse.statusCode))
            }
            
            // Decoding the reponse data
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            return .success(decodedData)
        } catch {
            return .failure(.parsingError)
        }
    }
}
