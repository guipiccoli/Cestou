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
                DispatchQueue.main.async {
                    self.lineColor(view: self.incomeText, type: "warning")
                    self.errorLabel.text = "O rendimento precisa ser maior que zero."
                }
            }
        }
    }
}


extension incomeController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.lineColor(view: textField as! signUITextField, type: "normal")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lineColor(view: textField as! signUITextField, type: "normal")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goToSpent(textField)
        return true
    }
}
