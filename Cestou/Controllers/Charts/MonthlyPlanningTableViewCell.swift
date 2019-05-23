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
    
    
    @IBOutlet weak var balanceMonthlyPlanningChart: HorizontalBarChartView!
    @IBOutlet weak var expensesMonthlyPlanningChart: HorizontalBarChartView!
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet var noDataView: UIView!
    @IBOutlet var noDataText: UILabel!
    
    var balanceMonth: Balance?
    var getBalance: [String: Double] = [:]

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if getBalance.count > 0 {
            noDataView.isHidden = true
            noDataText.isHidden = true
        }
    }

    func configure() {
        
        self.getBalance["Planning"] = self.balanceMonth?.expenseProjected
        self.getBalance["Expenses"] = self.balanceMonth?.expense
        self.getBalance["Incoming"] = self.balanceMonth?.incoming
        
        if getBalance.count > 0 {
            setChart()
            noDataView.isHidden = true
            noDataText.isHidden = true
        }
        
        backgroundCardView.layer.cornerRadius = 16
        backgroundCardView.layer.borderWidth = 0.5
        backgroundCardView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundCardView.layer.masksToBounds = false
        

    }
    
    func setChart() {
        
        //valores de entrada pro grafico
        let expensesEntry1 = BarChartDataEntry(x: 2.0, y: getBalance["Incoming"]!)
        let expensesEntry2 = BarChartDataEntry(x: 2.0, y: getBalance["Planning"]!)
        
        let balanceEntry1 = BarChartDataEntry(x: 3.0, y: getBalance["Incoming"]!)
        let balanceEntry2 = BarChartDataEntry(x: 3.0, y: getBalance["Expenses"]!)

        //dataset
        let expensesDataSet = BarChartDataSet(entries: [expensesEntry1,expensesEntry2], label: "Gastos Totais")
        let expensesData = BarChartData(dataSets: [expensesDataSet])
        expensesMonthlyPlanningChart.data = expensesData
        
        let balanceDataSet = BarChartDataSet(entries: [balanceEntry1,balanceEntry2], label: "Balanco")
        let balanceData = BarChartData(dataSets: [balanceDataSet])
        balanceMonthlyPlanningChart.data = balanceData

        let blueColor = NSUIColor.init(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0)
        let redColor = NSUIColor.init(red: 255.0/255, green: 117/255, blue: 117/255, alpha: 1.0)
        let lightGray = NSUIColor.init(red: 228.0/255, green: 228.0/255, blue: 228.0/255, alpha: 1.0)
        
        
        balanceDataSet.setColors([lightGray,blueColor], alpha: 1.0)
        expensesDataSet.setColors([lightGray,redColor], alpha: 1.0)

    
        expensesMonthlyPlanningChart.leftAxis.enabled = false
        expensesMonthlyPlanningChart.rightAxis.enabled = false
        expensesMonthlyPlanningChart.xAxis.enabled = false
        expensesMonthlyPlanningChart.leftAxis.axisMinimum = 0
        expensesMonthlyPlanningChart.highlightPerTapEnabled = false
        
        balanceMonthlyPlanningChart.leftAxis.enabled = false
        balanceMonthlyPlanningChart.rightAxis.enabled = false
        balanceMonthlyPlanningChart.xAxis.enabled = false
        balanceMonthlyPlanningChart.leftAxis.axisMinimum = 0
        balanceMonthlyPlanningChart.highlightPerTapEnabled = false
        
        expensesData.barWidth = 0.9
        balanceData.barWidth = 0.9

        expensesMonthlyPlanningChart.legend.enabled = false
        balanceMonthlyPlanningChart.legend.enabled = false

        balanceData.setDrawValues(false)
        expensesData.setDrawValues(false)

        expensesMonthlyPlanningChart.notifyDataSetChanged()
        balanceMonthlyPlanningChart.notifyDataSetChanged()

        expensesMonthlyPlanningChart.animate(yAxisDuration: 1)
        balanceMonthlyPlanningChart.animate(yAxisDuration: 1)

    }


}
