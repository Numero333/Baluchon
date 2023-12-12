//
//  ConverterModel.swift
//  Baluchon
//
//  Created by François-Xavier on 23/10/2023.
//

import Foundation

protocol ConverterModelDelegate: AnyObject {
    func didFail(error: APIError)
    func didUpdate(result: String)
}

final class ConverterModel {
    
    //MARK: - Property
    private var currencyChoice = UserDefaults.standard
    
    var apiService = APIService<ConverterResponse>()
    
    var rating: ConverterResponse.Currency?
    
    var fromCurrency: String {
        get {
            currencyChoice.string(forKey: "FromCurrencyChoice") ?? "EUR"
        }
        set {
            currencyChoice.set(newValue, forKey: "FromCurrencyChoice")
        }
    }
    
    var toCurrency: String {
        get {
            currencyChoice.string(forKey: "ToCurrencyChoice") ?? "USD"
        }
        set {
            currencyChoice.set(newValue, forKey: "ToCurrencyChoice")
        }
    }
    
    //MARK: - Accesible
    weak var delegate: ConverterModelDelegate?
    
    func getConvertion(inputAmount: String) {
        let result = calculateConversion(value: inputAmount)
        delegate?.didUpdate(result: result)
    }
    
    func handleCurrencySelection(currency: String, index: Int) {
        if index == 0 {
            fromCurrency = currency
        } else {
            toCurrency = currency
        }
    }
    
    func onViewDidLoad() {
        Task {
            await loadData()
        }
    }
    
    //MARK: - Private
    private func loadData() async {
        switch await apiService.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil)) {
        case .success(let conversion) :
            self.rating = conversion.rates
        case .failure(let error) : delegate?.didFail(error: error)
        }
    }
    
    private func calculateConversion(value: String) -> String {
        let amount = value.replacingOccurrences(of: ",", with: ".")
        guard let amountDouble = Double(amount) else { return "Error please try again" }
        let result = (amountDouble * mapper(for: fromCurrency) ) / mapper(for: toCurrency)
        return formatDecimal(for: result)
    }
    
    private func formatDecimal(for result: Double) -> String {
        let formattedResult = round(result * 100) / 100
        return String(describing: formattedResult)
    }
    
    private func mapper(for value: String) -> Double {
        guard let unWrappedRates = rating else { return 0.0 }
        
        if let rate = Mirror(reflecting: unWrappedRates).children.first(where: { $0.label == value })?.value as? Double {
            return rate
        }
        
        return 0.0
    }
}
