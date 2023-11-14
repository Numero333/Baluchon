//
//  AppServiceDelegate.swift
//  Baluchon
//
//  Created by François-Xavier on 29/10/2023.
//

import Foundation

protocol AppServiceDelegate: AnyObject {
    func didFail(error: APIError)
    func didUpdate(result: String)
}
