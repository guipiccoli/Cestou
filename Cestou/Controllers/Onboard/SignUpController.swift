//
//  SingUpController.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 30/04/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignUpController: UIViewController {
    

    @IBOutlet weak var email: signUITextField!
    @IBOutlet weak var fullname: signUITextField!
    @IBOutlet weak var password: signUITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    private var warningField: Bool = true    
    
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
            if  let pass = self.password.text,
                let username = self.fullname.text,
                let email = self.email.text {
                
                let data: [String: String] = [
                    "username": username,
                    "password": pass,
                    "email": email,
                ]
                
                DataService.reqNewUser(body: data, onCompletion: { result in
                    if result.count != 0 {
                        if let err = result["error"] as? String {
                            print(err)
                        }
                        else {
                            DispatchQueue.main.async {
                                guard
                                    let objectId = result["objectId"] as? String,
                                    let sessionToken = result["sessionToken"] as? String
                                    else {
                                        print("Error trying to parse Login confirmation response from server")
                                        fatalError()
                                }
                                KeychainWrapper.standard.set(sessionToken, forKey: "sessionToken")
                                KeychainWrapper.standard.set(objectId, forKey: "objectId")
                                KeychainWrapper.standard.set(username, forKey: "username")
                                KeychainWrapper.standard.set(true, forKey: "newUserFlag")
                                self.performSegue(withIdentifier: "onboard", sender: nil)
                            }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendBtnClick(textField)
        return true
    }
}

extension SignUpController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
