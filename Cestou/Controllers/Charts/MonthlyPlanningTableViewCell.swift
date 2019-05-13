//
//  MonthlyPlanningTableViewCell.swift
//  Cestou
//
//  Created by Rafael Ferreira on 07/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import Charts

class MonthlyPlanningTableViewCell: UITableViewCell {

    @IBOutlet weak var monthlyPlanningChart: BarChartView!
    @IBOutlet weak var backgroundCardView: UIView!
    
   // @IBOutlet weak var planningValueLabel: UILabel!
   // @IBOutlet weak var expensesValueLabel: UILabel!
    
    var mockGet: [String: Double] = ["Planning":400.00, "Expenses": 2100.00, "Incoming": 1100.0]

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure() {
        setChart()
        
        //planningValueLabel.text = "R$\(mockGet["Planning"]!)"
        //expensesValueLabel.text = "R$\(mockGet["Expenses"]!)"
        //planningValueLabel.sizeToFit()
        //expensesValueLabel.sizeToFit()
        
        backgroundCardView.layer.cornerRadius = 12
        backgroundCardView.layer.borderWidth = 0.5
        backgroundCardView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundCardView.layer.masksToBounds = false

    }
    
    func setChart() {
        
        //valores de entrada pro grafico
        let entry1 = BarChartDataEntry(x: 1.0, y: mockGet["Expenses"]!)
        let entry2 = BarChartDataEntry(x: 2.0, y: mockGet["Planning"]!)
        let entry3 = BarChartDataEntry(x: 3.0, y: mockGet["Incoming"]!)

        

        
        
        //dataset
        let dataSet = BarChartDataSet(entries: [entry2,entry1,entry3], label: "Gastos Totais")
        let data = BarChartData(dataSets: [dataSet])
        monthlyPlanningChart.data = data
        //barChart.chartDescription?.text = "Number of Widgets by Type"
        
        //All other additions to this function will go here
        
        //cor das barras
        dataSet.setColors([NSUIColor.green,NSUIColor.gray], alpha: 1.0)
        
        //cor dos textos
       // dataSet.valueColors = [UIColor.green, UIColor.gray]
        
        //posicao da label X
        //animacao
        //monthlyPlanningChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInBounce)
        //monthlyPlanningChart.backgroundColor = .gray
        //monthlyPlanningChart.xAxis.drawGridLinesEnabled = false
        //monthlyPlanningChart.leftAxis.drawGridLinesEnabled = false
        
        monthlyPlanningChart.leftAxis.enabled = false
        monthlyPlanningChart.rightAxis.enabled = false
        monthlyPlanningChart.xAxis.enabled = false
        monthlyPlanningChart.leftAxis.axisMinimum = 0
        monthlyPlanningChart.highlightPerTapEnabled = false
        
        monthlyPlanningChart.legend.enabled = false
        data.setDrawValues(false)
        //monthlyPlanningChart.leftAxis.enabled = false
       // monthlyPlanningChart.rightAxis.enabled = false
        
        //        barChart.xAxis.gridColor = .clear
        //monthlyPlanningChart.leftAxis.gridColor = .clear
        //        barChart.rightAxis.gridColor = .clear
        
        //This must stay at end of function
        monthlyPlanningChart.notifyDataSetChanged()
    }


}
