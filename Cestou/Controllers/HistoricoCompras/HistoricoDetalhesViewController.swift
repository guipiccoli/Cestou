//
//  HistoricoDetalhesViewController.swift
//  Cestou
//
//  Created by Guilherme Piccoli on 17/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class HistoricoDetalhesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var expensesInteger: UILabel!
    @IBOutlet var expensesDecimal: UILabel!
    @IBOutlet var marketplaceNameLabel: UILabel!
    @IBOutlet var shoppingDateLabel: UILabel!
    @IBOutlet var totalExpensesLabel: UILabel!
    
    var shopping: Shopping?
    
    
    static var didConfirm = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(shopping)
        //adding the background image
        let background = UIImageView()
        background.image = UIImage(named: "BG")
        background.frame = self.view.frame
        
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
        
        marketplaceNameLabel.text = shopping?.marketplace.name
        marketplaceNameLabel.adjustsFontSizeToFitWidth = true
        //self.expensesInteger.text = "R$\(String(floor(self.shopping?.cost ?? 0.0)))"
        self.expensesInteger.text = "R$\(String(format: "%.0f", floor(self.shopping?.cost ?? 0.0)))"
        
        let totalExpensesRounded = floor(self.shopping?.cost ?? 0.0)
        let totalExpensesDecimal = (((self.shopping?.cost ?? 0.0) - totalExpensesRounded) * 100)
        print("EXPENSES DECIMAL: \(totalExpensesDecimal)")
        
        self.expensesDecimal.text =  String(format: ",%02.0f", totalExpensesDecimal)
        self.shoppingDateLabel.text = self.shopping?.prettyDate()
        self.totalExpensesLabel.text = "R$\(String(format: "%.2f", self.shopping?.cost ?? 0.0))"

        tableView.delegate = self
        tableView.dataSource = self
        
    }
}


extension HistoricoDetalhesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.shopping?.products.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "productCellIdentifierGray", for: indexPath) as? ProductTableViewCell else {return UITableViewCell()}
        
        if(indexPath.row % 2 == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "productCellIdentifier", for: indexPath) as? ProductTableViewCell ?? UITableViewCell() as! ProductTableViewCell
        }
        
        guard let product = shopping?.products[indexPath.row] else {fatalError()}
        cell.productName.text = product.name.prefix(1).uppercased() + product.name.lowercased().dropFirst()
        //cell.quantity.text = String(product.quantity).lowercased()
        var _quantity: String
        if product.unit == "UN" {
            _quantity = String(Int(product.quantity))
        }
        else {
            _quantity = String(format: "%.2f", product.quantity)
        }
        cell.unit.text = _quantity.lowercased() + String(product.unit).lowercased()
        cell.totalPrice.text = "R$" + String(format: "%.2f",(product.unitPrice) * (product.quantity)).lowercased()
        cell.unitPrice.text = "R$" + String(format: "%.2f",(product.unitPrice))
        return cell
    }
}
