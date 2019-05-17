//
//  ViewController.swift
//  Cestou
//
//  Created by Guilherme Piccoli on 26/04/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import CenteredCollectionView
import SwiftKeychainWrapper
class DashboardViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!

    var month: Int = 4
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var totalExpensesLabel: UILabel!
    let cellPercentWidth: CGFloat = 0.2
    let months = ["Janeiro","Fevereiro", "Marco", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
    //var totalExpenses: Double = 0
    var incoming: Double = 0
    var expensesPlanned: Double = 0
    var balances: [Balance]? //Um array contendo os 12 balancos, enumerados de 0 a 11

    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    @IBOutlet weak var graphTableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initializes our collectionViewLayout as a FlowLayout (pod)
        centeredCollectionViewFlowLayout = collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
        
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
        
        graphTableView.dataSource = self
        graphTableView.delegate = self
        
        centeredCollectionViewFlowLayout.itemSize = CGSize (
            width: view.bounds.width * cellPercentWidth,
            height: view.bounds.height * cellPercentWidth * cellPercentWidth)

        centeredCollectionViewFlowLayout.minimumLineSpacing = 40
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        totalExpensesLabel.sizeToFit()
        
        //TESTE DO REQUEST DE DADOS DO SERVIDOR
        let date = Date()
        let calendar = Calendar.current
        self.month = calendar.component(.month, from: date) - 1
        
        
        centeredCollectionViewFlowLayout.scrollToPage(index: month, animated: true)
        DataService.getDashboard { (result: [Balance]?) in
            DispatchQueue.main.async {
                self.balances = result ?? []
                self.refreshDataPerMonth(index: IndexPath(row: self.centeredCollectionViewFlowLayout!.currentCenteredPage ?? self.month, section: 0))
                self.graphTableView.reloadData()
                let totalExpensesRounded = String(format: "%.2f", (result?[self.month].expense)!)
                self.totalExpensesLabel.text = "R$\(totalExpensesRounded)"
            }
        }
        
    }
}

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MonthCollectionViewCell
        cell.monthLabel.text = months[indexPath.row]
        
        //sets the alpha for all the cells to 0.5
        cell.alpha = 0.5
        
        //but makes the centered one with an alpha of 1
        if indexPath.row == month {
            cell.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3) //Resize cell that adjusts to the size of the view
            cell.alpha = 1.0
        }
        
        return cell
    }
}

extension DashboardViewController: UICollectionViewDelegate {
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
        
        refreshDataPerMonth(index: index)

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

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //grafico categoria - gastos por dia - planejamento mensal
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let balances = balances else {return UITableViewCell()}
        if indexPath.row == 0 {
            let categoryCell = graphTableView.dequeueReusableCell(withIdentifier: "Category") as! CategoryTableViewCell
            categoryCell.balanceMonth = self.balances![month]
            categoryCell.configure()
            return categoryCell
        }
        else if indexPath.row == 1 {
            let dailyExpensesCell = graphTableView.dequeueReusableCell(withIdentifier: "DailyExpenses") as! DailyExpensesTableViewCell
            dailyExpensesCell.getMonth = self.month
            dailyExpensesCell.balanceMonth = self.balances![month]
            dailyExpensesCell.configure()
            return dailyExpensesCell
        }
        else if indexPath.row == 2 {
            let monthlyPlanningCell = graphTableView.dequeueReusableCell(withIdentifier: "MonthlyPlanning") as! MonthlyPlanningTableViewCell
            monthlyPlanningCell.balanceMonth = self.balances![month]
            monthlyPlanningCell.configure()
            return monthlyPlanningCell
        }
        else {
            let cell = UITableViewCell()
            return cell
        }
    }
}

extension DashboardViewController {
    
    func refreshDataPerMonth(index: IndexPath) {
        
        let totalExpensesRounded = String(format: "%.2f", (balances![index.row].expense))
        self.totalExpensesLabel.text = "R$\(totalExpensesRounded)"
        self.month = index.row
        self.graphTableView.reloadData()
    }
}
