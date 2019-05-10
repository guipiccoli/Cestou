//
//  signUITextField.swift
//  
//
//  Created by Jobe Diego Dylbas dos Santos on 07/05/19.
//

import UIKit

@IBDesignable
open class signUITextField: UITextField {
    
    func setup() {
        let border = CALayer()
        let width = CGFloat(1.0)
        let myMutableStringPlaceholder = NSMutableAttributedString()
        
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        border.borderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor

        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
