//
//  TranslationModel.swift
//  Baluchon
//
//  Created by François-Xavier on 25/10/2023.
//

import Foundation

final class TranslationModel {
    
    //MARK: - Property
    private var translatorChoice = UserDefaults.standard
    
    private var translateFrom: String {
        return translatorChoice.string(forKey: "TranslateFrom") ?? "fr"
    }
    
    private var translateTo: String {
        return translatorChoice.string(forKey: "TranslateTo") ?? "en"
    }
    
    //MARK: - Accesible
    weak var delegate: AppServiceDelegate?
    
    func getTranslation(text: String) {
        Task {
            switch await APIService<TranslationResponse>.performRequest(
                apiRequest: APIRequest(url: .googleTranslate,
                              method: .get,
                              parameters: TranslationRequest(query: text, 
                                                             source: translateFrom,
                                                             target: translateTo,
                                                             format: "text").value)
            ){
            case .success(let translation): delegate?.didUpdate(result: translation.data.translations[0].translatedText)
            case .failure(let error) : delegate?.didFail(error: error)
            }
        }
    }
    
    //MARK: - Private
    func handleLanguageSelection(language: String, index: Int) {
        if index == 0 {
            saveCurrency(value: language, key: "TranslateFrom")
        } else {
            saveCurrency(value: language, key: "TranslateTo")
        }
    }
    
    private func saveCurrency(value: String, key: String) {
        translatorChoice.set(value, forKey: key)
    }
}
