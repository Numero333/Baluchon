//
//  City.swift
//  Baluchon
//
//  Created by François-Xavier on 18/11/2023.
//

import Foundation

enum City: String, CaseIterable {
    case newYork = "New York"
    case paris = "Paris"
    case tokyo = "Tokyo"
    case sydney = "Sydney"
    case london = "London"
    case rioDeJaneiro = "Rio De Janeiro"
    case cairo = "Cairo"
    case beijing = "Beijing"
    case moscow = "Moscow"
    case capeTown = "Cape Town"
    case mexicoCity = "Mexico"
    case dubai = "Dubaï"
    case rome = "Rome"
    case mumbai = "Mumbai"
    case toronto = "Toronto"
    case buenosAires = "Buenos Aires"
    case seoul = "Seoul"
    case bangkok = "Bangkok"
    case vancouver = "Vancouver"
    
    var coordinates: (latitude: String, longitude: String) {
        switch self {
        case .newYork: return ("40.7128", "-74.0060")
        case .paris: return ("48.8566", "2.3522")
        case .tokyo: return ("35.6895", "139.6917")
        case .sydney: return ("-33.8688", "151.2093")
        case .london: return ("51.5074", "-0.1278")
        case .rioDeJaneiro: return ("-22.9068", "-43.1729")
        case .cairo: return ("30.0444", "31.2357")
        case .beijing: return ("39.9042", "116.4074")
        case .moscow: return ("55.7558", "37.6176")
        case .capeTown: return ("-33.9180", "18.4233")
        case .mexicoCity: return ("19.4326", "-99.1332")
        case .dubai: return ("25.2769", "55.2962")
        case .rome: return ("41.9028", "12.4964")
        case .mumbai: return ("19.0760", "72.8777")
        case .toronto: return ("43.6532", "-79.3832")
        case .buenosAires: return ("-34.6118", "-58.4173")
        case .seoul: return ("37.5665", "126.9780")
        case .bangkok: return ("13.7563", "100.5018")
        case .vancouver: return ("49.2827", "-123.1207")
        }
    }
}
