//
//  DisplayAlert.swift
//  Baluchon
//
//  Created by François-Xavier on 31/10/2023.
//

import UIKit

struct Alert {
    static func display(vc: UIViewController, message: String) {
        assert(Thread.isMainThread)
        let alertVC = UIAlertController(title: "Erreur !", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        vc.present(alertVC, animated: true, completion: nil)
    }
}
