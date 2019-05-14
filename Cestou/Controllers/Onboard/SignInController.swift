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
        self.signInBtn.layer.cornerRadius = 26
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
                
                DispatchQueue.main.async {
                    self.view.addSubview(loadingScreen())
                }
                
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
                                    self.lineColor(view: self.email, type: "warning")
                                    self.lineColor(view: self.password, type: "warning")
                                }
                            }
                        }
                        else {
                            print(result)
                            DispatchQueue.main.async {
                                guard
                                    let objectId = result["objectId"] as? String,
                                    let sessionToken = result["sessionToken"] as? String,
                                    let username = result["username"] as? String
                                    else {
                                        print("Error trying to parse Login confirmation response from server")
                                        fatalError()
                                }
                                KeychainWrapper.standard.set(sessionToken, forKey: "sessionToken")
                                KeychainWrapper.standard.set(objectId, forKey: "objectId")
                                KeychainWrapper.standard.set(username, forKey: "username")
                                self.performSegue(withIdentifier: "toDashboard", sender: nil)
                            }
                        }
                    }
                    else {
                        print("Usuário já existe.")
                    }
                })
            }
        }
        else {
            print("Incorrect field.")
            self.lineColor(view: self.email, type: "warning")
            self.lineColor(view: self.password, type: "warning")
        }
    }
    
    private func lineColor(view: signUITextField, type: String) {
        DispatchQueue.main.async {
            _ = view.layer.sublayers?.map {
                if $0.name == "border" {
                    if type == "warning"{
                        $0.borderColor = UIColor.red.cgColor
                    }
                    else{
                        $0.borderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
//                        self.errorLabel.text = ""
                    }
                }
            }
        }
    }
}

extension SignInController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.lineColor(view: textField as! signUITextField, type: "normal")
        switch textField {
        case self.email:
            if self.isValidEmail(testStr: textField.text ?? "") {
                self.warningField = false }
            else { self.warningField = true }
        case self.password:
            if let password = textField.text {
                if password.count < 8 { self.warningField = false }
                else { self.warningField = true }
            }
        default:
            print("default")
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lineColor(view: textField as! signUITextField, type: "normal")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signIn(textField)
        return true
    }
}
