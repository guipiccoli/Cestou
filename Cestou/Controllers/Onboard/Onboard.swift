//
//  Onboard.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 22/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class OnboardController: UIViewController {
    
    let mainImageString: [String] = ["welcome", "income", "spent"]
    let ballsImage: [String] = ["balls1", "balls2", "balls3"]
    let titleText: [String] = ["Bem-vindo", "Rendimento", "Gasto Projetado"]
    private var balance: [String: Double] = ["incoming": 0.0, "expenseProjected": 0.0]
    
    @IBOutlet weak var collView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collView.delegate = self
        self.collView.dataSource = self
        
        self.collView?.didMoveToSuperview()
        
        if let indexPath: [IndexPath] = self.collView?.indexPathsForVisibleItems {
            print(indexPath)
//            let cell = self.collView.cellForItem(at: indexPath[0]) as? OnboardCollectionViewCell
//            cell?.inputTextField.delegate = self
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.view.endEditing(true)
    }
    
    private func backEndScroll() {
        if let indexPath: [IndexPath] = self.collView?.indexPathsForVisibleItems {
            var newIndexPath: IndexPath = IndexPath(row: indexPath[0].row, section: indexPath[0].section)
            let realCell = self.collView.cellForItem(at: indexPath[0]) as? OnboardCollectionViewCell
            
            switch indexPath[0].row {
            case 0:
                newIndexPath = IndexPath(row: indexPath[0].row+1, section: indexPath[0].section)
                self.collView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
            case 1:
                if let cell = self.collView.visibleCells[0] as? OnboardCollectionViewCell,
                    cell.inputTextField.text != "" {
                    let input = cell.inputTextField.text ?? ""
                    if let inputDouble = Double(input) {
                        if inputDouble >= 0 {
                            self.balance["incoming"] = inputDouble
                            
                            realCell?.errorLabel.text = " "
                            
                            newIndexPath = IndexPath(row: indexPath[0].row+1, section: indexPath[0].section)
                            self.collView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
                        }
                        else {
                            realCell?.errorLabel.text = "O rendimento deve ser maior ou igual a zero."
                        }
                    }
                }
                else {
                    realCell?.errorLabel.text = "O valor não pode ser nulo."
                }
                
            case 2:
                if let cell = self.collView.visibleCells[0] as? OnboardCollectionViewCell,
                    cell.inputTextField.text != "" {
                    let input = cell.inputTextField.text ?? "0"
                    if let inputDouble = Double(input) {
                        if inputDouble <= self.balance["incoming"] ?? 0.0 && inputDouble >= 0.0{
                            self.balance["expenseProjected"] = inputDouble
                            
                            self.view.addSubview(loadingScreen())
                            
                            DataService.saveBalance(body: balance, onCompletion: { result in
                                DispatchQueue.main.async {
                                    if let blankScreen = self.view.viewWithTag(4095){
                                        blankScreen.removeFromSuperview()
                                    }
                                }
                                if result.count != 0 {
                                    if let err = result["error"] as? String {
                                        print(err)
                                        DispatchQueue.main.async {
                                            realCell?.errorLabel.text = "Servidor indisponível"
                                        }
                                    }
                                    else {
                                        print(result)
                                        DispatchQueue.main.async {
                                            self.performSegue(withIdentifier: "toMain", sender: nil)
                                        }
                                    }
                                }
                            })
                        }
                        else {
                            if inputDouble >= 0.0 {
                                realCell?.errorLabel.text = "O valor deve ser menor ou igual ao Rendimento."
                                realCell?.inputTextField.border(type: "warning")
                            }
                            else {
                                realCell?.errorLabel.text = "O valor não pode ser menor que zero."
                                realCell?.inputTextField.border(type: "warning")
                            }
                        }
                    }
                }
                else {
                    if let realCell = self.collView.cellForItem(at: indexPath[0]) as? OnboardCollectionViewCell {
                        realCell.errorLabel.text = "O valor não deve ser nulo."
                        realCell.inputTextField.border(type: "warning")
                    }
                }
            default:
                break
            }
        }
        print(self.balance)
    }
    
    @IBAction func scrollRightAction(_ sender: Any) {
        backEndScroll()
    }
  
    @IBAction func backScrollAction(_ sender: Any) {
        if let indexPath: [IndexPath] = self.collView?.indexPathsForVisibleItems {
            let newIndexPath: IndexPath = IndexPath(row: indexPath[0].row-1, section: indexPath[0].section)
            self.collView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension OnboardController: UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as! OnboardCollectionViewCell
        
        cell.symbolImage.image = UIImage(named: self.mainImageString[indexPath.row])
        cell.titleLabel.text = self.titleText[indexPath.row]
        cell.ballsImage.image = UIImage(named: self.ballsImage[indexPath.row])
        
        if indexPath.row == 0 {
            cell.errorLabel.isHidden = true
            cell.inputTextField.isHidden = true
            cell.backBtn.isHidden = true
        }
        else {
            cell.inputTextField.placeholder = self.titleText[indexPath.row]
            cell.errorLabel.text = " "
            cell.inputTextField.delegate = self
        }
        
        return cell
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let indexPath: [IndexPath] = self.collView?.indexPathsForVisibleItems,
            let realCell = self.collView.cellForItem(at: indexPath[0]) as? OnboardCollectionViewCell {
            realCell.inputTextField.border(type: "normal")
            realCell.errorLabel.text = " "
        }
            return true
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let indexPath: [IndexPath] = self.collView?.indexPathsForVisibleItems,
            let realCell = self.collView.cellForItem(at: indexPath[0]) as? OnboardCollectionViewCell {
                realCell.inputTextField.border(type: "normal")
                realCell.errorLabel.text = " "
            }
    }
    
}
