//
//  LoanCell.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 24/02/24.
//

import UIKit

class LoanCell: UICollectionViewCell {
    
    static let identifier = "loan-cell"
    
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_amount: UILabel!
    @IBOutlet weak var lb_purpose: UILabel!
    @IBOutlet weak var lb_term: UILabel!
    @IBOutlet weak var lb_risk: UILabel!
    @IBOutlet weak var lb_interest: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }

}
