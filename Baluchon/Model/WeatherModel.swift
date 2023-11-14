//
//  WeatherModel.swift
//  Baluchon
//
//  Created by François-Xavier on 22/10/2023.
//

import Foundation

final class WeatherModel {
    
    //MARK: - Accesible
    weak var delegate: AppServiceDelegate?
    
    func getWeather() async {
        Task {
            switch await APIService<WeatherResponse>.performRequest(apiRequest: APIRequest(url: .openWeather, method: .get, parameters: nil)){
            case .success(let weather):
                delegate?.didUpdate(result: weather.main.temp.description)
            case .failure(let error):
                delegate?.didFail(error: error)
            }
        }
    }
}

