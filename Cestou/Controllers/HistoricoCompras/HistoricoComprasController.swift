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
    let months = ["Janeiro","Fevereiro", "Marco", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
    
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
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
        totalExpensesLabel.text = "R$\(1500)"
        totalExpensesLabel.sizeToFit()
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
        if indexPath.row == 0 {
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
    }
    
    //Centers the collectionView on a cell if the user didnt centered it
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let indexPath = collectionView.indexPathForItem(at: collectionView.center) else {return}
        
        let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage
        if currentCenteredPage != indexPath.row {
            centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.row, animated: true)
        }
    }
}

extension HistoricoComprasController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //grafico categoria - gastos por dia - planejamento mensal
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoricoComprasCell
        return cell
        
    }
}
