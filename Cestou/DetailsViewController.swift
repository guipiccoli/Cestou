//
//  DetailsViewController.swift
//  Cestou
//
//  Created by Rafael Ferreira on 30/04/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var stringQrCode: String?
    
    @IBOutlet private weak var TempLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if stringQrCode != nil {
            TempLabel.text = stringQrCode
        }
    }
}
