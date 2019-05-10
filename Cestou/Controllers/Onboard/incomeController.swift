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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        }
        
    }
}
