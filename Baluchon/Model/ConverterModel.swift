//
//  ConverterModel.swift
//  Baluchon
//
//  Created by François-Xavier on 23/10/2023.
//

import Foundation

final class ConverterModel {
    
    //MARK: - Property
    var rating: ConverterResponse.Currency?
    
    private var currencyChoice = UserDefaults.standard
    
    var fromCurrency: String {
        return currencyChoice.string(forKey: "FromCurrencyChoice") ?? "EUR"
    }
    var toCurrency: String {
        currencyChoice.string(forKey: "ToCurrencyChoice") ?? "USD"
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
        } else {
            saveCurrency(value: currency, key: "ToCurrencyChoice")
        }
    }
    
    func loadData() async {
        switch await APIService<ConverterResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil)) {
        case .success(let conversion) :
            self.rating = conversion.rates
        case .failure(let error) : delegate?.didFail(error: error)
        }
    }
    
    //MARK: - Private
    private func calculateConversion(amount: String) -> String {
        guard let amountDouble = Double(amount) else { return "Error please try again" }
        let result = (amountDouble * mapper(for: fromCurrency) ) / mapper(for: toCurrency)
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
