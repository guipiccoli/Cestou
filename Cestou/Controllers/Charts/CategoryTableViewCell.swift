//
//  CategoryTableViewCell.swift
//  Cestou
//
//  Created by Rafael Ferreira on 07/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import Charts

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryChart: PieChartView!
    var mockGet: [String: Double] = ["Categoria 1":200.0, "Categoria 2":430.0, "Categoria 3":100.0, "Categoria 4":179.0]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func configure() {
        var categories: [String] = []
        var valueSpent: [Double] = []
        
        for entry in mockGet {
            categories.append(entry.key)
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
        
        var colors: [UIColor] = [] //receber as cores definidas pelo Leo no processo de design
        
        categoryChart.drawEntryLabelsEnabled = false
        categoryChart.highlightPerTapEnabled = false
        categoryChartDataSet.colors = ChartColorTemplates.pastel()
        categoryChart.notifyDataSetChanged()
        
        categoryChart.legend.font = UIFont.systemFont(ofSize: 20)
        categoryChart.legend.orientation = .vertical
        categoryChart.legend.verticalAlignment = .center
        categoryChart.legend.horizontalAlignment = .right
        categoryChart.data = categoryChartData
        categoryChart.usePercentValuesEnabled = true

        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        categoryChartDataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
}
