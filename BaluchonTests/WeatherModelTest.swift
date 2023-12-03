//
//  WeatherModelTest.swift
//  BaluchonTests
//
//  Created by François-Xavier on 03/12/2023.
//

import XCTest
@testable import Baluchon

final class WeatherModelTest: XCTestCase {
    
    private var session: URLSession!
    private var url: URL!
    
    private var data: Data!
    
    private var model: WeatherModel!
    private var delegate: MockWeatherModelDelegate!
    
    override func setUp() {
        url = URL(string: APIRequest.RequestURL.openWeather.value)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLSessionProtocol.self]
        session = URLSession(configuration: configuration)
        
        let bundle = Bundle(for: WeatherModelTest.self)
        
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        
        data = try! Data(contentsOf: url!)
        
        model = WeatherModel()
    }
    
    override func tearDown() {
        session = nil
        url = nil
    }
    
    func testHandleCitySelectionWithInputValue() async {
        
        // Given
        model.handleCitySelection(city: .paris, index: 0, row: 0)
        model.handleCitySelection(city: .newYork, index: 1, row: 2)
        
        // Then
        XCTAssertEqual(model.FromCityLat, City.paris.coordinates.latitude)
        XCTAssertEqual(model.FromCityLon, City.paris.coordinates.longitude)
        XCTAssertEqual(model.fromCityRow, 0)
        
        XCTAssertEqual(model.ToCityLat, City.newYork.coordinates.latitude)
        XCTAssertEqual(model.ToCityLon, City.newYork.coordinates.longitude)
        XCTAssertEqual(model.toCityRow, 2)
    }
    
    func testAPIRequestWithCorrectResponse() async {
        
        // Given
        FakeURLSessionProtocol.loadingData = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, self.data)
        }
        
        // When
        _ = switch await APIService<WeatherResponse>.performRequest(apiRequest: APIRequest(url: .openWeather, method: .get, parameters: nil), urlSession: session) {
           
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
        _ = switch await APIService<WeatherResponse>.performRequest(apiRequest: APIRequest(url: .openWeather, method: .get, parameters: nil), urlSession: session) {
        
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
        _ = switch await APIService<WeatherResponse>.performRequest(apiRequest: APIRequest(url: .openWeather, method: .get, parameters: nil), urlSession: session) {
            
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
        _ = switch await APIService<WeatherResponse>.performRequest(apiRequest: APIRequest(url: .openWeather, method: .get, parameters: WeatherRequest(latitude: City.paris.coordinates.latitude, longitude: City.newYork.coordinates.longitude).value), urlSession: session) {
            
        // Then
        case .success(_):
            XCTAssertNil(true)
        case .failure(let error):
            XCTAssertEqual(APIError.parsingError, error)
        }
    }
}

// Utilité ??
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
