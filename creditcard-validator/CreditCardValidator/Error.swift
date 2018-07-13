//
//  Error.swift
//  CreditCardValidator
//
//  Created by Ghulam Nasir.
//

import Foundation
class Error {

    private var _type: ErrorType
    private var _details: String?
    
    init(_ errorType: ErrorType) {
        _type = errorType
        _details = self.getErrorDetails()
    }
    
    private func getErrorDetails() -> String {
        switch (_type) {
        case .LeadingZero:
                return "Credit Card Number cannot start with a zero (0)"
        case .NonNumeric:
            return "Credit Card Number can only numeric (it may also contains spaces or dashes(-))"
        case .WrongLength:
            return "Credit Card Number should not be less than 13 or more than 16 characters long"
        case .LuhnCheckFailed:
            return "Credit Card Number failed to pass the Luhn Check"
        case .UnsupportedCardBrand:
            return "Sorry, we are not supporting this card brand at the time"
        default:
            return "None"
        }
    }
        
    public var type: ErrorType {
        get {
            return _type
        }
    }
    
    public var details: String {
        return _details ?? ""
    }
}
