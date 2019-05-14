//
//  incomeController.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 09/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class SpentController: UIViewController {

    @IBOutlet weak var spent: signUITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var income: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spent.delegate = self
    }
    
    private func isValidSpent(testStr: String) -> Bool {
        let numberRegex = "^[0-9]+$"
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegex)
        
        if numberTest.evaluate(with: testStr) {
            let testStrDouble: Double = Double(testStr) ?? 0.0
            if let incoming: Double = self.income {
                return testStrDouble <= incoming
            }
        }
        return false
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
                        self.errorLabel.text = " "
                    }
                }
            }
        }
    }
    
    @IBAction func goToDashboard(_ sender: Any) {
        if let spentText = spent.text,
            let _ = income {
            if isValidSpent(testStr: spentText) {
                DispatchQueue.main.async {
                    self.view.addSubview(loadingScreen())
                }
                let newBalance: [String: Double] = ["incoming": self.income ?? 0.0, "expenseProjected": Double(spentText) ?? 0.0]
                
                DataService.saveBalance(body: newBalance, onCompletion: { result in
                    DispatchQueue.main.async {
                        if let blankScreen = self.view.viewWithTag(4095){
                            blankScreen.removeFromSuperview()
                        }
                    }
                    if result.count != 0 {
                        if let err = result["error"] as? String {
                            print(err)
                        }
                        else {
                            print(result)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "toDashboard", sender: nil)
                            }
                        }
                    }
                })
            }
            else {
                DispatchQueue.main.async {
                    self.lineColor(view: self.spent, type: "warning")
                    self.errorLabel.text = "O rendimento precisa ser maior que zero."
                }
            }
        }
    }
}

extension SpentController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.lineColor(view: textField as! signUITextField, type: "normal")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lineColor(view: textField as! signUITextField, type: "normal")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goToDashboard(textField)
        return true
    }
}
