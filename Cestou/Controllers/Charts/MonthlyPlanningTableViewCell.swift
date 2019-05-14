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
        let entry1 = BarChartDataEntry(x: 1.0, y: mockGet["Incoming"]!)
        let entry2 = BarChartDataEntry(x: 2.0, y: mockGet["Planning"]!)
        let entry3 = BarChartDataEntry(x: 3.0, y: mockGet["Expenses"]!)

        

        
        
        //dataset
        let dataSet = BarChartDataSet(entries: [entry1,entry2,entry3], label: "Gastos Totais")
        let data = BarChartData(dataSets: [dataSet])
        monthlyPlanningChart.data = data

        let greenColor = NSUIColor.init(red: 0.0/255, green: 136.0/255, blue: 15.0/255, alpha: 1.0)
        let blueColor = NSUIColor.init(red: 0.0/255, green: 146.0/255, blue: 186.0/255, alpha: 1.0)
        let redColor = NSUIColor.init(red: 189.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0)

        
        dataSet.setColors([greenColor,blueColor,redColor], alpha: 1.0)
        
    
        monthlyPlanningChart.leftAxis.enabled = false
        monthlyPlanningChart.rightAxis.enabled = false
        monthlyPlanningChart.xAxis.enabled = false
        monthlyPlanningChart.leftAxis.axisMinimum = 0
        monthlyPlanningChart.highlightPerTapEnabled = false
        
        monthlyPlanningChart.legend.enabled = false
        data.setDrawValues(false)
        monthlyPlanningChart.notifyDataSetChanged()
    }


}
