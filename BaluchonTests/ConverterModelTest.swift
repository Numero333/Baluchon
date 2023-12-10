//
//  ConverterModelTest.swift
//  BaluchonTests
//
//  Created by François-Xavier on 03/12/2023.
//

import XCTest
@testable import Baluchon

final class ConverterModelTest: XCTestCase {
    
    private var session: URLSession! = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLSessionProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    private var data: Data! = {
        let bundle = Bundle(for: ConverterModelTest.self)
        let url = bundle.url(forResource: "Converter", withExtension: "json")
        return try! Data(contentsOf: url!)
    }()
    
    private var url: URL! =  URL(string: APIRequest.RequestURL.fixer.value)
    
    private var model: ConverterModel = ConverterModel()
    private var delegate: MockConverterDelegate = MockConverterDelegate()
    
    override func setUp() {
        model.apiService = APIService<ConverterResponse>(urlSession: session)
        model.delegate = delegate
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
        await model.loadData()
        model.getConvertion(inputAmount: "15")
        
        // Then
        XCTAssertEqual(delegate.result, "7,5")
        
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
       await model.loadData()
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
        XCTAssertEqual(delegate.result, "NaN")
    }
    
    func testMapperIncorrectValue() async {
        // Given
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        await model.loadData()
        model.fromCurrency = "XXX"
        model.toCurrency = "XXX"
        model.getConvertion(inputAmount: "15")
        
        // Then
        XCTAssertEqual(delegate.result, "NaN")
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
