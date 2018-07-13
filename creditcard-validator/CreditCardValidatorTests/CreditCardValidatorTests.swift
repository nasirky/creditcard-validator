//
//  CreditCardValidatorTests.swift
//  CreditCardValidatorTests
//
//  Created by Ghulam Nasir.
//

import XCTest
@testable import CreditCardValidator

class CreditCardValidatorTests: XCTestCase {
    
    var creditCardValidation: CreditCardValidation?

    //Test card numbers taken from https://www.paypalobjects.com/en_GB/vhelp/paypalmanager_help/credit_card_numbers.htm
    var cardNumbers: [String] = ["3566-0020-2036-0505-", "5105 1051 0510 5100", "378282246310005","371449635398431","378734493671000","30569309025904","38520000023237","6011111111111117","6011000990139424","3530111333300000","3566002020360505","5555555555554444","5105105105105100","4111111111111111","4012888888881881","4222222222222","5610591081018250"]

    var cardBrands: [CardBrand] = [.JCB, .Mastercard, .AmericanExpress, .AmericanExpress, .AmericanExpress, .DinersClub, .DinersClub, .Discover, .Discover, .JCB, .JCB, .Mastercard, .Mastercard, .Visa, .Visa, .Visa, .Other]

    //Card Failing Luhn Check (one digit of some of the above credit cards changed
    var invalidCardNumbers: [String?] = ["3566-0020-2036-0503", nil, "5105 1051 0510 5102", "378282246310075","371449635298431","378134493671000"]

    override func setUp() {
        super.setUp()

        creditCardValidation = CreditCardValidation()
    }
    
    override func tearDown() {
        super.tearDown()
        
        creditCardValidation = nil
    }
    
    func testCardBrand() {
        for i in 0..<cardNumbers.count {
            let (cardBrand, error) = creditCardValidation!.getCardBrand(for: cardNumbers[i])
            XCTAssertEqual(cardBrand, cardBrands[i])
            XCTAssertEqual(error.type, ErrorType.None)
        }
        
        //checking nil card number
        let (cardBrand, error) = creditCardValidation!.getCardBrand(for: nil)
        XCTAssertEqual(cardBrand, .Invalid)
        XCTAssertEqual(error.type, ErrorType.NullCardNumber)
    }
    
    func testCheckLuhn() {
        for cardNumber in cardNumbers {
            XCTAssertTrue(creditCardValidation!.checkLuhn(for: cardNumber))
        }
        
        for cardNumber in invalidCardNumbers {
            XCTAssertFalse(creditCardValidation!.checkLuhn(for: cardNumber))
        }
    }

    func testCardValidation() {
        for cardNumber in cardNumbers {
            XCTAssertEqual(creditCardValidation?.isValid(cardNumber).type, ErrorType.None)
        }
        
        for cardNumber in invalidCardNumbers {
            XCTAssertNotEqual(creditCardValidation?.isValid(cardNumber).type, ErrorType.None)
        }
    }
    
}
