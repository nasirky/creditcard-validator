//
//  ErrorType.swift
//  CreditCardValidator
//
//  Created by Ghulam Nasir.
//

import Foundation

public enum ErrorType {
    case LeadingZero
    case NonNumeric
    case WrongLength
    case LuhnCheckFailed
    case NullCardNumber
    case UnsupportedCardBrand
    case None
}
