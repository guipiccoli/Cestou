//
//  CategoryTableViewCell.swift
//  Cestou
//
//  Created by Rafael Ferreira on 07/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import Charts

enum PieChartColors {
    static let blue = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
    static let yellow = UIColor(red: 255/255, green: 232/255, blue: 81/255, alpha: 1)
    static let purple = UIColor(red: 234/255, green: 158/255, blue: 251/255, alpha: 1)
    static let red = UIColor(red: 255/255, green: 117/255, blue: 117/255, alpha: 1)
    static let green = UIColor(red: 44/255, green: 203/255, blue: 135/255, alpha: 1)
}

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var noDataText: UILabel!
    @IBOutlet var backgroundCardView: UIView!
    @IBOutlet weak var categoryChart: PieChartView!
    var balanceMonth: Balance?
    var categories: [String: Double] = [:]
    var mockGet: [String: Double] = ["Categoria 1":200.00, "Categoria 2":430.00, "Categoria 3":100.00, "Categoria 4":179.00,"Categoria 5":179.00]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCardView.layer.cornerRadius = 16
        backgroundCardView.layer.borderWidth = 0.5
        backgroundCardView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundCardView.layer.masksToBounds = false
        noDataText.isHidden = true
    }
    
    func configure() {
        var categoriesA: [String] = []
        var valueSpent: [Double] = []
        
        self.categories = [:]
        
        if let _balanceMonth = self.balanceMonth, let shoppings = _balanceMonth.monthlyShoppings {
            for nota in shoppings {
                for item in nota.products {
                    if categories[item.productCategory.name] != nil {
                        self.categories[item.productCategory.name]! += (item.unitPrice * item.quantity)
                    }
                    else {
                        self.categories[item.productCategory.name] = (item.unitPrice * item.quantity)
                    }
                }
            }
        }
        
        var categoriesSort = categories.sorted(by: {$0.value > $1.value})
        
        //print(categories)
        
        for entry in categoriesSort {
            categoriesA.append( "\(entry.key): R$ \(String(format: "%.2f", entry.value))")
            valueSpent.append(entry.value)
        }
        
        setChart(dataPoints: categoriesA, values: valueSpent)
        if categories.count == 0 {
            noDataText.isHidden = false
        }
        else {
            noDataText.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        var categoryChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        let categoryChartData = PieChartData(dataSet: categoryChartDataSet)
        
        var colors: [UIColor] = [PieChartColors.blue, PieChartColors.red, PieChartColors.yellow, PieChartColors.purple, PieChartColors.green] //receber as cores definidas pelo Leo no processo de design
        

        categoryChart.drawEntryLabelsEnabled = false
        categoryChart.highlightPerTapEnabled = false
        categoryChartDataSet.colors = colors
        categoryChart.notifyDataSetChanged()
        
        
        categoryChart.legend.font = UIFont.systemFont(ofSize: 16)
        categoryChart.legend.orientation = .vertical
        categoryChart.legend.verticalAlignment = .center
        categoryChart.legend.horizontalAlignment = .right
        categoryChart.data = categoryChartData
        

        categoryChartDataSet.drawValuesEnabled = false
        
        categoryChart.animate(yAxisDuration: 1)
        categoryChart.rotationAngle = 270
    }
}
