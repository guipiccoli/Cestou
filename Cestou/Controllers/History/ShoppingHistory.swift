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
    var monthlyBalance: Double = 0.0
    var month = "May"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DataService.getShopping(month: month) { (balance) in
            guard let _balance = balance else {
                fatalError()
            }
            self.monthlyBalance = -_balance.expense
            guard let _shoppings = balance?.monthlyShoppings else {
                return
            }
            self.shoppings = _shoppings
            self.balance.text = "R$" + String(self.monthlyBalance)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        cell.balance.text = String(shopping.cost)
        cell.date.text = shopping.date

        return cell
    }
    
}
