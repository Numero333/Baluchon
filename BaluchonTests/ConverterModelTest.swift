//
//  ConverterModelTest.swift
//  BaluchonTests
//
//  Created by François-Xavier on 03/12/2023.
//

import XCTest
@testable import Baluchon

final class ConverterModelTest: XCTestCase {
    
    private var session: URLSession!
    private var url: URL!
    
    private var data: Data!
    
    private var model: ConverterModel!
    private var delegate: MockAppServiceDelegate!
    
    override func setUp() {
        url = URL(string: APIRequest.RequestURL.fixer.value)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLSessionProtocol.self]
        session = URLSession(configuration: configuration)
        
        let bundle = Bundle(for: ConverterModelTest.self)
        
        let url = bundle.url(forResource: "Converter", withExtension: "json")
        
        data = try! Data(contentsOf: url!)
        
        model = ConverterModel()
        delegate = MockAppServiceDelegate()
        model.delegate = delegate
    }
    
    override func tearDown() {
        session = nil
        url = nil
    }
    
    func testHandleCurrencySelection() async {
        
        // Given
        model.handleCurrencySelection(currency: "EUR", index: 0)
        model.handleCurrencySelection(currency: "USD", index: 1)
        
        // Then
        XCTAssertEqual(model.fromCurrency, "EUR")
        XCTAssertEqual(model.toCurrency, "USD")
    }
    
    func testGetConversionWithCorrectAmount() async {
        
        // Given
        model.handleCurrencySelection(currency: "EUR", index: 0)
        model.handleCurrencySelection(currency: "USD", index: 1)
        
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        _ = switch await APIService<ConverterResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil), urlSession: session) {
            
        // Then
        case .success(let data):
            self.model.rating = data.rates
        case .failure(_):
            XCTAssertNil(true)
        }
        
        model.getConvertion(inputAmount: "15")
        XCTAssertEqual(delegate.result, "7.5")
        
    }

    func testGetConversionWithIncorrectAmount() async {
        
        // Given
        model.handleCurrencySelection(currency: "EUR", index: 0)
        model.handleCurrencySelection(currency: "USD", index: 1)
        
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        _ = switch await APIService<ConverterResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil), urlSession: session) {
            
        // Then
        case .success(let data):
            self.model.rating = data.rates
        case .failure(_):
            XCTAssertNil(true)
        }
        
        model.getConvertion(inputAmount: "ABC")
        XCTAssertEqual(delegate.result, "Error please try again")
        
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
