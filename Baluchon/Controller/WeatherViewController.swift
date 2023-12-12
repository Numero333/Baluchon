//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by François-Xavier on 20/10/2023.
//

import UIKit

final class WeatherViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, WeatherModelDelegate {

    //MARK: - Property
    @IBOutlet weak var localTemperatureLabel: UILabel!
    @IBOutlet weak var localInfoLabel: UILabel!
    @IBOutlet weak var distantTemperatureLabel: UILabel!
    @IBOutlet weak var distantInfoLabel: UILabel!
    @IBOutlet weak var localPicker: UIPickerView!
    @IBOutlet weak var distantPicker: UIPickerView!
    let model = WeatherModel()
        
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        configureLocalPicker()
        configureDistantPicker()
        view.linearGradientBackground()
        model.onViewDidLoad()
    }
    
    //MARK: - AppServiceDelegate
    func didFail(error: APIError) {
        DispatchQueue.main.async {
            Alert.display(vc: self, message: error.description)
        }
    }
    
    func didUpdateLocalTemperature(result: String) {
        DispatchQueue.main.async {
            self.localTemperatureLabel.text = result
        }
    }
    
    func didUpdateLocalInfo(result: String) {
        DispatchQueue.main.async {
            self.localInfoLabel.text = result
        }
    }
    
    func didUpdateDistantTemperature(result: String) {
        DispatchQueue.main.async {
            self.distantTemperatureLabel.text = result
        }
    }
    
    func didUpdateDistantInfo(result: String) {
        DispatchQueue.main.async {
            self.distantInfoLabel.text = result
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        model.onRefresh()
    }
    
    //MARK: - UIPickerDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return City.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let city = City.allCases[row]
        return city.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = City.allCases[row]
        switch pickerView.tag {
        case 1 : self.model.handleCitySelection(city: selected, index: 1, row: row)
        default: self.model.handleCitySelection(city: selected, index: 0, row: row)
        }
    }
    
    //MARK: - Private
    private func configureLocalPicker() {
        localPicker.delegate = self
        localPicker.dataSource = self
        localPicker.tag = 0
        localPicker.selectRow(self.model.fromCityRow, inComponent: 0, animated: false)
    }
    
    private func configureDistantPicker() {
        distantPicker.delegate = self
        distantPicker.dataSource = self
        distantPicker.tag = 1
        distantPicker.selectRow(self.model.toCityRow, inComponent: 0, animated: false)
    }
}
