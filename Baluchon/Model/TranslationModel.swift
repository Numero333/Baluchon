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
        
        var translateFrom: String {
            return translatorChoice.string(forKey: "TranslateFrom") ?? "french"
        }
        
        var translateTo: String {
            return translatorChoice.string(forKey: "TranslateTo") ?? "english"
        }
        
        private var translateFromAPI: String {
            return translatorChoice.string(forKey: "TranslateFromApi") ?? "fr"
        }
        
        private var translateToAPI: String {
            return translatorChoice.string(forKey: "TranslateToApi") ?? "en"
        }
        
        //MARK: - Accesible
        weak var delegate: AppServiceDelegate?
        
        func getTranslation(text: String) {
            print("translate: \(translateFromAPI) to \(translateToAPI)")
            Task {
                switch await APIService<TranslationResponse>.performRequest(
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
        }
        
        func handleLanguageSelection(language: Language, index: Int) {
            if index == 0 {
                print(language)
                saveLanguage(value: String(describing: language), key: "TranslateFrom")
                saveLanguage(value: language.rawValue, key: "TranslateFromApi")
            } else {
                saveLanguage(value: String(describing: language), key: "TranslateTo")
                saveLanguage(value: language.rawValue, key: "TranslateToApi")
                print("save api \(language.rawValue)")
            }
        }
        
        //MARK: - Private
        private func saveLanguage(value: String, key: String) {
            translatorChoice.set(value, forKey: key)
        }
    }
