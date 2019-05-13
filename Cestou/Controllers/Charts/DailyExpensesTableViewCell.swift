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

    @IBOutlet var backgroundCardView: UIView!
    @IBOutlet weak var dailyExpensesChart: LineChartView!
    var getMonth: String = "Janeiro"
    
    var mockGet: [Int: Double] = [3: 400.00, 5: 100.00, 10: 200.0, 20:300, 30:400, 25:100]
    var daysPerMonth: [String:Int] = ["Janeiro":31,"Fevereiro":29, "Marco":31, "Abril":30, "Maio":31, "Junho":30, "Julho":31, "Agosto":31, "Setembro":30, "Outubro":31, "Novembro":30, "Dezembro":31]
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundCardView.layer.cornerRadius = 12
        backgroundCardView.layer.borderWidth = 0.5
        backgroundCardView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundCardView.layer.masksToBounds = false
    }

    func configure() {
        var days: [Int] = []
        var valueSpent: [Double] = []
        
        for i in 0 ..< daysPerMonth[getMonth]! {
            if mockGet[i] != nil {
                days.append(i)
                valueSpent.append(mockGet[i]!)
            }
            else {
                days.append(i)
                valueSpent.append(0)
            }
        }
        
        setChart(dataPoints: days, values: valueSpent)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
