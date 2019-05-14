//
//  HistoricoComprasCell.swift
//  Cestou
//
//  Created by Rafael Ferreira on 14/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import Foundation
import UIKit


class HistoricoComprasCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCardView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCardView.layer.cornerRadius = 12
        backgroundCardView.layer.borderWidth = 0.5
        backgroundCardView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundCardView.layer.masksToBounds = false
    }
}
