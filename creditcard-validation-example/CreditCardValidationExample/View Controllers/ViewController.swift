//
//  ViewController.swift
//  CreditCardValidationExample
//
//  Created by Ghulam Nasir.
//

import UIKit
import CreditCardValidator

class ViewController: UIViewController {
    
    @IBOutlet weak var txtCreditCardNumbers: UITextView!
    @IBOutlet weak var tvResults: UITableView!
    
    var creditCards = [CreditCard]()
    var creditCardValidation = CreditCardValidation.init()
    
    let greenColor = UIColor.init(red: 11.0/255.0, green: 102.0/255.0, blue: 35.0/255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding Done button to keyboard
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard(_:)))
        
        //Adding flexible space as I want to have the Done button on the right
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        txtCreditCardNumbers.inputAccessoryView = toolbar
    }
    
    @IBAction func validate(_ sender: UIButton) {
        let cardNumbers = txtCreditCardNumbers.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if cardNumbers.count == 0 {
            Helper.sharedInstance.showAlert(on: self, message: "Please enter at least 1 card number")
        } else {
            if txtCreditCardNumbers.isFirstResponder {
                txtCreditCardNumbers.resignFirstResponder()
            }
            
            creditCards.removeAll()
            //splitting the string by , (numbers are separated by ,)
            let cardsArray = cardNumbers.split(separator: ",")
            for cardNumber in cardsArray {
                let card = creditCardValidation.validateAndReturnCardBrand(for: String(cardNumber))
                creditCards.append(card)
            }
            
            tvResults.reloadData()
        }
    }
    
    @objc func dismissKeyboard(_ sender: UIBarButtonItem) {
        self.view.endEditing(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardCell") as! CreditCardTableViewCell
        let card = creditCards[indexPath.row]
        
        let image = UIImage(named: card.brandName)
        
        //In case the card is not issued by any of the four companies, "none" image is shown
        cell.ivLogo.image = image != nil ? image : UIImage(named: "none")
        cell.lblNumber.text = card.number
        
        if let _ = card.error {
            cell.accessoryType = UITableViewCellAccessoryType.detailButton
            cell.lblNumber.textColor = .red
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.lblNumber.textColor = greenColor
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let error = creditCards[indexPath.row].error {
            Helper.sharedInstance.showAlert(on: self, message: error.details)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        let label = UILabel.init(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 20))
        
        let text = "Results (Color Scheme: Valid, Invalid)"
        
        let rangeOfGreenString = (text as NSString).range(of: "Valid")
        let rangeOfRedString = (text as NSString).range(of: "Invalid")
        
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: greenColor, range: rangeOfGreenString)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: rangeOfRedString)
        
        label.attributedText = attributedText
        
        view.addSubview(label)
        
        let colorComponent: CGFloat = 247.0/255.0
        view.backgroundColor = UIColor.init(red: colorComponent, green: colorComponent, blue: colorComponent, alpha: 1.0)
        
        return view
    }
}
