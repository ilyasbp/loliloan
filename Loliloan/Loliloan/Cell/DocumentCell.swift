//
//  DocumentCell.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 25/02/24.
//

import UIKit

class DocumentCell: UICollectionViewCell {
    
    static let identifier = "document-cell"
    
    @IBOutlet weak var lb_docname: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorner()
    }

}
