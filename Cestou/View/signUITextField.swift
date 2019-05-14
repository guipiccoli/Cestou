//
//  signUITextField.swift
//  
//
//  Created by Jobe Diego Dylbas dos Santos on 07/05/19.
//

import UIKit

@IBDesignable
open class signUITextField: UITextField {
    
    var border = CALayer()
    
    func setup() {
        let width = CGFloat(1.0)
        
        self.border.borderColor = UIColor.darkGray.cgColor
        self.border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        self.border.borderWidth = width
        self.border.borderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        self.border.name = "border"
        self.layer.addSublayer(self.border)
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
