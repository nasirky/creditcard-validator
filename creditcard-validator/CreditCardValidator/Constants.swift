//
//  Constants.swift
//  CreditCardValidator
//
//  Created by Ghulam Nasir.
//

import Foundation
public class Constants {
    
    static let _lengthConstraints: [Int : [CardBrand]] = [
        13 : [.Visa],
        14 : [.DinersClub],
        15 : [.AmericanExpress, .JCB],
        16 : [.Visa, .Mastercard, .Discover, .JCB]
    ]
    
    /* Visa -> always start with 4
     * Mastercard -> start with 51 to 55 or 2221 to 2720
     * AmericanExpress -> start with 34 or 37
     * DinersClub -> Start with 36, 38 or 300 to 305
     * Discover -> Starts with 65 or 6011
     * JCB -> Starts with 35 (JCB15 -> variation with length 15 (starts with 1800 or 2131))
     * The reason behind having an extra JCB15 is to make both 15 and 16 numbers long JCB cards without writing any special conditions
     
     * Note: hyphen/dash (-) between numbers specify a range such as 51-55 means 51 to 55 (both inclusive)
     */
    static let _prefixConstraints: [CardBrand: [String]] = [
        .Visa : ["4"],
        .Mastercard: ["51-55", "2221-2720"],
        .AmericanExpress: ["34", "37"],
        .DinersClub : ["36", "38", "300-305"],
        .Discover : ["65", "6011"],
        .JCB15 : ["1800", "2131"],
        .JCB : ["35"]]


    private static let _sortedKeys = Constants._lengthConstraints.keys.sorted()
    public static var minimumCardLength = _sortedKeys.first ?? 13
    public static var maximumCardLength = _sortedKeys.last ?? 16

}
