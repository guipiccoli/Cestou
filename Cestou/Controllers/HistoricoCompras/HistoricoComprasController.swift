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

enum StatesVisibility {
    case noData
    case readyData
}

class HistoricoComprasController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var totalExpensesLabel: UILabel!
    @IBOutlet weak var totalExpensesDecimal: UILabel!
    @IBOutlet weak var noDataText: UILabel!
    var screenState: StatesVisibility = .noData {
        didSet {
            switch screenState {
            case .noData:
                tableView.isHidden = true
                noDataText.isHidden = false
            case .readyData:
                tableView.isHidden = false
                noDataText.isHidden = true
            }
        }
    }
    
    let cellPercentWidth: CGFloat = 0.2
    let months = ["Janeiro","Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
    var totalExpenses: Double = 0.0
    var month: Int = 4
    var balances: [Balance]?
    var shoppings: [Shopping]?
    var currentCenteredPage: Int?

    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        //initializes our collectionViewLayout as a FlowLayout (pod)
        centeredCollectionViewFlowLayout = collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
//        let backgroundHeader = UIImageView()
//        backgroundHeader.frame = self.view.frame
//        backgroundHeader.image = UIImage(named: "BG")
//        
//        self.view.addSubview(backgroundHeader)
//        self.view.sendSubviewToBack(backgroundHeader)
        
        
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast

        collectionView.delegate = self
        collectionView.dataSource = self
        
        centeredCollectionViewFlowLayout.itemSize = CGSize (
            width: view.bounds.width * cellPercentWidth,
            height: view.bounds.height * cellPercentWidth * cellPercentWidth)
        
        centeredCollectionViewFlowLayout.minimumLineSpacing = 40

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        let _roundedExpense = totalExpenses.rounded(.down)
        let decimals = totalExpenses - _roundedExpense
        let totalExpensesRounded = String(Int(_roundedExpense))
        
        self.totalExpensesDecimal.text = "," + String(decimals*1000).replacingOccurrences(of: ".", with: "").prefix(2)
        totalExpensesLabel.text = "R$\(totalExpensesRounded)"
        totalExpensesLabel.sizeToFit()
        
        
        let date = Date()
        let calendar = Calendar.current
        self.month = calendar.component(.month, from: date) - 1
    
        centeredCollectionViewFlowLayout.scrollToPage(index: self.month, animated: false)
        DataService.getDashboard { (result: [Balance]?) in
            DispatchQueue.main.async {
                self.centeredCollectionViewFlowLayout.scrollToPage(index: self.month, animated: false)

                self.balances = result ?? []
                self.refreshDataPerMonth(index: IndexPath(row: self.centeredCollectionViewFlowLayout!.currentCenteredPage ?? self.month, section: 0))
                
                let _roundedExpense = (result?[self.month].expense)!.rounded(.down)
                let decimals = (result?[self.month].expense)! - _roundedExpense
                let totalExpensesRounded = String(Int(_roundedExpense))
                
                self.totalExpensesDecimal.text = "," + String(decimals*1000).replacingOccurrences(of: ".", with: "").prefix(2)
                self.totalExpensesLabel.text = "R$\(totalExpensesRounded)"
                
                
                self.shoppings = self.balances?[self.month].monthlyShoppings?.sorted( by: { $0 > $1 })
                
                if let shoppings = self.shoppings, shoppings.isEmpty {
                    self.screenState = .noData
                } else {
                    self.screenState = .readyData
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadGet()
        print(#function)

    }
    
     func reloadGet() {
        DataService.getDashboard { (result: [Balance]?) in
            DispatchQueue.main.async {
                self.balances = result ?? []
                self.refreshDataPerMonth(index: IndexPath(row: self.centeredCollectionViewFlowLayout!.currentCenteredPage ?? self.month, section: 0))

                let _roundedExpense = (result?[self.month].expense)!.rounded(.down)
                let decimals = (result?[self.month].expense)! - _roundedExpense
                let totalExpensesRounded = String(Int(_roundedExpense))
                
                self.totalExpensesDecimal.text = "," + String(decimals*1000).replacingOccurrences(of: ".", with: "").prefix(2)
                self.totalExpensesLabel.text = "R$\(totalExpensesRounded)"
                
                self.shoppings = self.balances?[self.month].monthlyShoppings?.sorted( by: { $0 > $1 })
                
                if let shoppings = self.shoppings, shoppings.isEmpty {
                    self.screenState = .noData
                } else {
                    self.screenState = .readyData
                    self.tableView.reloadData()
                }
                
//                self.headerView.isAccessibilityElement = true
//
//                self.headerView.accessibilityLabel = "Mês atual do balanço \(self.months[self.month]). Gasto mensal \(self.totalExpensesLabel.text!) e \(self.totalExpensesDecimal.text!) centavos"
                
                
                //print(#function)
                
            }
        }
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newCurrentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage
        if self.currentCenteredPage != newCurrentCenteredPage {
            let currentCenteredPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width/2, y: collectionView.contentOffset.y + collectionView.bounds.height/2)
            guard let indexPath = collectionView.indexPathForItem(at: currentCenteredPoint) else {return}
            refreshDataPerMonth(index: indexPath)
        }
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
        guard var shopping = shoppings else {return cell}
        
        cell.marketplaceCompra.text = shopping[indexPath.row].marketplace.name
        cell.totalCompra.text = String(format: "Total: R$%.2f", (shopping[indexPath.row].cost))
        cell.dataCompra.text = shopping[indexPath.row].prettyDate()
        
        //Acessibility settings
//        cell.marketplaceCompra.isAccessibilityElement = true
//        cell.totalCompra.isAccessibilityElement = true
//        cell.dataCompra.isAccessibilityElement = true
        cell.isAccessibilityElement = true
        let valorLegivel = cell.dataCompra.text?.components(separatedBy: "/")
        cell.accessibilityLabel = "Compra realizada no mercado \(cell.marketplaceCompra.text!), com o valor \(cell.totalCompra.text!), no dia \(valorLegivel![0]) de \(months[Int(valorLegivel![1])! - 1]) de \(valorLegivel![2])"
        cell.dataCompra.accessibilityLanguage = "pt-BR"
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
        
        
        let _roundedExpense = (balances![index.row].expense).rounded(.down)
        let decimals = (balances![index.row].expense) - _roundedExpense
        let totalExpensesRounded = String(Int(_roundedExpense))
        
        self.totalExpensesDecimal.text = "," + String(decimals*1000).replacingOccurrences(of: ".", with: "").prefix(2)
        self.totalExpensesLabel.text = "R$\(totalExpensesRounded)"
        
        for item in balances! {
            print(item)
        }
        
        
        self.month = index.row
        self.shoppings = self.balances?[self.month].monthlyShoppings?.sorted(by: { $0 > $1 } )
        
        if let shoppings = self.shoppings, shoppings.isEmpty {
            self.screenState = .noData
        } else {
            self.screenState = .readyData
            self.tableView.reloadData()
        }
    }
}
