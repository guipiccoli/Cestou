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
    static let lightBlue = UIColor(red: 140/255, green: 235/255, blue: 255/255, alpha: 1)
    static let lightOrange = UIColor(red: 255/255, green: 210/255, blue: 139/255, alpha: 1)
    static let lightYellow = UIColor(red: 255/255, green: 247/255, blue: 140/255, alpha: 1)
    static let lightGreen = UIColor(red: 197/255, green: 255/255, blue: 139/255, alpha: 1)
    static let lightSalmon = UIColor(red: 232/255, green: 116/255, blue: 143/255, alpha: 1)
}

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var backgroundCardView: UIView!
    @IBOutlet weak var categoryChart: PieChartView!
    var mockGet: [String: Double] = ["Categoria 1":200.00, "Categoria 2":430.00, "Categoria 3":100.00, "Categoria 4":179.00,"Categoria 5":179.00]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCardView.layer.cornerRadius = 12
        backgroundCardView.layer.borderWidth = 0.5
        backgroundCardView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundCardView.layer.masksToBounds = false
        
    }
    
    func configure() {
        var categories: [String] = []
        var valueSpent: [Double] = []
        
        
        for entry in mockGet {
            categories.append( "\(entry.key): R$ \(entry.value)")
            valueSpent.append(entry.value)
        }
        
        setChart(dataPoints: categories, values: valueSpent)
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
        
        let categoryChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        let categoryChartData = PieChartData(dataSet: categoryChartDataSet)
        
        var colors: [UIColor] = [PieChartColors.lightBlue, PieChartColors.lightGreen, PieChartColors.lightOrange, PieChartColors.lightYellow, PieChartColors.lightSalmon] //receber as cores definidas pelo Leo no processo de design
        
        
        categoryChart.drawEntryLabelsEnabled = false
        categoryChart.highlightPerTapEnabled = false
        categoryChartDataSet.colors = colors
        categoryChart.notifyDataSetChanged()
        
        //categoryChart.extraRightOffset = 50
        
        categoryChart.legend.font = UIFont.systemFont(ofSize: 16)
        categoryChart.legend.orientation = .vertical
        categoryChart.legend.verticalAlignment = .center
        categoryChart.legend.horizontalAlignment = .right
        categoryChart.data = categoryChartData
        //categoryChart.usePercentValuesEnabled = true

        categoryChartDataSet.drawValuesEnabled = false
        
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .percent
//        formatter.maximumFractionDigits = 1
//        formatter.multiplier = 1.0
//        categoryChartDataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
}
