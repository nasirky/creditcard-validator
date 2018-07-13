# Credit Card Validator
The main purpose of the project is to provide a ``framework`` for credit card number validation. 

## Validation Criteria
At this stage, we are validating the credit card against the following criteria:
1. Credit Card number should not be null (``nil``)
2. It should not start with a leading zero
3. It should only contain numbers, spaces and hyphens/dashes (-)
4. It should pass [Luhn Check](https://en.wikipedia.org/wiki/Luhn_algorithm)
5. There is a special criteria ``acceptOnlyPredefinedCardBrands``, when set validates only the predefined card brands.

## Currently Accepted Card Brands
1. Visa
2. Mastercard
3. America Express
4. Diners Club
5. Discover
6. JCB (We have two variations for JCB. One is ``JCB`` and the other is ``JCB15``. ``JCB`` is 16 characters long and starts with ``35`` while ``JCB15`` is 15 characters long and starts with 1800 or 2131.

## Special Criteria for Card Brands
Brand | Length (Min, Max) | Starts with
--- | --- | ---
Visa | (13, 16) | 4
Mastercard | 16 | 51-55, 2221-2720
America Express | 15 | 34, 37
Diners Club | 14 | 36, 38, 300-305
Discover | 16 | 65, 6011
JCB | (15,16) |   15 characters long -> 1800, 2131
 |  |   | 16 characters long -> 35


# More Credit Cards:
More credit cards can easily be added in ``CreditCardValidation.swift``. Below are the steps:

- Add the Credit card brand to the corresponding
    - _lengthConstraint
    - _prefixConstraints
