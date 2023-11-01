//
//  TranslateResponse.swift
//  Baluchon
//
//  Created by François-Xavier on 29/10/2023.
//

import Foundation

struct TranslationResponse: Codable {
    let data: TranslationData
}

struct TranslationData: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
}
