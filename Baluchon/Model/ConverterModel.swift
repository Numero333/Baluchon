//
//  ConverterModel.swift
//  Baluchon
//
//  Created by François-Xavier on 23/10/2023.
//

import Foundation
//import UIKit

final class ConverterModel {
    
    //MARK: - Property
    private var rating: ConverterResponse.Currency?
    
    private var currencyChoice = UserDefaults.standard
    
    var fromCurrency: String {
        return currencyChoice.string(forKey: "ToCurrencyChoice") ?? "EUR"
    }
    var toCurrency: String {
        currencyChoice.string(forKey: "FromCurrencyChoice") ?? "USD"
    }
    
    //MARK: - Accesible
    weak var delegate: AppServiceDelegate?
    
    func getConvertion(inputAmount: String) {
        let result = calculateConversion(amount: inputAmount)
        delegate?.didUpdate(result: result)
    }
    
    func handleCurrencySelection(currency: String, index: Int) {
        if index == 0 {
            saveCurrency(value: currency, key: "FromCurrencyChoice")
            print("saved")
        } else {
            saveCurrency(value: currency, key: "ToCurrencyChoice")
        }
    }
    
    //MARK: - Private
    func loadData() async {
        switch await APIService<ConverterResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil)) {
        case .success(let conversion) :
            self.rating = conversion.rates
        case .failure(let error) : delegate?.didFail(error: error)
        }
    }
    
    // Mauvaise gestion de l'erreur
    private func calculateConversion(amount: String) -> String {
        guard let amountDouble = Double(amount) else { return "Error please try again" }
        let result = (amountDouble * mapper(for: fromCurrency) ) /  mapper(for: toCurrency)
        print(amountDouble * mapper(for: fromCurrency))
        print(amountDouble * mapper(for: toCurrency))
        print((amountDouble * mapper(for: fromCurrency) ) / ( mapper(for: toCurrency)))
        return String(result)
    }
    
    private func mapper(for value: String) -> Double {
        guard let unWrappedRates = rating else { return 0.0 }
        
        // Utilisation de la réflexion pour obtenir la propriété correspondante dans unWrappedRates
        if let rate = Mirror(reflecting: unWrappedRates).children.first(where: { $0.label == value })?.value as? Double {
            return rate
        }
        
        return 0.0 // Retourne une valeur par défaut si la devise n'est pas trouvée
    }
    
    private func saveCurrency(value: String, key: String) {
        currencyChoice.set(value, forKey: key)
    }
        
}
