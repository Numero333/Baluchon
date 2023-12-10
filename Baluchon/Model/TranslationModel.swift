//
//  TranslationModel.swift
//  Baluchon
//
//  Created by François-Xavier on 25/10/2023.
//

import Foundation

protocol TranslationModelDelegate: AnyObject {
    func didFail(error: APIError)
    func didUpdate(result: String)
}

final class TranslationModel {
    
    //MARK: - Property
    private var translatorChoice = UserDefaults.standard
    
    var apiService = APIService<TranslationResponse>()
    
    var translateFrom: String {
        get {
            translatorChoice.string(forKey: "TranslateFrom") ?? "french"
        }
        set {
            translatorChoice.setValue(newValue, forKey: "TranslateFrom")
        }
    }
    
    var translateTo: String {
        
        get {
            translatorChoice.string(forKey: "TranslateTo") ?? "english"
        }
        set {
            translatorChoice.setValue(newValue, forKey: "TranslateTo")
        }
    }
    
    var translateFromAPI: String {
        get {
            translatorChoice.string(forKey: "TranslateFromApi") ?? "fr"
        }
        set {
            translatorChoice.setValue(newValue, forKey: "TranslateFromApi")
        }
        
    }
    
    var translateToAPI: String {
        get {
            translatorChoice.string(forKey: "TranslateToApi") ?? "en"
        }
        set {
            translatorChoice.setValue(newValue, forKey: "TranslateToApi")
        }
        
    }
    
    //MARK: - Accesible
    weak var delegate: TranslationModelDelegate?
    
    func getTranslation(text: String) async {
        switch await apiService.performRequest(
            apiRequest: APIRequest(url: .googleTranslate,
                                   method: .get,
                                   parameters: TranslationRequest(query: text,
                                                                  source: translateFromAPI,
                                                                  target: translateToAPI,
                                                                  format: "text").value)
        ){
        case .success(let translation): delegate?.didUpdate(result: translation.data.translations[0].translatedText)
        case .failure(let error) : delegate?.didFail(error: error)
        }
    }
    
    func handleLanguageSelection(language: Language, index: Int) {
        if index == 0 {
            translateFrom = String(describing: language)
            translateFromAPI = language.rawValue
        } else {
            translateTo = String(describing: language)
            translateToAPI = language.rawValue
        }
    }
}
