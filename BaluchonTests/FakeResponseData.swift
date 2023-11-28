//
//  FakeResponseData.swift
//  BaluchonTests
//
//  Created by François-Xavier on 23/11/2023.
//

import Foundation

class FakeResponseData {
    static let reponseOk = HTTPURLResponse(url: URL(string: "")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    static let responseKO = HTTPURLResponse(url: URL(string: "")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    class ApiError: Error {}
    static let error = ApiError()
    
    static var apiCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Converter", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let ApiIncorrect = "erreur".data(using: .utf8)!
    
    static let data = "some data".data(using: .utf8)!
}
