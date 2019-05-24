//
//  OnboardCollectionViewCell.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 22/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class OnboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var symbolImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var inputTextField: signUITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet var ballsImage: UIImageView!
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.contentView.endEditing(true)
    }
}
