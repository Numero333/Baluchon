//
//  ConverterAPIServiceTest.swift
//  BaluchonTests
//
//  Created by François-Xavier on 23/11/2023.
//

import XCTest
@testable import Baluchon

final class ConverterAPIServiceTest: XCTestCase {
    
    private var session: URLSession!
    private var url: URL!
    
    private var data: Data!
    
    override func setUp() {
        url = URL(string: APIRequest.RequestURL.fixer.value)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLSessionProtocol.self]
        session = URLSession(configuration: configuration)
        
        let bundle = Bundle(for: ConverterAPIServiceTest.self)
        
        let url = bundle.url(forResource: "Converter", withExtension: "json")
        
        data = try! Data(contentsOf: url!)
    }
    
    override func tearDown() {
        session = nil
        url = nil
    }
    
    func testAPIRequestWithCorrectResponse() async {
        
        // Given
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        _ = switch await APIService<ConverterResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil), urlSession: session) {
           
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
        _ = switch await APIService<ConverterResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil), urlSession: session) {
        
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
        _ = switch await APIService<ConverterResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil), urlSession: session) {
            
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
        _ = switch await APIService<ConverterResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil), urlSession: session) {
            
        // Then
        case .success(_):
            XCTAssertNil(true)
        case .failure(let error):
            XCTAssertEqual(APIError.parsingError, error)
        }
    }
}
