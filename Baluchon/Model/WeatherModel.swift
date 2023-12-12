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
    
    var apiService = APIService<WeatherResponse>()
    
    var fromCityLat: String {
        get {
            cityChoice.string(forKey: "FromCityLat") ?? "0.0"
        }
        set {
            cityChoice.set(newValue, forKey: "FromCityLat")
        }
        
    }
    
    var fromCityLon: String {
        get {
            cityChoice.string(forKey: "FromCityLon") ?? "0.0"
        }
        set {
            cityChoice.set(newValue, forKey: "FromCityLon")
        }
        
    }
    
    var fromCityRow: Int {
        get {
            cityChoice.integer(forKey: "FromCityRow")
        }
        set {
            cityChoice.set(newValue, forKey: "FromCityRow")
        }
        
    }
    
    var toCityLat: String {
        get {
            cityChoice.string(forKey: "ToCityLat") ?? "0.0"
        }
        set {
            cityChoice.set(newValue, forKey: "ToCityLat")
        }
        
    }
    
    var toCityLon: String {
        get {
            cityChoice.string(forKey: "ToCityLon") ?? "0.0"
        }
        set {
            cityChoice.set(newValue, forKey: "ToCityLon")
        }
        
    }
    
    var toCityRow: Int {
        get {
            cityChoice.integer(forKey: "ToCityRow")
        }
        set {
            cityChoice.set(newValue, forKey: "ToCityRow")
        }
        
    }
    
    //MARK: - Accesible
    weak var delegate: WeatherModelDelegate?
    
    func handleCitySelection(city: City, index: Int, row: Int) {
        if index == 0 {
            fromCityLat = city.coordinates.latitude
            fromCityLon = city.coordinates.longitude
            fromCityRow = row
        } else {
            toCityLat = city.coordinates.latitude
            toCityLon = city.coordinates.longitude
            toCityRow = row
        }
    }
    
    func onViewDidLoad() {
        Task {
            await loadData()
        }
    }
    
    func refresh() {
        Task {
            await loadData()
        }
    }
    
    //MARK: - Private
    private func loadData() async {
        
        switch await apiService.performRequest(apiRequest: APIRequest(url: .openWeather, method: .get, parameters: WeatherRequest(latitude: fromCityLat, longitude: fromCityLon).value)){
        case .success(let weather):
            delegate?.didUpdateLocalTemperature(result: weather.main.temp.description)
            delegate?.didUpdateLocalInfo(result: weather.weather[0].description.capitalizingFirstLetter())
        case .failure(let error):
            delegate?.didFail(error: error)
        }
        
        
        switch await apiService.performRequest(apiRequest: APIRequest(url: .openWeather, method: .get, parameters: WeatherRequest(latitude: toCityLat, longitude: toCityLon).value)){
        case .success(let weather):
            delegate?.didUpdateDistantTemperature(result: weather.main.temp.description)
            delegate?.didUpdateDistantInfo(result: weather.weather[0].description.capitalizingFirstLetter())
        case .failure(let error):
            delegate?.didFail(error: error)
        }
    }
}
