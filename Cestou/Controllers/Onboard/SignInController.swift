//
//  SignInController.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 02/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignInController: UIViewController {
    
    @IBOutlet weak var email: signUITextField!
    @IBOutlet weak var password: signUITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var errorText: UILabel!
    
    private var warningField: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self;
        password.delegate = self;
        self.styleSignInBtn()
    }
    
    private func styleSignInBtn() {
        self.signInBtn.layer.cornerRadius = 18
        self.signInBtn.clipsToBounds = true
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    

    @IBAction func signIn(_ sender: Any) {
        if !warningField {
            if let pass = self.password.text,
                let email = self.email.text {
                
                self.view.addSubview(loadingScreen())
                
                DataService.logIn(email: email, password: pass, onCompletion:  { result in
                    DispatchQueue.main.async {
                        if let blankScreen = self.view.viewWithTag(4095){
                            blankScreen.removeFromSuperview()
                        }
                    }
                    if result.count != 0 {
                        if let err = result["error"] as? String {
                            print(err)
                            if let _ = result["code"] as? Int {
                                DispatchQueue.main.async {
                                    self.errorText.text = "Usuário ou senha inválidos."
                                    self.email.border(type: "warning")
                                    self.password.border(type: "warning")
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    self.errorText.text = "Servidor indisponível."
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                guard
                                    let objectId = result["objectId"] as? String,
                                    let sessionToken = result["sessionToken"] as? String,
                                    let username = result["username"] as? String
                                    else {
                                        fatalError()
                                }
                                KeychainWrapper.standard.set(sessionToken, forKey: "sessionToken")
                                KeychainWrapper.standard.set(objectId, forKey: "objectId")
                                KeychainWrapper.standard.set(username, forKey: "username")
                                let defaults = UserDefaults.standard
                                let viewOnboard = defaults.bool(forKey: "viewOnboard")
                                if (!viewOnboard) {
                                    self.performSegue(withIdentifier: "onboard", sender: nil)
                                } else {
                                    self.performSegue(withIdentifier: "toDashboard", sender: nil)
                                }
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.errorText.text = "Servidor indisponível."
                        }
                    }
                })
            }
        }
        else {
            email.border(type: "warning")
            password.border(type: "warning")
            errorText.text = "Os campos estão incorretos."
        }
    }
}

extension SignInController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let field = textField as? signUITextField{
            field.border(type: "normal")
            errorText.text = " "
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
            errorText.text = " "
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == .done) {
            signIn(textField)
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SignInController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
