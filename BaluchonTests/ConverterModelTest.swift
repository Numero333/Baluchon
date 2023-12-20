//
//  ConverterModelTest.swift
//  BaluchonTests
//
//  Created by François-Xavier on 03/12/2023.
//

import XCTest
@testable import Baluchon

final class ConverterModelTest: XCTestCase {
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLSessionProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    private let data: Data = {
        let bundle = Bundle(for: ConverterModelTest.self)
        let url = bundle.url(forResource: "Converter", withExtension: "json")
        return try! Data(contentsOf: url!)
    }()
    
    private let url: URL = URL(string: APIRequest.RequestURL.fixer.value)!
    
    private let model: ConverterModel = ConverterModel()
    private let delegate: MockConverterDelegate = MockConverterDelegate()
    
    override func setUp() {
        model.apiService = APIService<ConverterResponse>(urlSession: session)
        model.delegate = delegate
    }
    
    func testGetConversionWithCorrectAmount() {
        
        // Given
        model.handleCurrencySelection(currency: "EUR", index: 0)
        model.handleCurrencySelection(currency: "USD", index: 1)
        
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        model.onViewDidLoad()
        model.getConvertion(inputAmount: "15")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.delegate.result, "7,5")
        }
        
    }

    func testGetConversionWithIncorrectAmount() {
        
        // Given
        model.handleCurrencySelection(currency: "EUR", index: 0)
        model.handleCurrencySelection(currency: "USD", index: 1)
        
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        model.onViewDidLoad()
        model.getConvertion(inputAmount: "ABC")

            
        // Then
        XCTAssertEqual(delegate.result, "Error please try again")
        
    }
    
    func testTranslateFromDefaultValue() {
        // Given
        UserDefaults.standard.removeObject(forKey: "FromCurrencyChoice")

        // Then
        XCTAssertEqual(model.fromCurrency, "EUR")
    }

    func testTranslateToDefaultValue() {
        // Given
        UserDefaults.standard.removeObject(forKey: "ToCurrencyChoice")

        // Then
        XCTAssertEqual(model.toCurrency, "USD")
    }
    
    func testHandleCurrencySelection() {
        
        // Given
        model.handleCurrencySelection(currency: "EUR", index: 0)
        model.handleCurrencySelection(currency: "USD", index: 1)
        
        // Then
        XCTAssertEqual(model.fromCurrency, "EUR")
        XCTAssertEqual(model.toCurrency, "USD")
    }
    
    func testRatingNil() {
        // Given
        model.rating = nil
        
        // When
        model.getConvertion(inputAmount: "15")
        
        // Then
        XCTAssertEqual(delegate.result, "nan")
    }
    
    func testMapperIncorrectValue() {
        // Given
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        model.onViewDidLoad()
        model.fromCurrency = "XXX"
        model.toCurrency = "XXX"
        model.getConvertion(inputAmount: "15")
        
        // Then
        XCTAssertEqual(delegate.result, "nan")
    }
}

private class MockConverterDelegate: ConverterModelDelegate {
    
    var result: String?
    var error: APIError?
    
    func didFail(error: APIError) {
        self.error = error
    }
    
    func didUpdate(result: String) {
        self.result = result
    }
}
