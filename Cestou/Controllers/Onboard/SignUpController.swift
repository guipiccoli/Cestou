//
//  SingUpController.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 30/04/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    

    @IBOutlet weak var email: signUITextField!
    @IBOutlet weak var fullname: signUITextField!
    @IBOutlet weak var password: signUITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    private var warningField: Bool = true    
    private let api = CestouAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self;
        password.delegate = self;
        self.styleSignUpBtn()
        // Do any additional setup after loading the view.
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    private func styleSignUpBtn() {
        self.signUpBtn.layer.cornerRadius = 26
        self.signUpBtn.clipsToBounds = true
    }
    
    @IBAction func sendBtnClick(_ sender: Any) {
        if !warningField {
            if let name = self.fullname.text,
                let pass = self.password.text,
                let username = self.fullname.text,
                let email = self.email.text {
                
                let data: [String: String] = [
                    "username": username,
                    "password": pass,
                    "email": email,
                    "fullname": name
                ]
                
                api.reqNewUser(body: data, onCompletion: { result in
                    if result.count != 0 {
                        if let err = result["error"] as? String {
                            print(err)
                        }
                        else {
                            print(result)
                        }
                    }
                    else {
                        print("User not created. Unknow error.")
                    }
                })
            }
        }
        else {
            print("Incorrect field.")
        }
    }

}

extension SignUpController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.email:
            if self.isValidEmail(testStr: textField.text ?? "") { self.warningField = false }
            else { self.warningField = true }
        case self.password:
            if let pass = textField.text {
                if pass.count < 8 { self.warningField = false }
                else { self.warningField = true }
            }
        default:
            print("default")
        }
        return true
    }
}
