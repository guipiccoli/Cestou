//
//  DailyExpensesTableViewCell.swift
//  Cestou
//
//  Created by Rafael Ferreira on 07/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import Charts

class DailyExpensesTableViewCell: UITableViewCell {

    @IBOutlet var noDataText: UILabel!
    @IBOutlet var backgroundCardView: UIView!
    @IBOutlet weak var dailyExpensesChart: LineChartView!
    var getMonth: Int = 0
    var balanceMonth: Balance?
    
    var expenses: [Int: Double] = [:]
    var daysPerMonth: [Int] = [31,29,31,30,31,30,31,31,30,31,30,31]
    
    override func awakeFromNib() {
        super.awakeFromNib()

        noDataText.isHidden = false
        dailyExpensesChart.noDataText = ""
        backgroundCardView.layer.cornerRadius = 12
        backgroundCardView.layer.borderWidth = 0.5
        backgroundCardView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundCardView.layer.masksToBounds = false
    }

    func configure() {
        var days: [Int] = []
        var valueSpent: [Double] = []
        expenses = [:]
        if let _balanceMonth = self.balanceMonth, let shoppings = _balanceMonth.monthlyShoppings {
            for item in shoppings {
                if var expense = expenses[Int(String(item.prettyDate().prefix(2)))! ] {
                    expense += item.cost
                    expenses[Int(String(item.prettyDate().prefix(2)))!] = expense
                }
                else {
                    expenses[Int(String(item.prettyDate().prefix(2)))!] = item.cost
                }
            }
        }
        print(expenses)
        for i in 0 ..< daysPerMonth[getMonth] {
            if expenses[i] != nil {
                days.append(i)
                valueSpent.append(expenses[i]!)
            }
            else {
                days.append(i)
                valueSpent.append(0)
            }
        }
        
        if expenses.count > 0 {
            noDataText.isHidden = true
            dailyExpensesChart.isHidden = false
            setChart(dataPoints: days, values: valueSpent)
        }
        else {
//           falta trazer a mensagem de erro
            noDataText.isHidden = false
            dailyExpensesChart.isHidden = true
            
        }
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setChart(dataPoints: [Int], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0 ..< dataPoints.count {
            let dataEntryWithValue = ChartDataEntry(x: Double(dataPoints[i]), y: values[i] )
            dataEntries.append(dataEntryWithValue)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        dailyExpensesChart.data = lineChartData
        
        lineChartData.setDrawValues(false)
        
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.colors = [UIColor.red]
        
        
        let gradientColor = [UIColor.red.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [0.4, 0.0]
        guard let gradients = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColor, locations: colorLocations) else {return}
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradients, angle: 90.0)
        lineChartDataSet.drawFilledEnabled = true
        
        dailyExpensesChart.xAxis.labelPosition = .bottom
        
        dailyExpensesChart.rightAxis.gridColor = .clear
        dailyExpensesChart.leftAxis.gridColor = .clear
        dailyExpensesChart.xAxis.gridColor = .clear
        
        dailyExpensesChart.rightAxis.enabled = false
        dailyExpensesChart.legend.enabled = false
        
        
        lineChartDataSet.mode = .horizontalBezier
        
        
        var colors: [UIColor] = [] //receber as cores definidas pelo Leo no processo de design
        
    }
}
