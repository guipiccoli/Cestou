//
//  ShoppingHistory.swift
//  Cestou
//
//  Created by Eduardo Ribeiro on 13/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import AVFoundation

class ShoppingHistoryController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balance: UILabel!
    private let ShoppingCellIdentifier = "ShoppingCellIdentifier"
    var shoppings: [Shopping] = []
    var monthlyBalance: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        monthlyBalance = shoppings.reduce(0.0) { $0 + $1.balance }
        balance.text = "R$" + String(monthlyBalance)
    }
}

extension ShoppingHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingCellIdentifier, for: indexPath) as? ShoppingTableViewCell else {return UITableViewCell()}
        
        let shopping = shoppings[indexPath.row]
        
        cell.marketplace.text = shopping.marketplace.name
        cell.balance.text = String(shopping.balance)
        cell.date.text = shopping.date

        return cell
    }
    
}
