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
    
    @IBOutlet var balancoLabel: UILabel!
    @IBOutlet var gastoProjetadoLabel: UILabel!
    @IBOutlet var rendaLabel: UILabel!
    @IBOutlet var gastosLabel: UILabel!
    
    @IBOutlet weak var monthlyPlanningChart: BarChartView!
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
        
        backgroundCardView.layer.cornerRadius = 12
        backgroundCardView.layer.borderWidth = 0.5
        backgroundCardView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundCardView.layer.masksToBounds = false
        
        
        
        balancoLabel.text = String(format: "R$%.2f", (self.getBalance["Incoming"]! - self.getBalance["Expenses"]!))
        gastoProjetadoLabel.text = String(format: "R$%.2f", (self.getBalance["Planning"]!))
        rendaLabel.text = String(format: "R$%.2f", (self.getBalance["Incoming"]!))
        gastosLabel.text = String(format: "R$%.2f", (self.getBalance["Expenses"]!))

    }
    
    func setChart() {
        
        //valores de entrada pro grafico
        let entry1 = BarChartDataEntry(x: 1.0, y: getBalance["Incoming"]!)
        let entry2 = BarChartDataEntry(x: 2.0, y: getBalance["Planning"]!)
        let entry3 = BarChartDataEntry(x: 3.0, y: getBalance["Expenses"]!)

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
        
        monthlyPlanningChart.animate(yAxisDuration: 1)
    }


}
