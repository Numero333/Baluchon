//
//  WeatherModelTest.swift
//  BaluchonTests
//
//  Created by François-Xavier on 03/12/2023.
//

import XCTest
@testable import Baluchon

final class WeatherModelTest: XCTestCase {
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLSessionProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    private let data: Data = {
        let bundle = Bundle(for: WeatherModelTest.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        return try! Data(contentsOf: url!)
    }()
    
    private let url: URL =  URL(string: APIRequest.RequestURL.openWeather.value)!
    private let model: WeatherModel = WeatherModel()
    private let  delegate: MockWeatherModelDelegate = MockWeatherModelDelegate()
    
    override func setUp() {
        model.apiService = APIService<WeatherResponse>(urlSession: session)
        model.delegate = delegate
    }
    
    func testHandleCitySelectionWithInputValue() {
        
        // Given
        model.handleCitySelection(city: .paris, index: 0, row: 0)
        model.handleCitySelection(city: .newYork, index: 1, row: 2)
        
        // Then
        XCTAssertEqual(model.fromCityLat, City.paris.coordinates.latitude)
        XCTAssertEqual(model.fromCityLon, City.paris.coordinates.longitude)
        XCTAssertEqual(model.fromCityRow, 0)
        
        XCTAssertEqual(model.toCityLat, City.newYork.coordinates.latitude)
        XCTAssertEqual(model.toCityLon, City.newYork.coordinates.longitude)
        XCTAssertEqual(model.toCityRow, 2)
    }
    
    func testHandleCitySelectionFromCityDefaultValue() {
        
        // Given
        UserDefaults.standard.removeObject(forKey: "FromCityLat")
        UserDefaults.standard.removeObject(forKey: "FromCityLon")
        
        // Then
        XCTAssertEqual(model.fromCityLat, "0.0")
        XCTAssertEqual(model.fromCityLon, "0.0")
    }
    
    func testHandleCitySelectionToCityDefaultValue() {
        
        // Given
        UserDefaults.standard.removeObject(forKey: "ToCityLat")
        UserDefaults.standard.removeObject(forKey: "ToCityLon")
        
        // Then
        XCTAssertEqual(model.toCityLat, "0.0")
        XCTAssertEqual(model.toCityLon, "0.0")
    }
    
    func testRefreshWithCorrectInput() {
        
        // Given
        model.handleCitySelection(city: .paris, index: 0, row: 0)
        model.handleCitySelection(city: .newYork, index: 1, row: 2)
        
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // when
        
        model.onRefresh()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.delegate.resultLocalTemperature, "10.0")
        }
    }
    
    func testRefreshWithUncorrectResponse() {
        
        // Given
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 500, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // when
        model.onRefresh()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.delegate.error)
        }
    }
    
    func testOnViewDidLoadWithCorrectInput() {
        
        // Given
        model.handleCitySelection(city: .paris, index: 0, row: 0)
        model.handleCitySelection(city: .newYork, index: 1, row: 2)
        
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // when
        model.onViewDidLoad()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.delegate.resultLocalTemperature, "10.0")
        }
    }
}

class MockWeatherModelDelegate: WeatherModelDelegate {
    
    var resultLocalTemperature: String?
    var resultLocalInfo: String?
    var resultDistantTemperature: String?
    var resultDistantInfo: String?
    
    var error: APIError?
    
    func didFail(error: APIError) {
        self.error = error
    }
    
    func didUpdateLocalTemperature(result: String) {
        self.resultLocalTemperature = result
    }
    
    func didUpdateLocalInfo(result: String) {
        self.resultLocalInfo = result
    }
    
    func didUpdateDistantTemperature(result: String) {
        self.resultDistantTemperature = result
    }
    
    func didUpdateDistantInfo(result: String) {
        self.resultDistantInfo = result
    }
}
