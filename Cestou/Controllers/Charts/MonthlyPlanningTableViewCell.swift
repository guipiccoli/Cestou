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
        let expensesEntry2 = BarChartDataEntry(x: 2.0, y: getBalance["Expenses"]!)

        //dataset
        let expensesDataSet = BarChartDataSet(entries: [expensesEntry1,expensesEntry2], label: "Gastos Totais")
        let expensesData = BarChartData(dataSets: [expensesDataSet])
        
        let greenColor = NSUIColor.init(red: 43/255, green: 203/255, blue: 136/255, alpha: 1.0)
        let redColor = NSUIColor.init(red: 255.0/255, green: 117/255, blue: 117/255, alpha: 1.0)
        let lightGray = NSUIColor.init(red: 228.0/255, green: 228.0/255, blue: 228.0/255, alpha: 1.0)
        
        let expenseColor: NSUIColor = getBalance["Expenses"]! < getBalance["Planning"]! ? greenColor : redColor
        let targetColor: NSUIColor = getBalance["Expenses"]! < getBalance["Planning"]! ? redColor : NSUIColor.white
        let targetLabelColor: NSUIColor = getBalance["Expenses"]! < getBalance["Planning"]! ? NSUIColor.darkGray : NSUIColor.white
        expensesDataSet.setColors([lightGray, expenseColor], alpha: 1.0)

        expensesData.barWidth = 1.0
        expensesMonthlyPlanningChart.drawGridBackgroundEnabled = false
        expensesMonthlyPlanningChart.leftAxis.drawBottomYLabelEntryEnabled = false
        expensesMonthlyPlanningChart.leftAxis.drawTopYLabelEntryEnabled = false

        expensesData.setDrawValues(false)
    
        
        expensesMonthlyPlanningChart.leftAxis.enabled = true
        expensesMonthlyPlanningChart.borderColor = .darkGray
        expensesMonthlyPlanningChart.leftAxis.labelTextColor = .white
        expensesMonthlyPlanningChart.leftAxis.axisMinimum = 0
        expensesMonthlyPlanningChart.leftAxis.axisMaximum = getBalance["Incoming"]!
        
        let expense = ChartLimitLine(limit: self.getBalance["Expenses"]!, label: "R$" + String(format: "%.0f", self.getBalance["Expenses"]!) )
        expense.labelPosition = .topLeft
        expense.lineColor = expenseColor
        expense.valueTextColor = .white
        
        let target = ChartLimitLine(limit: self.getBalance["Planning"]!, label: "R$" + String(format: "%.0f", self.getBalance["Planning"]!) )
        target.labelPosition = .bottomLeft
        target.lineColor = targetColor
        target.valueTextColor = targetLabelColor
        target.lineWidth = 0.5
        let incoming = ChartLimitLine(limit: self.getBalance["Incoming"]!, label: "R$" + String(format: "%.0f", self.getBalance["Incoming"]!) )
        incoming.labelPosition = .bottomLeft
        incoming.lineWidth = 0.5
        incoming.drawLabelEnabled = false
        incoming.lineColor = UIColor.darkGray
        
        expensesMonthlyPlanningChart.leftAxis.addLimitLine(target)
        expensesMonthlyPlanningChart.leftAxis.addLimitLine(expense)
        expensesMonthlyPlanningChart.leftAxis.addLimitLine(incoming)
        expensesMonthlyPlanningChart.rightAxis.enabled = false
        expensesMonthlyPlanningChart.xAxis.enabled = false
        expensesMonthlyPlanningChart.highlightPerTapEnabled = false

        expensesMonthlyPlanningChart.drawValueAboveBarEnabled = true
        expensesMonthlyPlanningChart.data = expensesData
        
        expensesMonthlyPlanningChart.legend.enabled = false

        expensesMonthlyPlanningChart.notifyDataSetChanged()

        expensesMonthlyPlanningChart.animate(yAxisDuration: 1)

    }


}
