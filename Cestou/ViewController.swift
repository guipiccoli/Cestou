//
//  ViewController.swift
//  Cestou
//
//  Created by Guilherme Piccoli on 26/04/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import CenteredCollectionView

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!

    
    let cellPercentWidth: CGFloat = 0.7
    
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        centeredCollectionViewFlowLayout = collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
        
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        centeredCollectionViewFlowLayout.itemSize = CGSize (
            width: view.bounds.width * cellPercentWidth,
            height: view.bounds.height * cellPercentWidth * cellPercentWidth)
        
        centeredCollectionViewFlowLayout.minimumLineSpacing = 20
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        
        
    }



}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MonthCollectionViewCell
        cell.monthLabel.text = "Maio"
        print(cell.monthLabel.text)
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage
        if currentCenteredPage != indexPath.row {
            centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.row, animated: true)
        }
    }
}
