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
    @IBOutlet weak var errorLabel: UILabel!
    
    private var warningField: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullname.delegate = self;
        email.delegate = self;
        password.delegate = self;
        self.styleSignUpBtn()
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    private func styleSignUpBtn() {
        self.signUpBtn.layer.cornerRadius = 18
        self.signUpBtn.clipsToBounds = true
    }
    
    @IBAction func sendBtnClick(_ sender: Any) {
        if !warningField {
            if  let pass = self.password.text,
                let username = self.fullname.text,
                let email = self.email.text {
                
                self.view.addSubview(loadingScreen())
                
                let data: [String: String] = [
                    "username": username,
                    "password": pass,
                    "email": email,
                ]
                
                DataService.reqNewUser(body: data, onCompletion: { result in
                    DispatchQueue.main.async {
                        if let blankScreen = self.view.viewWithTag(4095){
                            blankScreen.removeFromSuperview()
                        }
                    }
                    if result.count != 0 {
                        if let err = result["error"] as? String {
                            print(err)
                            if (result["code"] as? Int) != nil {
                                DispatchQueue.main.async {
                                    self.errorLabel.text = "Usuário já cadastrado."
                                    self.email.border(type: "warning")
                                    self.password.border(type: "warning")
                                    self.fullname.border(type: "warning")
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    self.errorLabel.text = "Servidor indisponível."
                                }
                            }
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
                        DispatchQueue.main.async {
                            self.errorLabel.text = "Servidor indisponível."
                        }
                    }
                })
            }
        }
        else {
            print("Incorrect field.")
            self.email.border(type: "warning")
            self.password.border(type: "warning")
            self.fullname.border(type: "warning")
            self.errorLabel.text = "Os campos estão incorretos."
        }
    }
}

extension SignUpController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let field = textField as? signUITextField{
            field.border(type: "normal")
            self.errorLabel.text = " "
        }
        
        if (textField == self.email) {
            if self.isValidEmail(testStr: textField.text ?? "") {
                self.warningField = false }
            else { self.warningField = true }
        } else {
            if let password = textField.text {
                if password.count < 8 { self.warningField = false }
                else { self.warningField = true }
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? signUITextField{
            field.border(type: "normal")
            self.errorLabel.text = " "
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == .done) {
            sendBtnClick(textField)
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SignUpController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
