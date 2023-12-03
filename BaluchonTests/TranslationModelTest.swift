//
//  TranslationModelTest.swift
//  BaluchonTests
//
//  Created by François-Xavier on 03/12/2023.
//

import XCTest
@testable import Baluchon

final class TranslationModelTest: XCTestCase {
    
    
    private var session: URLSession!
    private var url: URL!
    
    private var data: Data!
    
    private var model: TranslationModel!
    private var delegate: MockAppServiceDelegate!
    
    override func setUp() {
        url = URL(string: APIRequest.RequestURL.googleTranslate.value)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLSessionProtocol.self]
        session = URLSession(configuration: configuration)
        
        let bundle = Bundle(for: TranslationModelTest.self)
        
        let url = bundle.url(forResource: "Translate", withExtension: "json")
        
        data = try! Data(contentsOf: url!)
        
        model = TranslationModel()
        delegate = MockAppServiceDelegate()
    }
    
    override func tearDown() {
        session = nil
        url = nil
    }
    
    func testHandleLanguageSelection() async {
            
        // Given
        model.handleLanguageSelection(language: .french, index: 0)
        model.handleLanguageSelection(language: .english, index: 1)
        
        //Then
        XCTAssertEqual(model.translateFrom, "french")
        XCTAssertEqual(model.translateTo, "english")
    }
    
    func testAPIRequestWithCorrectResponse() async {
        
        // Given
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        _ = switch await APIService<TranslationResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: TranslationRequest(query: "Bonjour", source: "fr", target: "en", format: "text").value), urlSession: session) {
            
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
        _ = switch await APIService<TranslationResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: TranslationRequest(query: "Bonjour", source: "fr", target: "en", format: "text").value), urlSession: session) {
            
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
        _ = switch await APIService<TranslationResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: TranslationRequest(query: "Bonjour", source: "fr", target: "en", format: "text").value), urlSession: session) {
            
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
        _ = switch await APIService<TranslationResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: TranslationRequest(query: "Bonjour", source: "fr", target: "en", format: "text").value), urlSession: session) {
            
            // Then
        case .success(_):
            XCTAssertNil(true)
        case .failure(let error):
            XCTAssertEqual(APIError.parsingError, error)
        }
    }
}

private class MockAppServiceDelegate: AppServiceDelegate {
    
    var result: String?
    var error: APIError?
    
    func didFail(error: APIError) {
        self.error = error
    }
    
    func didUpdate(result: String) {
        self.result = result
    }
}
