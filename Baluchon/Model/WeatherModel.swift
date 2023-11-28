//
//  WeatherModel.swift
//  Baluchon
//
//  Created by François-Xavier on 22/10/2023.
//

import Foundation

protocol WeatherModelDelegate: AnyObject {
    func didFail(error: APIError)
    func didUpdateLocalTemperature(result: String)
    func didUpdateLocalInfo(result: String)
    func didUpdateDistantTemperature(result: String)
    func didUpdateDistantInfo(result: String)
}

final class WeatherModel {
    
    //MARK: - Property
    private var cityChoice = UserDefaults.standard
    
    var FromCityLat: String {
        cityChoice.string(forKey: "FromCityLat") ?? "0.0"
    }
    
    var FromCityLon: String {
        cityChoice.string(forKey: "FromCityLon") ?? "0.0"
    }
    
    var fromCityRow: Int {
        cityChoice.integer(forKey: "FromCityRow")
    }
    
    var ToCityLat: String {
        cityChoice.string(forKey: "ToCityLat") ?? "0.0"
    }
    
    var ToCityLon: String {
        cityChoice.string(forKey: "ToCityLon") ?? "0.0"
    }
    
    var toCityRow: Int {
        cityChoice.integer(forKey: "ToCityRow")
    }
    
    //MARK: - Accesible
    weak var delegate: WeatherModelDelegate?
        
    func loadData() {
        Task {
            switch await APIService<WeatherResponse>.performRequest(apiRequest: APIRequest(url: .openWeather, method: .get, parameters: WeatherRequest(latitude: FromCityLat, longitude: FromCityLon).value)){
            case .success(let weather):
                delegate?.didUpdateLocalTemperature(result: weather.main.temp.description)
                delegate?.didUpdateLocalInfo(result: weather.weather[0].description)
            case .failure(let error):
                delegate?.didFail(error: error)
            }
        }
        
        Task {
            switch await APIService<WeatherResponse>.performRequest(apiRequest: APIRequest(url: .openWeather, method: .get, parameters: WeatherRequest(latitude: ToCityLat, longitude: ToCityLon).value)){
            case .success(let weather):
                delegate?.didUpdateDistantTemperature(result: weather.main.temp.description)
                delegate?.didUpdateDistantInfo(result: weather.weather[0].description)
            case .failure(let error):
                delegate?.didFail(error: error)
            }
        }
    }
    
    func handleCitySelection(city: City, index: Int, row: Int) {
        if index == 0 {
            saveCity(value: city.coordinates.latitude, key: "FromCityLat")
            saveCity(value: city.coordinates.longitude, key: "FromCityLon")
            cityChoice.set(row, forKey: "FromCityRow")
        } else {
            saveCity(value: city.coordinates.latitude, key: "ToCityLat")
            saveCity(value: city.coordinates.longitude, key: "ToCityLon")
            cityChoice.set(row, forKey: "ToCityRow")
        }
    }
        
    //MARK: - Private
    private func saveCity(value: String, key: String) {
        cityChoice.set(value, forKey: key)
    }
}

