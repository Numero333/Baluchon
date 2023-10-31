//
//  ConverterResponse.swift
//  Baluchon
//
//  Created by François-Xavier on 29/10/2023.
//

import Foundation

struct ConverterResponse: Codable {
    
    let rates: Currency
    
    struct Currency: Codable {
        let USD: Double
    }
}
