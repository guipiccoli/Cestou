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
                return (testStrDouble <= incoming && testStrDouble >= 0)
            }
        }
        return false
    }
    
    @IBAction func goToDashboard(_ sender: Any) {
        if let spentText = spent.text,
            let _ = income {
            if isValidSpent(testStr: spentText) {
                
                self.view.addSubview(loadingScreen())
                
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
                            DispatchQueue.main.async {
                                self.errorLabel.text = "Servidor indisponível."
                                self.spent.border(type: "warning")
                            }
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
                self.spent.border(type: "warning")
                self.errorLabel.text = "O Gasto Projetado deve ser menor que o Rendimento."
            }
        }
    }
}

extension SpentController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let field = textField as? signUITextField{
            field.border(type: "normal")
            self.errorLabel.text = " "
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
        goToDashboard(textField)
        return true
    }
}
