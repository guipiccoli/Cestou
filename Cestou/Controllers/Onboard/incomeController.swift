//
//  incomeController.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 09/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class incomeController: UIViewController {
    
    @IBOutlet weak var incomeText: signUITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.incomeText.delegate = self
    }
    
    
    private func isValidIncome(testStr: String) -> Bool {
        let numberRegex = "^[0-9]+$"
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegex)
        
        if numberTest.evaluate(with: testStr) {
            let testStrDouble: Double = Double(testStr) ?? 0.0
            return testStrDouble > 0.0
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let spent = segue.destination as? SpentController,
            let incoming = incomeText.text {
            spent.income = Double(incoming)
        }
    }
    
    @IBAction func goToSpent(_ sender: Any) {
        if let income = incomeText.text{
            if isValidIncome(testStr: income) {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toSpent", sender: nil)
                }
            }
            else {
                self.incomeText.border(type: "warning")
                self.errorLabel.text = "O rendimento precisa ser maior que zero."
            }
        }
    }
}


extension incomeController: UITextFieldDelegate {
    
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
        goToSpent(textField)
        return true
    }
}

extension incomeController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
