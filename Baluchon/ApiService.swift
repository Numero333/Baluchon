//
//  ApiService.swift
//  Baluchon
//
//  Created by François-Xavier on 21/10/2023.
//

import Foundation

final class ApiService<T: Codable> {
    
    var url: String
    var parameters : [String]?
    var method: ApiMethod?
    
    init(url: String, parameters: [String]? = nil, method: ApiMethod? = nil) {
        self.url = url
        self.parameters = parameters
        self.method = method
    }
    
    enum ApiMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum ApiError {
        
        case invalidUrl
        case noData
        case notDecodableData
        case unAuthorized
        case unknow
    }
    
    static func performGetRequest(url: String) async throws {
        
        guard let url = URL(string: url) else {
            ApiError.invalidUrl
            return
        }
        
        do {
            
            var urlRequest = URLRequest(url: url)
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error while fetching weather data")
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
        } catch {
            print("error")
        }
    }
    
    static func performPostRequest() {
        
        let urlString = ""
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let parameters = ""
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer API_KEY", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                ApiError.noData
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(T.self, from: data)
            } catch {
                ApiError.notDecodableData
            }
        }
        task.resume()
    }
    
}
