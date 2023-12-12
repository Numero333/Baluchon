//
//  TranslationModelTest.swift
//  BaluchonTests
//
//  Created by François-Xavier on 03/12/2023.
//

import XCTest
@testable import Baluchon

final class TranslationModelTest: XCTestCase {
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLSessionProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    private let data: Data = {
        let bundle = Bundle(for: WeatherModelTest.self)
        let url = bundle.url(forResource: "Translate", withExtension: "json")
        return try! Data(contentsOf: url!)
    }()
    
    private let url: URL =  URL(string: APIRequest.RequestURL.googleTranslate.value)!
    private let model: TranslationModel = TranslationModel()
    private let delegate: MockTranslationModelDelegate = MockTranslationModelDelegate()
    
    override func setUp() {
        model.apiService = APIService<TranslationResponse>(urlSession: session)
        model.delegate = delegate
    }
    
    func testHandleLanguageSelection() {
        
        // Given
        model.handleLanguageSelection(language: .french, index: 0)
        model.handleLanguageSelection(language: .english, index: 1)
        
        //Then
        XCTAssertEqual(model.translateFrom, "french")
        XCTAssertEqual(model.translateTo, "english")
    }
    
    func testRefresh() {
        
        // Given
        model.handleLanguageSelection(language: .french, index: 0)
        model.handleLanguageSelection(language: .english, index: 1)
        
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        model.refresh(text: "bonjour")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.delegate.result, "Good morning")
        }
    }
    
    func testTranslateFromDefaultValue() {
        // Given
        UserDefaults.standard.removeObject(forKey: "TranslateFrom")
        
        // Then
        XCTAssertEqual(model.translateFrom, "french")
    }
    
    func testTranslateToDefaultValue() {
        // Given
        UserDefaults.standard.removeObject(forKey: "TranslateTo")
        
        // Then
        XCTAssertEqual(model.translateTo, "english")
    }
    
    func testTranslateFromAPIDefaultValue() {
        // Given
        UserDefaults.standard.removeObject(forKey: "TranslateFromApi")
        
        // Then
        XCTAssertEqual(model.translateFromAPI, "fr")
    }
    
    func testTranslateToAPIDefaultValue() {
        // Given
        UserDefaults.standard.removeObject(forKey: "TranslateToApi")
        
        // Then
        XCTAssertEqual(model.translateToAPI, "en")
    }
}

private class MockTranslationModelDelegate: TranslationModelDelegate {
    
    var result: String?
    var error: APIError?

    func didFail(error: APIError) {
        self.error = error
    }
    
    func didUpdate(result: String) {
        self.result = result
    }
}
