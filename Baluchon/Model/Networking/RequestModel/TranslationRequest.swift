//
//  TranslationRequest.swift
//  Baluchon
//
//  Created by François-Xavier on 23/10/2023.
//

import Foundation

struct TranslationRequest {
    
    let query: String
    let source: String
    let target: String
    let format: String
    
    init(query: String, source: String, target: String, format: String) {
        self.query = query
        self.source = source
        self.target = target
        self.format = format
    }
    
    var value: [String:String] {
        return [
            "key" : APIKey.googleTranslateApiKey,
            "q" : query,
            "source" : source,
            "target" : target,
            "format" : format
        ]
    }
}
