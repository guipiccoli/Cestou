//
//  DetailsViewController.swift
//  Cestou
//
//  Created by Rafael Ferreira on 30/04/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {


    @IBOutlet weak var shoppingDateLabel: UILabel!
    @IBOutlet weak var marketplaceNameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var stringQrCode: String?
    var shopping: Shopping? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        let leftColorGradient = UIColor.init(red: 152.0/255, green: 247.0/255, blue: 167.0/255, alpha: 1.0).cgColor
        let rightColorGradient = UIColor.init(red: 7.0/255, green: 208.0/255, blue: 210.0/255, alpha: 1.0).cgColor
        
        gradientLayer.colors = [leftColorGradient,rightColorGradient]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = headerView.bounds
        headerView.layer.insertSublayer(gradientLayer, at: 0)
        
        self.confirmButton.layer.cornerRadius = 26
        self.confirmButton.clipsToBounds = true
        
        
        tableView.delegate = self
        tableView.dataSource = self
        guard let url = stringQrCode else { fatalError() }
        
        self.view.addSubview(loadingScreen())
        
        NFScrapper.getShopping(url: url) { (shopping) in
            self.shopping = shopping
            DispatchQueue.main.async {
                self.marketplaceNameLabel.text = self.shopping?.marketplace.name
                self.marketplaceNameLabel.adjustsFontSizeToFitWidth = true
                
                self.shoppingDateLabel.text = self.shopping?.prettyDate()
                
                
                if let loadView = self.view.viewWithTag(4095){
                    loadView.removeFromSuperview()
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        guard let _shopping = self.shopping else {
            print("shopping structure bad formatting")
            fatalError()
        }
        DataService.saveShopping(shopping: _shopping) { (result) in
            print(result)
        }
    }
    
}


extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.shopping?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCellIdentifier", for: indexPath) as? ProductTableViewCell else {return UITableViewCell()}
        
        guard let product = shopping?.products[indexPath.row] else {fatalError()}
        cell.productName.text = product.name.prefix(1).uppercased() + product.name.lowercased().dropFirst()
        //cell.quantity.text = String(product.quantity).lowercased()
        cell.unit.text = String(format: "%.2f",product.quantity).lowercased() + String(product.unity).lowercased()
        cell.totalPrice.text = "R$" + String(format: "%.2f",(product.unitPrice) * (product.quantity)).lowercased()
        
        return cell
    }
}
