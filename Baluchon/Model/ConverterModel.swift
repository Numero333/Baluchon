//
//  ConverterModel.swift
//  Baluchon
//
//  Created by François-Xavier on 23/10/2023.
//

import Foundation

final class ConverterModel {
    
    //MARK: - Property
    private var rating: ConverterResponse.Currency?
    
    private var currencyChoice = UserDefaults.standard
    
    private var fromCurrency: String {
        return currencyChoice.string(forKey: "ToCurrencyChoice") ?? "EUR"
    }
    private var toCurrency: String {
        currencyChoice.string(forKey: "FromCurrencyChoice") ?? "USD"
    }
    
    //MARK: - Accesible
    weak var delegate: AppServiceDelegate?
    
    func getConvertion(inputAmount: String) {
        let result = calcul(amount: inputAmount)
        delegate?.didUpdate(result: result)
    }
    
    func handleCurrencySelection(currency: String, index: Int) {
        if index == 0 {
            saveCurrency(value: currency, key: "FromCurrencyChoice")
        } else {
            saveCurrency(value: currency, key: "ToCurrencyChoice")
        }
    }
    
    //MARK: - Private
    func getRates() async {
        switch await APIService<ConverterResponse>.performRequest(apiRequest: APIRequest(url: .fixer, method: .get, parameters: nil)) {
            case .success(let conversion) :
            self.rating = conversion.rates
            case .failure(let error) : delegate?.didFail(error: error)
            }
    }
    
    // Mauvaise gestion de l'erreur
    private func calcul(amount: String) -> String {
        guard let amountDouble = Double(amount) else { return "Error" }
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
//    private func mapper() -> Double {
//        
//        guard let unWrappedRates = rating else { return 0.0 }
//        
//        switch selectedCurrency {
//            
//        case .AED:
//            return unWrappedRates.AED
//        case .AFN:
//            <#code#>
//        case .ALL:
//            <#code#>
//        case .AMD:
//            <#code#>
//        case .ANG:
//            <#code#>
//        case .AOA:
//            <#code#>
//        case .ARS:
//            <#code#>
//        case .AUD:
//            <#code#>
//        case .AWG:
//            <#code#>
//        case .AZN:
//            <#code#>
//        case .BAM:
//            <#code#>
//        case .BBD:
//            <#code#>
//        case .BDT:
//            <#code#>
//        case .BGN:
//            <#code#>
//        case .BHD:
//            <#code#>
//        case .BIF:
//            <#code#>
//        case .BMD:
//            <#code#>
//        case .BND:
//            <#code#>
//        case .BOB:
//            <#code#>
//        case .BRL:
//            <#code#>
//        case .BSD:
//            <#code#>
//        case .BTC:
//            <#code#>
//        case .BTN:
//            <#code#>
//        case .BWP:
//            <#code#>
//        case .BYN:
//            <#code#>
//        case .BYR:
//            <#code#>
//        case .BZD:
//            <#code#>
//        case .CAD:
//            <#code#>
//        case .CDF:
//            <#code#>
//        case .CHF:
//            <#code#>
//        case .CLF:
//            <#code#>
//        case .CLP:
//            <#code#>
//        case .CNY:
//            <#code#>
//        case .COP:
//            <#code#>
//        case .CRC:
//            <#code#>
//        case .CUC:
//            <#code#>
//        case .CUP:
//            <#code#>
//        case .CVE:
//            <#code#>
//        case .CZK:
//            <#code#>
//        case .DJF:
//            <#code#>
//        case .DKK:
//            <#code#>
//        case .DOP:
//            <#code#>
//        case .DZD:
//            <#code#>
//        case .EGP:
//            <#code#>
//        case .ERN:
//            <#code#>
//        case .ETB:
//            <#code#>
//        case .EUR:
//            <#code#>
//        case .FJD:
//            <#code#>
//        case .FKP:
//            <#code#>
//        case .GBP:
//            <#code#>
//        case .GEL:
//            <#code#>
//        case .GGP:
//            <#code#>
//        case .GHS:
//            <#code#>
//        case .GIP:
//            <#code#>
//        case .GMD:
//            <#code#>
//        case .GNF:
//            <#code#>
//        case .GTQ:
//            <#code#>
//        case .GYD:
//            <#code#>
//        case .HKD:
//            <#code#>
//        case .HNL:
//            <#code#>
//        case .HRK:
//            <#code#>
//        case .HTG:
//            <#code#>
//        case .HUF:
//            <#code#>
//        case .IDR:
//            <#code#>
//        case .ILS:
//            <#code#>
//        case .IMP:
//            <#code#>
//        case .INR:
//            <#code#>
//        case .IQD:
//            <#code#>
//        case .IRR:
//            <#code#>
//        case .ISK:
//            <#code#>
//        case .JEP:
//            <#code#>
//        case .JMD:
//            <#code#>
//        case .JOD:
//            <#code#>
//        case .JPY:
//            <#code#>
//        case .KES:
//            <#code#>
//        case .KGS:
//            <#code#>
//        case .KHR:
//            <#code#>
//        case .KMF:
//            <#code#>
//        case .KPW:
//            <#code#>
//        case .KRW:
//            <#code#>
//        case .KWD:
//            <#code#>
//        case .KYD:
//            <#code#>
//        case .KZT:
//            <#code#>
//        case .LAK:
//            <#code#>
//        case .LBP:
//            <#code#>
//        case .LKR:
//            <#code#>
//        case .LRD:
//            <#code#>
//        case .LSL:
//            <#code#>
//        case .LTL:
//            <#code#>
//        case .LVL:
//            <#code#>
//        case .LYD:
//            <#code#>
//        case .MAD:
//            <#code#>
//        case .MDL:
//            <#code#>
//        case .MGA:
//            <#code#>
//        case .MKD:
//            <#code#>
//        case .MMK:
//            <#code#>
//        case .MNT:
//            <#code#>
//        case .MOP:
//            <#code#>
//        case .MRO:
//            <#code#>
//        case .MUR:
//            <#code#>
//        case .MVR:
//            <#code#>
//        case .MWK:
//            <#code#>
//        case .MXN:
//            <#code#>
//        case .MYR:
//            <#code#>
//        case .MZN:
//            <#code#>
//        case .NAD:
//            <#code#>
//        case .NGN:
//            <#code#>
//        case .NIO:
//            <#code#>
//        case .NOK:
//            <#code#>
//        case .NPR:
//            <#code#>
//        case .NZD:
//            <#code#>
//        case .OMR:
//            <#code#>
//        case .PAB:
//            <#code#>
//        case .PEN:
//            <#code#>
//        case .PGK:
//            <#code#>
//        case .PHP:
//            <#code#>
//        case .PKR:
//            <#code#>
//        case .PLN:
//            <#code#>
//        case .PYG:
//            <#code#>
//        case .QAR:
//            <#code#>
//        case .RON:
//            <#code#>
//        case .RSD:
//            <#code#>
//        case .RUB:
//            <#code#>
//        case .RWF:
//            <#code#>
//        case .SAR:
//            <#code#>
//        case .SBD:
//            <#code#>
//        case .SCR:
//            <#code#>
//        case .SDG:
//            <#code#>
//        case .SEK:
//            <#code#>
//        case .SGD:
//            <#code#>
//        case .SHP:
//            <#code#>
//        case .SLE:
//            <#code#>
//        case .SLL:
//            <#code#>
//        case .SOS:
//            <#code#>
//        case .SRD:
//            <#code#>
//        case .STD:
//            <#code#>
//        case .SYP:
//            <#code#>
//        case .SZL:
//            <#code#>
//        case .THB:
//            <#code#>
//        case .TJS:
//            <#code#>
//        case .TMT:
//            <#code#>
//        case .TND:
//            <#code#>
//        case .TOP:
//            <#code#>
//        case .TRY:
//            <#code#>
//        case .TTD:
//            <#code#>
//        case .TWD:
//            <#code#>
//        case .TZS:
//            <#code#>
//        case .UAH:
//            <#code#>
//        case .UGX:
//            <#code#>
//        case .USD:
//            <#code#>
//        case .UYU:
//            <#code#>
//        case .UZS:
//            <#code#>
//        case .VEF:
//            <#code#>
//        case .VES:
//            <#code#>
//        case .VND:
//            <#code#>
//        case .VUV:
//            <#code#>
//        case .WST:
//            <#code#>
//        case .XAF:
//            <#code#>
//        case .XAG:
//            <#code#>
//        case .XAU:
//            <#code#>
//        case .XCD:
//            <#code#>
//        case .XDR:
//            <#code#>
//        case .XOF:
//            <#code#>
//        case .XPF:
//            <#code#>
//        case .YER:
//            <#code#>
//        case .ZAR:
//            <#code#>
//        case .ZMK:
//            <#code#>
//        case .ZMW:
//            <#code#>
//        case .ZWL:
//            <#code#>
//        }
//    }
}
