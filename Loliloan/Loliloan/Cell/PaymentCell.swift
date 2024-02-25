//
//  PaymentCell.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 25/02/24.
//

import UIKit

class PaymentCell: UICollectionViewCell {
    
    static let identifier = "payment-cell"

    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var lb_amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorner()
    }

}
