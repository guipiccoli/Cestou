//
//  DetailsViewController.swift
//  Cestou
//
//  Created by Rafael Ferreira on 30/04/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    private let productCellIdentifier = "productCellIdentifier"

    var stringQrCode: String?
    var shopping: Shopping? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        guard let url = stringQrCode else { fatalError() }
        NFScrapper.getShopping(url: url) { (shopping) in
            self.shopping = shopping
            DispatchQueue.main.async {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: productCellIdentifier, for: indexPath) as? ProductTableViewCell else {return UITableViewCell()}
        
        guard let product = shopping?.products[indexPath.row] else {fatalError()}
        cell.productName.text = product.name.lowercased()
        cell.quantity.text = String(product.quantity).lowercased()
        cell.unit.text = String(product.unit).lowercased()
        cell.totalPrice.text = String( (product.unitPrice.rounded()) * (product.quantity.rounded()) ).lowercased()
        
        return cell
    }
}
