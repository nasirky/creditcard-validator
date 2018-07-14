//
//  CreditCardValidation.swift
//  CreditCardValidator
//
//  Created by Ghulam Nasir.
//

import Foundation

public class CreditCardValidation {
    //MARK:- Public Methods
    public init() {
    }
    
    /* A credit card number is valid when it meets the following conditions:
     1. it contains only numbers and no leading 0
     2. it is 13-16 digits long
     3. It passes the Luhn check (https://en.wikipedia.org/wiki/Luhn_algorithm). For credit card numbers, the Luhn check digit is the last digit of the sequence.
     */
    public func isValid(_ cardNumber:String?, acceptOnlyPredefinedCardBrands: Bool = false) -> Error? {
        guard let cardNumber = removeDashesAndSpaces(cardNumber) else { return Error(.NullCardNumber) }
        
        guard cardNumber.count >= Constants.minimumCardLength && cardNumber.count <= Constants.maximumCardLength else  { return Error(.WrongLength) }

        guard self.isNumeric(cardNumber) else { return Error(.NonNumeric)}

        guard !self.getSubstring(from: cardNumber, index: 0, length: 1).elementsEqual("0") else {
            return Error(.LeadingZero)
        }
                
        if !self.checkLuhn(for: cardNumber) {
            return Error(.LuhnCheckFailed)
        }

        //Strict Checking: Validating only the cards we have already input
        if acceptOnlyPredefinedCardBrands && self.getCardBrand(for: cardNumber).brand == .Other {
            return Error(.UnsupportedCardBrand)
        }
        
        return nil
    }
    
    /* Algorithm
     1. Make sure card number is numeric
     1. Get Card length and then fetch the eligible brands
     2. Loop through the brands to figure the exact brand
     3. Perform Luhn check to validate the card number
     */
    public func getCardBrand(for cardNumber: String?) -> CreditCard {
        guard let cardNumber = removeDashesAndSpaces(cardNumber) else { return CreditCard(with: nil, brand: .Invalid, error: Error(.NullCardNumber))
        }
        
        guard cardNumber.count >= Constants.minimumCardLength && cardNumber.count <= Constants.maximumCardLength else {
            return CreditCard(with: cardNumber, brand: .Invalid, error: Error(.WrongLength))
        }

        guard self.isNumeric(cardNumber) else { return CreditCard(with: cardNumber, brand: .Invalid, error: Error(.NonNumeric))}

        let length = cardNumber.count


        guard let possibleBrands = Constants._lengthConstraints[length] else { return CreditCard(with: cardNumber, brand: .Invalid, error: Error(.UnsupportedCardBrand))
        }
        
        for brand in possibleBrands {
            // Unwrapping optional as we already know that there would be at least 1 possible brand
            let constraints = Constants._prefixConstraints[brand]!
            
            for constraint in constraints {
                let components = constraint.split(separator: "-")
                
                /* Calculating the minimum and maximum allowed range for each constraint
                 * In case there is no maximum range, we treat the minimum range as maximum range
                 */
                let minRange = "\(components[0])"
                let maxRange = components.count > 1 ? "\(components[1])" : minRange
                
                //Force unwrapping here as we will already have a credit card number with a length of at least 13
                let minRangePrefix = Int(cardNumber.dropLast(cardNumber.count - minRange.count))!
                let maxRangePrefix = Int(cardNumber.dropLast(cardNumber.count - maxRange.count))!
                
                /* In our current set, the max and minimum range have the same length such as 51-55, 300-305 etc.
                 * However, I am treating them differently here so that a case where both the ranges have different lengths (such as 90 - 102 etc.) are also covered
                 */
 
                if minRangePrefix >= Int(minRange)! && maxRangePrefix <= Int(maxRange)! {
                    return CreditCard(with: cardNumber, brand: brand, error: nil)
                }
            }
            
        }
        
        return CreditCard(with: cardNumber, brand: .Other, error: nil)
    }
    
    /* This function performs the Luhn Check. Luhn Check digit is the last digit in the credit cards. It is a verification step to make sure that the credit card number is correct. For more information, please visit https://en.wikipedia.org/wiki/Luhn_algorithm
     */
    public func checkLuhn(for cardNumber: String?) -> Bool {
        // Checking for nil & numeric input as each of these methods can be used independently of isValid
        guard let cardNumber = removeDashesAndSpaces(cardNumber) else { return false }
        guard self.isNumeric(cardNumber) else { return false}

        let nDigits = cardNumber.count
        var sum = Int(cardNumber.dropFirst(nDigits - 1)) ?? -1
        let parity = nDigits % 2
        
        for i in 0...nDigits - 2 {
            if var digit = Int(self.getSubstring(from: cardNumber, index: i, length: 1)) {
                if i % 2 == parity {
                    digit = digit * 2
                }
            
                if digit > 9 {
                    digit = digit - 9
                }
            
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }

    /* Helper function that performs validation and also returns card brand information */
    public func validateAndReturnCardBrand(for cardNumber: String?) -> CreditCard {
        let creditCard = getCardBrand(for: cardNumber)
        let error = isValid(cardNumber)
        
        //Validation error supersedes brand errors (invalid brand etc.)
        creditCard.error = error
        
        return creditCard
    }
}

extension CreditCardValidation {
    //MARK:- Private functions
    private func getSubstring(from string: String, index: Int, length: Int) -> String {
        let startIndex = string.index(string.startIndex, offsetBy: index)
        let endIndex = string.index(string.startIndex, offsetBy: index + length)
        
        return String(string[startIndex..<endIndex])
    }
    
    private func removeDashesAndSpaces(_ cardNumber: String?) -> String? {
        guard let cardNumber = cardNumber else { return nil }
 
        guard cardNumber.count > 0 else { return nil }

        let regex = try? NSRegularExpression(pattern: "[^0-9]+", options: .caseInsensitive)
        let range = NSMakeRange(0, cardNumber.count)
        if let processedCardNumber = regex?.stringByReplacingMatches(in: cardNumber, options: .reportCompletion, range: range, withTemplate: "") {
            //Checking the count on both the original number as well as the processed number (as the original number might contain spaces, new lines etc.)
            guard processedCardNumber.count > 0 else { return nil }

            return processedCardNumber
        }
        return cardNumber
    }

    /* This method check if the card number is numeric. We have two scenarios:
     * 1. Accepting only ASCII (US) Digits (0-9)
     * 2. Accepting non-ASCII Digits (such as Arabic, indie numbers etc.)
     */
    func isNumeric(_ string: String, with nonAsciiNumericSupport: Bool = false) -> Bool {
        var numericCharacterSet: CharacterSet = CharacterSet(charactersIn: "0123456789")
        if nonAsciiNumericSupport {
            numericCharacterSet = .decimalDigits
        }
        
        let characterSet = CharacterSet(charactersIn: string)
        return numericCharacterSet.isSuperset(of: characterSet)
    }
}
