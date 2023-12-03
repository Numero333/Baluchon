//
//  WeatherRequest.swift
//  Baluchon
//
//  Created by François-Xavier on 18/11/2023.
//

import Foundation

struct WeatherRequest {
    
    let latitude: String
    let longitude: String
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var value: [String:String] {
        return [
            "appid" : APIKey.openWeatherApikey,
            "lat" : latitude,
            "lon" : longitude,
            "units" : "metric"
        ]
    }
}
