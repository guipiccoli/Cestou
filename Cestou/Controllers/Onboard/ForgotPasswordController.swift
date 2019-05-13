//
//  SignInController.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 02/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class ForgotPassowrdController: UIViewController {
    
    @IBOutlet weak var emailTextField: signUITextField!
    @IBOutlet weak var sendEmailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleSignInBtn()
    }
    
    private func styleSignInBtn() {
        self.sendEmailBtn.layer.cornerRadius = 26
        self.sendEmailBtn.clipsToBounds = true
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        print("entrouuuu")
        if let email = self.emailTextField.text {
            if isValidEmail(testStr: email){
                
                DataService.reqPassReset(body: ["email": email], onCompletion:  { result in
                    if let err = result["error"] as? String {
                        print(err)
                    }
                    else {
                        DispatchQueue.main.async {
                            print("entroooou 2")
                            let alert = UIAlertController(title: "Email Enviado 😃", message: "Uma mensagem foi enviada para este e-mail, siga as instruções para recurar sua senha.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            }
            
        }
    }
}

extension ForgotPassowrdController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
