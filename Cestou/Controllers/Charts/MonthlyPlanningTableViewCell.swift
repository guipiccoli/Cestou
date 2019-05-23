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
    
    
    @IBOutlet weak var monthlyPlanningChart: HorizontalBarChartView!
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
        let entry1 = BarChartDataEntry(x: 2.0, y: getBalance["Planning"]!)
        let entry2 = BarChartDataEntry(x: 3.0, y: getBalance["Expenses"]!)

        //dataset
        let dataSet = BarChartDataSet(entries: [entry2,entry1], label: "Gastos Totais")
        let data = BarChartData(dataSets: [dataSet])
        monthlyPlanningChart.data = data

        let blueColor = NSUIColor.init(red: 0.0/255, green: 146.0/255, blue: 186.0/255, alpha: 1.0)
        let redColor = NSUIColor.init(red: 189.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0)

        
        dataSet.setColors([blueColor,redColor], alpha: 1.0)
        
    
        monthlyPlanningChart.leftAxis.enabled = false
        monthlyPlanningChart.rightAxis.enabled = false
        monthlyPlanningChart.xAxis.enabled = false
        monthlyPlanningChart.leftAxis.axisMinimum = 0
        monthlyPlanningChart.highlightPerTapEnabled = false
        monthlyPlanningChart.layer.cornerRadius = 10
        
        
        monthlyPlanningChart.legend.enabled = false
        data.setDrawValues(false)
        monthlyPlanningChart.notifyDataSetChanged()
        
        monthlyPlanningChart.animate(yAxisDuration: 1)
    }


}
