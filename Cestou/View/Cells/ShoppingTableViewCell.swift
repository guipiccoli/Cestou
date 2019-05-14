//
//  ShoppingTableViewCell.swift
//  Cestou
//
//  Created by Eduardo Ribeiro on 13/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {

    @IBOutlet weak var marketplace: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
