//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by François-Xavier on 20/10/2023.
//

import UIKit

class WeatherViewController: UIViewController, AppServiceDelegate {
    
    @IBOutlet weak var localWeatherLabel: UILabel!
    @IBOutlet weak var remoteWeatherLabel: UILabel!
    
    var model = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
        view.linearGradientBackground()
    }
    
    func didFail(error: APIError) {
        Alert.display(vc: self, message: error.description)
    }
    
    func didUpdate(result: String) {
        Task.detached {
            DispatchQueue.main.async {
                self.remoteWeatherLabel.text = " ok"
                self.localWeatherLabel.text = "ok"
            }
        }
    }
}
