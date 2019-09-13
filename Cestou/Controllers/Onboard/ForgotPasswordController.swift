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
        self.emailTextField.delegate = self
        self.styleSignInInputs()
        self.styleSignInBtn()
    }

    private func styleSignInInputs() {
        self.emailTextField.layer.cornerRadius = 18
        self.emailTextField.clipsToBounds = true
    }

    private func styleSignInBtn() {
        self.sendEmailBtn.layer.cornerRadius = 18
        self.sendEmailBtn.clipsToBounds = true
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        if let email = self.emailTextField.text {
            if isValidEmail(testStr: email){
                
                self.view.addSubview(loadingScreen())
                
                DataService.reqPassReset(body: ["email": email], onCompletion:  { result in
                    DispatchQueue.main.async {
                        if let blankScreen = self.view.viewWithTag(4095){
                            blankScreen.removeFromSuperview()
                        }
                    }
                    if let err = result["error"] as? String {
                        print(err)
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Servidor Indisponível 😔", message: "Aguarde e tente novamente.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Email Enviado 😃", message: "Uma mensagem foi enviada para este e-mail, siga as instruções para recuperar sua senha.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            }
            else {
                self.emailTextField.border(type: "warning")
            }
        }
        
    }
}

extension ForgotPassowrdController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.emailTextField.border(type: "normal")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.emailTextField.border(type: "normal")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == .done) {
            sendEmail(textField)
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension ForgotPassowrdController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
