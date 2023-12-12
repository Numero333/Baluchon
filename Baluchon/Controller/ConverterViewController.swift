//
//  ConverterViewController.swift
//  Baluchon
//
//  Created by François-Xavier on 20/10/2023.
//

import UIKit

final class ConverterViewController: UIViewController, ConverterModelDelegate {
    
    //MARK: - Property
    @IBOutlet private var textField: UITextField!
    @IBOutlet weak var resultView: UILabel!
    @IBOutlet weak var buttonFromCurrency: UIButton!
    @IBOutlet weak var buttonToCurrency: UIButton!
    private var model = ConverterModel()
        
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        view.linearGradientBackground()
        makeMenu(for: buttonFromCurrency, index: 0)
        makeMenu(for: buttonToCurrency, index: 1)
        model.onViewDidLoad()
    }
    
    //MARK: - AppServiceDelegate
    func didFail(error: APIError) {
        DispatchQueue.main.async {
            Alert.display(vc: self, message: error.description)
        }
    }
    
    func didUpdate(result: String) {
        DispatchQueue.main.async {
            self.resultView.text = result
        }
    }
    
    //MARK: - Action
    @IBAction private func convertButton(_ sender: UIButton) {
        guard let text = textField.text else { return }
        self.model.getConvertion(inputAmount: text)
    }
    
    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: - Private
    private func makeMenu(for button: UIButton, index: Int) {
        button.menu = UIMenu(title: "Currency", children: makeValueMenu(index: index))
    }
    
    private func makeValueMenu(index: Int) -> [UIMenuElement] {
        var menuElement: [UIMenuElement] = []
        for currency in Currency.allCases {
            menuElement.append(
                UIAction(title: currency.rawValue,
                         subtitle: currency.description,
                         handler: { currency in
                             self.model.handleCurrencySelection(currency: currency.title, index: index)
                         }
                        ))}
        self.selectionState(index: index, for: menuElement)
        if index == 1 {
            menuElement.reverse()
        }
        return menuElement
    }
    
    private func selectionState(index: Int, for elements: [UIMenuElement]) {
        if index == 0 {
            if let element = elements.first(where: { ($0 as? UIAction)?.title == self.model.fromCurrency }) as? UIAction {
                element.state = .on
            }
        } else if index == 1 {
            if let element = elements.first(where: { ($0 as? UIAction)?.title == self.model.toCurrency }) as? UIAction {
                element.state = .on
            }
        }
    }
}
