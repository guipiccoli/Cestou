//
//  SingUpController.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 30/04/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    private var warningField: Bool = true
    var response: [String: Any]?
    
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
    
    func reqNewUser( body : [String: String], onCompletion: @escaping (_ result: [String:Any]) -> Void) {
        let url = URL(string: "https://parseapi.back4app.com/users")!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        
        request.setValue("BUocb5yrgLRYaBj6MAJv79lnkjupls9U1tZXwK74", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("fhqaBdHbm66HuuVirZX4lAdtTCQEGOyRTEqIGkJm", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return onCompletion(["error": "Error parsing data json."])
            
        }
        
        session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return onCompletion(["error": "No response."])
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    return onCompletion(json)
                }
            } catch let error {
                print(error.localizedDescription)
                return onCompletion( ["error": "Error parsing response json."])
                
            }
        }).resume()
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
                
                reqNewUser(body: data, onCompletion: { result in
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
