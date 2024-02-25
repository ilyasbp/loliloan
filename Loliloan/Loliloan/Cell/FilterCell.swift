//
//  FilterCell.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 24/02/24.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    static let identifier = "filter-cell"

    @IBOutlet weak var lb_filter: UILabel!
    
    var isActived: Bool = true {
            didSet {
                updateButtonState()
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 6
        layer.masksToBounds = true
        layer.borderColor = UIColor.orangered.cgColor
    }

    private func updateButtonState() {
            if isActived {
                backgroundColor = .orangered
                lb_filter.textColor = .white
                layer.borderWidth = 0
            } else {
                backgroundColor = .white
                lb_filter.textColor = .orangered
                layer.borderWidth = 1
            }
        }
}
