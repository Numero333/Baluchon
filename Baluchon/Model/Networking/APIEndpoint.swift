//
//  APIEndpoint.swift
//  Baluchon
//
//  Created by François-Xavier on 23/10/2023.
//

import Foundation

//struct BaseUrl {
//    static let google = "https://translation.googleapis.com"
//    static let fixer = "http://data.fixer.io"
//    static let openWeatherMap = "https://api.openweathermap.org"
//}

enum HttpMethod: String {
    case get = "GET"
}

enum EndPoint: String {
    
    private static let googleUrl = "https://translation.googleapis.com"
    private static let fixerUrl = "http://data.fixer.io"
    private static let openWeatherMapUrl = "https://api.openweathermap.org"
    
    case openWeather
    case googleTranslate
    case fixer
    
    var value: String {
        
        switch self {
        case .fixer:
            return Self.fixerUrl + "/api/latest?access_key=" + APIKey.fixerApiKey
        case .googleTranslate:
            return Self.googleUrl + "/language/translate/v2?key=" + APIKey.googleTranslateApiKey
        case .openWeather:
            return Self.openWeatherMapUrl + "/data/2.5/weather?id=" + APIKey.openWeatherApikey + "&units=metric"
        }
    }
}
