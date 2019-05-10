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
    var income: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    @IBAction func goToDashboard(_ sender: Any) {
        if let spentText = spent.text,
            let _ = income {
            if isValidSpent(testStr: spentText) {
                
                let newBalance: [String: Double] = ["incoming": self.income ?? 0.0, "expenseProjected": Double(spentText) ?? 0.0]
                
                DataService.saveBalance(body: newBalance, onCompletion: { result in
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
        }
    }
    
    
}
