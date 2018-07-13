//
//  CreditCard.swift
//  CreditCardValidator
//
//  Created by Ghulam Nasir.
//

import Foundation

public class CreditCard {
    private var _number: String?
    private var _brand: CardBrand
    private var _error: Error
    
    public init(with number: String?, brand: CardBrand, error: Error) {
        _number = number
        _brand = brand
        _error = error
    }
    
    public var number: String? {
        get {
            return _number
        }
    }

    public var brand: CardBrand {
        get {
            return _brand
        }
    }
    
    public var error: Error {
        get {
            return _error
        }
    }
}
