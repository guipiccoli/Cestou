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
    
    @IBAction func sendEmail(_ sender: Any) {
        if let email = self.emailTextField.text {
            if isValidEmail(testStr: email){
                DispatchQueue.main.async {
                    self.view.addSubview(loadingScreen())
                }
                DataService.reqPassReset(body: ["email": email], onCompletion:  { result in
                    DispatchQueue.main.async {
                        if let blankScreen = self.view.viewWithTag(4095){
                            blankScreen.removeFromSuperview()
                        }
                    }
                    if let err = result["error"] as? String {
                        print(err)
                    }
                    else {
                        DispatchQueue.main.async {
                            print("entroooou 2")
                            let alert = UIAlertController(title: "Email Enviado 😃", message: "Uma mensagem foi enviada para este e-mail, siga as instruções para recuperar sua senha.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            }
            else {
                self.lineColor(view: self.emailTextField, type: "warning")
            }
        }
        
    }
}

extension ForgotPassowrdController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.lineColor(view: textField as! signUITextField, type: "normal")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lineColor(view: textField as! signUITextField, type: "normal")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendEmail(textField)
        return true
    }
}
