//
//  ConverterViewController.swift
//  Baluchon
//
//  Created by François-Xavier on 20/10/2023.
//

import UIKit

final class ConverterViewController: UIViewController, AppServiceDelegate {
    
    //MARK: - Property
    @IBOutlet private var textField: UITextField!
    @IBOutlet weak var resultView: UILabel!
    @IBOutlet weak var buttonFromCurrency: UIButton!
    @IBOutlet weak var buttonToCurrency: UIButton!
    
    private var model = ConverterModel()
    
    // model on view did load method et le model fais son job
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        view.linearGradientBackground()
        makeMenu(for: buttonFromCurrency, index: 0)
        makeMenu(for: buttonToCurrency, index: 1)
        Task {
            await model.getRates()
        }
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
        
//            .reversed()
        
        for currency in Currency.allCases {
            
            menuElement.append(
                UIAction(title: currency.rawValue,
                         subtitle: currency.description,
                         handler: { currency in
                             print(currency.title)
                             self.model.handleCurrencySelection(currency: currency.title, index: index)
                         }
                        ))}
        return menuElement
    }
}
