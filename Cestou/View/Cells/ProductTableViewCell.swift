//
//  ProductTableViewCell.swift
//  Cestou
//
//  Created by Eduardo Ribeiro on 02/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    //@IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
