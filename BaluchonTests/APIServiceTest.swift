//
//  APIServiceTest.swift
//  BaluchonTests
//
//  Created by François-Xavier on 10/12/2023.
//

import XCTest
@testable import Baluchon

final class APIServiceTest: XCTestCase {
    
    private var session: URLSession! = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLSessionProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    private var data: Data! = {
        let bundle = Bundle(for: WeatherModelTest.self)
        let url = bundle.url(forResource: "Translate", withExtension: "json")
        return try! Data(contentsOf: url!)
    }()
    
    private var url: URL! =  URL(string: APIRequest.RequestURL.googleTranslate.value)
    
    func testAPIRequestWithCorrectResponse() async {
        
        // Given
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        switch await APIService<TranslationResponse>(urlSession: session).performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: TranslationRequest(query: "Bonjour", source: "fr", target: "en", format: "text").value)) {
            
            // Then
        case .success(_):
            XCTAssertTrue(true)
        case .failure(_):
            XCTAssertNil(true)
        }
    }
    
    func testAPIRequestWithUncorrectResponse() async {
        
        // Given
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 500, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        switch await APIService<TranslationResponse>(urlSession: session).performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: TranslationRequest(query: "Bonjour", source: "fr", target: "en", format: "text").value)) {
            
            // Then
        case .success(_):
            XCTAssertNil(true)
        case .failure(let error):
            XCTAssertEqual(APIError.invalidResponse(500), error)
        }
    }
    
    func testAPIRequestWithCorrectData() async {
        
        // Given
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        switch await APIService<TranslationResponse>(urlSession: session).performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: TranslationRequest(query: "Bonjour", source: "fr", target: "en", format: "text").value)) {
            
            // Then
        case .success(_):
            XCTAssertTrue(true)
        case .failure(_):
            XCTAssertNil(true)
        }
    }
    
    func testAPIRequestWithUncorrectData() async {
        
        // Given
        data = "fake data".data(using: .utf8)
        
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        switch await APIService<TranslationResponse>(urlSession: session).performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: TranslationRequest(query: "Bonjour", source: "fr", target: "en", format: "text").value)) {
            
            // Then
        case .success(_):
            XCTAssertNil(true)
        case .failure(let error):
            XCTAssertEqual(APIError.parsingError, error)
        }
    }
}
