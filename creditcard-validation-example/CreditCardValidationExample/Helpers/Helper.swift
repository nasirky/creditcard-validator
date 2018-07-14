//
//  Helper.swift
//  CreditCardValidationExample
//
//  Created by Ghulam Nasir.
//

import Foundation
import UIKit

class Helper {
    public static var sharedInstance = Helper()
    
    func showAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "CreditCardValidationExample", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        viewController.present(alert, animated: false, completion: nil)
    }
}
