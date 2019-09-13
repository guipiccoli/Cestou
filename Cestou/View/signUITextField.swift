//
//  signUITextField.swift
//  
//
//  Created by Jobe Diego Dylbas dos Santos on 07/05/19.
//

import UIKit

@IBDesignable
open class signUITextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)
    
    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 18
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open func border(type: String) {
        if type == "warning" {
            self.layer.borderColor = UIColor.red.cgColor
        }
        else {
            self.layer.borderColor = UIColor.clear.cgColor
        }

    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
