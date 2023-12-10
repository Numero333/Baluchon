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
    
    // MARK: - Initialization
    init() {
        Task {
            await self.loadData()
        }
    }
    
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
        let result = calculateConversion(amount: inputAmount)
        delegate?.didUpdate(result: result)
    }
    
    func handleCurrencySelection(currency: String, index: Int) {
        if index == 0 {
            fromCurrency = currency
        } else {
            toCurrency = currency
        }
    }
    
    func loadData() async {
            switch await apiService.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil)) {
            case .success(let conversion) :
                self.rating = conversion.rates
            case .failure(let error) : delegate?.didFail(error: error)
            }
        
    }
    
    //MARK: - Private
    private func calculateConversion(amount: String) -> String {
        guard let amountDouble = Double(amount) else { return "Error please try again" }
        let result = (amountDouble * mapper(for: fromCurrency) ) / mapper(for: toCurrency)
        return formatDecimal(for: result)
    }
    
    private func formatDecimal(for result: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        
        return formatter.string(for: result)!
    }
    
    private func mapper(for value: String) -> Double {
        guard let unWrappedRates = rating else { return 0.0 }
        
        if let rate = Mirror(reflecting: unWrappedRates).children.first(where: { $0.label == value })?.value as? Double {
            return rate
        }
        
        return 0.0
    }
}
