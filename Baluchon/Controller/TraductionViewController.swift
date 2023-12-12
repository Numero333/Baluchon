//
//  TraductionViewController.swift
//  Baluchon
//
//  Created by François-Xavier on 20/10/2023.
//

import UIKit

final class TraductionViewController: UIViewController, TranslationModelDelegate, UITextViewDelegate {
    
    //MARK: - Property
    @IBOutlet private var inputTextView: UITextView!
    @IBOutlet private var translatedTextView: UITextView!
    @IBOutlet weak var translatorButtonFrom: UIButton!
    @IBOutlet weak var translatorButtonTo: UIButton!
    private var model = TranslationModel()
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        makeMenu(for: translatorButtonFrom, index: 0)
        makeMenu(for: translatorButtonTo, index: 1)
        inputTextView.delegate = self
        view.linearGradientBackground()
    }
    
    //MARK: - AppServiceDelegate
    func didFail(error: APIError) {
        DispatchQueue.main.async {
            Alert.display(vc: self, message: error.description)
        }
    }
    
    func didUpdate(result: String) {
        DispatchQueue.main.async {
            self.translatedTextView.text = result
        }
    }
    
    //MARK: - Action
    @IBAction private func translateButton(_ sender: UIButton) {
        guard let text = self.inputTextView.text, !text.isEmpty else { return }
        model.onrefresh(text: text)
    }
    
    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.inputTextView.resignFirstResponder()
    }
        
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Private
    private func makeMenu(for button: UIButton, index: Int) {
        button.menu = UIMenu(title: "Language", children: makeValueMenu(index: index))
    }
    
    private func makeValueMenu(index: Int) -> [UIMenuElement] {
        var menuElement: [UIMenuElement] = []
        for language in Language.allCases {
            menuElement.append(
                UIAction(title: "\(language)".capitalizingFirstLetter(),
                         handler: {_ in
                             self.model.handleLanguageSelection(language: language, index: index)
                         }
                        ))}
        self.selectionState(index: index, for: menuElement)
        return menuElement
    }
    
    private func selectionState(index: Int, for elements: [UIMenuElement]) {
        if index == 0 {
            if let element = elements.first(where: { ($0 as? UIAction)?.title.lowercased() == self.model.translateFrom }) as? UIAction {
                element.state = .on
            }
        } else if index == 1 {
            if let element = elements.first(where: { ($0 as? UIAction)?.title.lowercased() == self.model.translateTo }) as? UIAction {
                element.state = .on
            }
        }
    }
}
