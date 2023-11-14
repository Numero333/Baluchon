//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by François-Xavier on 20/10/2023.
//

import UIKit

final class WeatherViewController: UIViewController, AppServiceDelegate {

    //MARK: - Property
    @IBOutlet private var localWeatherTextView: UITextView!
    
    let model = WeatherModel()
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        Task {
            await model.getWeather()
        }
        view.linearGradientBackground()
    }
    
    //MARK: - AppServiceDelegate
    func didFail(error: APIError) {
        DispatchQueue.main.async {
            Alert.display(vc: self, message: error.description)
        }
    }
    
    func didUpdate(result: String) {
        DispatchQueue.main.async {
            self.localWeatherTextView.text = result
        }
    }
}
