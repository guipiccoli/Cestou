//
//  DetailsViewController.swift
//  Cestou
//
//  Created by Rafael Ferreira on 30/04/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {


    
    @IBOutlet var expensesInteger: UILabel!
    @IBOutlet var expensesDecimal: UILabel!
    @IBOutlet weak var shoppingDateLabel: UILabel!
    @IBOutlet weak var marketplaceNameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var totalExpensesLabel: UILabel!
    
    var stringQrCode: String?
    var shopping: Shopping? = nil
    
    
    static var didConfirm = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func confirmScanButton(_ sender: UIButton) {
        guard let _shopping = self.shopping else {
            print("shopping structure bad formatting")
            fatalError()
        }
        
        self.view.addSubview(loadingScreen())
        
        DispatchQueue.main.async {
            DataService.saveShopping(shopping: _shopping) { (result) in
                print(result)
                DetailsViewController.didConfirm = true
                self.dismiss(animated: true, completion: nil)
                
                if let loadView = self.view.viewWithTag(4095){
                    loadView.removeFromSuperview()
                }
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = UIImageView()
        background.image = UIImage(named: "BG")
        background.frame = self.view.frame
        
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
        

        tableView.delegate = self
        tableView.dataSource = self
        guard let url = stringQrCode else { fatalError() }
        
        self.view.addSubview(loadingScreenWhite())
        
        NFScrapper.getShopping(url: url) { (shopping) in
            self.shopping = shopping
            DispatchQueue.main.async {
                self.marketplaceNameLabel.text = self.shopping?.marketplace.name
                self.marketplaceNameLabel.adjustsFontSizeToFitWidth = true
                //self.expensesInteger.text = "R$\(String(floor(self.shopping?.cost ?? 0.0)))"
                self.expensesInteger.text = "R$\(String(format: "%.0f", floor(self.shopping?.cost ?? 0.0)))"
                
                let totalExpensesRounded = floor(self.shopping?.cost ?? 0.0)
                let totalExpensesDecimal = (((self.shopping?.cost ?? 0.0) - totalExpensesRounded) * 100)
                print("EXPENSES DECIMAL: \(totalExpensesDecimal)")
                
                self.expensesDecimal.text =  String(format: ",%02.0f", totalExpensesDecimal)
                self.shoppingDateLabel.text = self.shopping?.prettyDate()
                self.totalExpensesLabel.text = "R$\(String(format: "%.2f", self.shopping?.cost ?? 0.0))"
                
                
                if let loadView = self.view.viewWithTag(4095){
                    loadView.removeFromSuperview()
                }
                self.tableView.reloadData()
            }
        }
    }
}


extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.shopping?.products.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == 0 {
//            return ProductTableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        }
        
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "productCellIdentifierGray", for: indexPath) as? ProductTableViewCell else {return UITableViewCell()}
        
        if(indexPath.row % 2 == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "productCellIdentifier", for: indexPath) as? ProductTableViewCell ?? UITableViewCell() as! ProductTableViewCell
        }

        
        
        guard let product = shopping?.products[indexPath.row] else {fatalError()}
        cell.productName.text = product.name.prefix(1).uppercased() + product.name.lowercased().dropFirst()
        //cell.quantity.text = String(product.quantity).lowercased()
        cell.unit.text = String(format: "%.2f",product.quantity).lowercased() + String(product.unit).lowercased()
        cell.totalPrice.text = "R$" + String(format: "%.2f",(product.unitPrice) * (product.quantity)).lowercased()
        cell.unitPrice.text = "R$" + String(format: "%.2f",(product.unitPrice))
        return cell
    }
}
