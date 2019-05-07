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
    
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    private var warningField: Bool = true    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self;
        password.delegate = self;
        // Do any additional setup after loading the view.
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    @IBAction func sendBtnClick(_ sender: Any) {
        if !warningField {
            if let name = self.fullname.text,
                let pass = self.password.text,
                let username = self.username.text,
                let email = self.email.text {
                
                let data: [String: String] = [
                    "username": username,
                    "password": pass,
                    "email": email,
                    "fullname": name
                ]
                
                DataService.reqNewUser(body: data, onCompletion: { result in
                    if result.count != 0 {
                        if let err = result["error"] as? String {
                            print(err)
                        }
                        else {
                            guard
                                let objectId = result["objectId"] as? String,
                                let sessionToken = result["sessionToken"] as? String,
                                let username = result["username"] as? String
                                else {
                                    print("Error trying to parse Login confirmation response from server")
                                    fatalError()
                            }
                            KeychainWrapper.standard.set(sessionToken, forKey: "token")
                            KeychainWrapper.standard.set(objectId, forKey: "objectId")
                            KeychainWrapper.standard.set(username, forKey: "username")
                            KeychainWrapper.standard.set(true, forKey: "newUserFlag")
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
