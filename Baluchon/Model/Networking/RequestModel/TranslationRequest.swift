//
//  TranslationRequest.swift
//  Baluchon
//
//  Created by François-Xavier on 23/10/2023.
//

import Foundation

struct TranslationRequest: Encodable {
    
    let key = APIKey.googleTranslateApiKey
    let q: String
    let source: String
    let target: String
    let format: String
    
    init(q: String, source: String, target: String, format: String) {
        self.q = q
        self.source = source
        self.target = target
        self.format = format
    }
    
    var value: [String:String] {
        return [
            "key" : key,
            "q" : q,
            "source" : source,
            "target" : target,
            "format" : format
        ]
    }
}
