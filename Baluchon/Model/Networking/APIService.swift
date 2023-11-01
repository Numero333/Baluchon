//
//  ApiService.swift
//  Baluchon
//
//  Created by François-Xavier on 21/10/2023.
//

// APIService is a generic utility for making asynchronous HTTP requests and handling responses.
// It supports JSON decoding and provides error handling for various scenarios.

import Foundation

/// Performs an HTTP request and returns the result as a `Result` type.
///
/// - Parameters:
///   - url: The `EndPoint` representing the URL of the API endpoint to be called.
///   - method: The HTTP request method.
///   - parameters: Optional query parameters to include in the request.

struct APIService<T: Codable> {
    
    static func performRequest(apiRequest: APIRequest) async -> Result<T, APIError> {
        
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
            let (data, response) = try await URLSession.shared.data(for: request)
                        
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
