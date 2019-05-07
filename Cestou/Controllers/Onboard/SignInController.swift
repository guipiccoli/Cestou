//
//  SignInController.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 02/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    private var warningField: Bool = true
    private var api = CestouAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self;
        password.delegate = self;
        self.styleSignInBtn()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let headerViewController = segue.destination as? HeaderViewController {
            print("DEU CERTO ---------------------")
        }
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
                
                api.logIn(email: email , password: pass, onCompletion:  { result in
                    if result.count != 0 {
                        if let err = result["error"] as? String {
                            print(err)
                        }
                        else {
                            print(result)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "logado", sender: nil)
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

extension SignInController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.email:
            if self.isValidEmail(testStr: textField.text ?? "") { self.warningField = false }
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
}
