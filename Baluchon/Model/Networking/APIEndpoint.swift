//
//  APIEndpoint.swift
//  Baluchon
//
//  Created by François-Xavier on 23/10/2023.
//

import Foundation

struct APIRequest {
    
    let url: RequestURL
    let method: HTTPMethod
    let parameters: [String:String]?
    
    enum RequestURL {
        case openWeather
        case googleTranslate
        case fixer
                
        var value: String {
            
            switch self {
            case .fixer:
                return BaseUrl.fixer.rawValue + Path.convertRate + APIKey.fixerApiKey
            case .googleTranslate:
                return BaseUrl.google.rawValue + Path.translate + APIKey.googleTranslateApiKey
            case .openWeather:
                return BaseUrl.openWeatherMap.rawValue + Path.weather + "5128638" + "&appid=" + APIKey.openWeatherApikey
            }
        }
    }
}

enum BaseUrl:String {
    case google = "https://translation.googleapis.com"
    case fixer = "http://data.fixer.io"
    case openWeatherMap = "https://api.openweathermap.org"
}

enum Path {
    static let convertRate = "/api/latest?access_key="
    static let translate = "/language/translate/v2?key="
    static let weather = "/data/2.5/weather?id="
}

enum HTTPMethod: String {
    case get = "GET"
}
