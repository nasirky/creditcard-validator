//
//  CreditCardTableViewCell.swift
//  CreditCardNumberEvaluatorUI
//
//  Created by Ghulam Nasir.
//

import UIKit

class CreditCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lblNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
