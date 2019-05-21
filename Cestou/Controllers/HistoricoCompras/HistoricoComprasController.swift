//
//  HistoricoComprasController.swift
//  Cestou
//
//  Created by Rafael Ferreira on 14/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import CenteredCollectionView
import SwiftKeychainWrapper
class HistoricoComprasController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var totalExpensesLabel: UILabel!
    
    let cellPercentWidth: CGFloat = 0.2
    let months = ["Janeiro","Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
    var totalExpenses: Double = 0.0
    var month: Int = 4
    var balances: [Balance]?
    var shoppings: [Shopping]?
    
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initializes our collectionViewLayout as a FlowLayout (pod)
        centeredCollectionViewFlowLayout = collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let gradientLayer = CAGradientLayer()
        let leftColorGradient = UIColor.init(red: 152.0/255, green: 247.0/255, blue: 167.0/255, alpha: 1.0).cgColor
        let rightColorGradient = UIColor.init(red: 7.0/255, green: 208.0/255, blue: 210.0/255, alpha: 1.0).cgColor
        
        gradientLayer.colors = [leftColorGradient,rightColorGradient]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = headerView.bounds
        headerView.layer.insertSublayer(gradientLayer, at: 0)
        
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        centeredCollectionViewFlowLayout.itemSize = CGSize (
            width: view.bounds.width * cellPercentWidth,
            height: view.bounds.height * cellPercentWidth * cellPercentWidth)
        
        centeredCollectionViewFlowLayout.minimumLineSpacing = 40
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        var totalExpensesRounded = String(format: "%.2f", totalExpenses) //Arredonda o Double para 2 digitos
        totalExpensesLabel.text = "R$\(totalExpensesRounded)"
        totalExpensesLabel.sizeToFit()
        
        
        let date = Date()
        let calendar = Calendar.current
        self.month = calendar.component(.month, from: date) - 1
        
        centeredCollectionViewFlowLayout.scrollToPage(index: month, animated: true)
        DataService.getDashboard { (result: [Balance]?) in
            DispatchQueue.main.async {
                self.balances = result ?? []
                self.refreshDataPerMonth(index: IndexPath(row: self.centeredCollectionViewFlowLayout!.currentCenteredPage ?? self.month, section: 0))
                let totalExpensesRounded = String(format: "%.2f", (result?[self.month].expense)!)
                self.totalExpensesLabel.text = "R$\(totalExpensesRounded)"
                
                self.shoppings = self.balances?[self.month].monthlyShoppings
                self.tableView.reloadData()
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadGet()
//        DataService.getDashboard { (result: [Balance]?) in
//            DispatchQueue.main.async {
//                
//                print("----------DEU CERTO historico")
//                self.balances = result ?? []
//                self.refreshDataPerMonth(index: IndexPath(row: self.centeredCollectionViewFlowLayout!.currentCenteredPage ?? self.month, section: 0))
//                let totalExpensesRounded = String(format: "%.2f", (result?[self.month].expense)!)
//                self.totalExpensesLabel.text = "R$\(totalExpensesRounded)"
//                
//                self.shoppings = self.balances?[self.month].monthlyShoppings
//                self.tableView.reloadData()
//                
//            }
//        }
    }
    
     func reloadGet() {
        DataService.getDashboard { (result: [Balance]?) in
            DispatchQueue.main.async {
                self.balances = result ?? []
                self.refreshDataPerMonth(index: IndexPath(row: self.centeredCollectionViewFlowLayout!.currentCenteredPage ?? self.month, section: 0))
                let totalExpensesRounded = String(format: "%.2f", (result?[self.month].expense)!)
                self.totalExpensesLabel.text = "R$\(totalExpensesRounded)"
                
                self.shoppings = self.balances?[self.month].monthlyShoppings
                self.tableView.reloadData()
                print(#function)
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //reloadGet()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? HistoricoDetalhesViewController else {return}
        detailVC.shopping = sender as? Shopping
    }
}

extension HistoricoComprasController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MonthCollectionViewCell
        cell.monthLabelHistorico.text = months[indexPath.row]
        
        //sets the alpha for all the cells to 0.5
        cell.alpha = 0.5
        
        //but makes the centered one with an alpha of 1
        if indexPath.row == self.month {
            cell.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3) //Resize cell that adjusts to the size of the view
            cell.alpha = 1.0
        }
        
        return cell
    }
}

extension HistoricoComprasController: UICollectionViewDelegate {
    //Implementa a funcao de clicar para ir ate uma celula vizinha (alternativa ao scroll)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage
        if currentCenteredPage != indexPath.row {
            centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.row, animated: true)
            refreshDataPerMonth(index: indexPath)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let collectionView = collectionView else {return}
        let currentCenteredPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width/2, y: collectionView.contentOffset.y + collectionView.bounds.height/2) //calculates the central cell
        
        guard let index = collectionView.indexPathForItem(at: currentCenteredPoint) else {return}
        
        guard let cellCentered = collectionView.cellForItem(at: index) else { return }
        
        //sets the alpha from the non-centered cells every time the user scrolls
        collectionView.visibleCells.forEach { (cell) in
            cell.transform = CGAffineTransform.identity
            cell.alpha = 0.5
        }
        
        //sets the alpha and size of the centered cell everytime the user scrolls
        cellCentered.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        cellCentered.alpha = 1.0
        
        //refreshDataPerMonth(index: index)
    }
    
    //Centers the collectionView on a cell if the user didnt centered it
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let indexPath = collectionView.indexPathForItem(at: collectionView.center) else {return}
        
        let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage
        if currentCenteredPage != indexPath.row {
            centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.row, animated: true)
        }
        
        refreshDataPerMonth(index: indexPath)
    }
}

extension HistoricoComprasController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoricoComprasCell
        guard let shopping = shoppings else {return cell}
                
        cell.marketplaceCompra.text = shopping[indexPath.row].marketplace.name
        cell.totalCompra.text = String(format: "R$%.2f", (shopping[indexPath.row].cost))
        cell.dataCompra.text = shopping[indexPath.row].prettyDate()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        guard let shopping = shoppings else {return}
        let shoppingAtIndex = shopping[indexPath.row]
        performSegue(withIdentifier: "detailShopping", sender: shoppingAtIndex)
    }
}

extension HistoricoComprasController {
    
    func refreshDataPerMonth(index: IndexPath) {
        
        let totalExpensesRounded = String(format: "%.2f", (balances![index.row].expense))
        
        for item in balances! {
            print(item)
        }
        
        
        self.totalExpensesLabel.text = "R$\(totalExpensesRounded)"
        self.month = index.row
        self.shoppings = self.balances?[self.month].monthlyShoppings
        self.tableView.reloadData()
    }
}
