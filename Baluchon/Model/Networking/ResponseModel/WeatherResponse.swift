//
//  WeatherResponse.swift
//  Baluchon
//
//  Created by François-Xavier on 29/10/2023.
//

import Foundation

struct WeatherResponse: Codable {
    
    let main: MainWeather
    
    struct MainWeather: Codable {
        let temp: Double
    }
}
