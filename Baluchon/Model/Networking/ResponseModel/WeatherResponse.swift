//
//  WeatherResponse.swift
//  Baluchon
//
//  Created by François-Xavier on 29/10/2023.
//

import Foundation

struct WeatherResponse: Codable {
    
    let main: MainWeather
    
    let weather: [Weather]
    
    struct Weather: Codable {
        let description: String
    }
    
    struct MainWeather: Codable {
        let temp: Double
    }
}
