//
//  HistoricoDetalhesViewController.swift
//  Cestou
//
//  Created by Guilherme Piccoli on 17/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class HistoricoDetalhesViewController: UIViewController {

  
    @IBOutlet weak var totalExpense: UILabel!
    @IBOutlet weak var shoppingDateLabel: UILabel!
    @IBOutlet weak var marketplaceNameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
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
        let gradientLayer = CAGradientLayer()
        let leftColorGradient = UIColor.init(red: 152.0/255, green: 247.0/255, blue: 167.0/255, alpha: 1.0).cgColor
        let rightColorGradient = UIColor.init(red: 7.0/255, green: 208.0/255, blue: 210.0/255, alpha: 1.0).cgColor
        
        gradientLayer.colors = [leftColorGradient,rightColorGradient]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = headerView.bounds
        headerView.layer.insertSublayer(gradientLayer, at: 0)
        
        marketplaceNameLabel.text = shopping?.marketplace.name
        marketplaceNameLabel.adjustsFontSizeToFitWidth = true

        tableView.delegate = self
        tableView.dataSource = self
        
    }
}


extension HistoricoDetalhesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.shopping?.products.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCellIdentifier", for: indexPath) as? ProductTableViewCell else {return UITableViewCell()}
        
        guard let product = shopping?.products[indexPath.row-1] else {fatalError()}
        cell.productName.text = product.name.prefix(1).uppercased() + product.name.lowercased().dropFirst()
        //cell.quantity.text = String(product.quantity).lowercased()
        cell.unit.text = String(format: "%.2f",product.quantity).lowercased() + String(product.unit).lowercased()
        cell.totalPrice.text = "R$" + String(format: "%.2f",(product.unitPrice) * (product.quantity)).lowercased()
        
        return cell
    }
}
