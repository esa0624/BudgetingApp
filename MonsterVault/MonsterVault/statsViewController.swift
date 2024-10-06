//
//  statsViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/3/24.
//


import Foundation
import UIKit
import SnapKit
import Charts

class statsViewController: UIViewController {
    private var incomeData: [Income] = []
    private var expenseData: [Expense] = []
    private var incomeData_user: [String:Any] = [:]
    private var expenseData_user: [String:Any] = [:]
    private var barChartView: BarChartView!
    private var pieChartView: PieChartView!
    
    private var monthArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    //color definition
    lazy var expensePercentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    //remain bugdet label
    lazy var remainingBudgetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    //back button
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    //top colored bar
    lazy var topBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    // title label
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Statistics"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    //main
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(topBackgroundView)
        topBackgroundView.backgroundColor = ui.mint
        topBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-60)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            //make.bottom.equalTo(pointsLabel.snp.bottom).offset(15)
            make.height.equalTo(115)
        }
        
        
        //back button
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(view).offset(20)
        }
        //title label
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
            make.centerX.equalTo(view)
            
        }
        //initialize a bar chart
        barChartView = BarChartView()
        view.addSubview(barChartView)
        barChartView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        // Initialize a pie chart
        pieChartView = PieChartView()
        view.addSubview(pieChartView)
        pieChartView.snp.makeConstraints { make in
            make.top.equalTo(barChartView.snp.bottom).offset(20)
            //make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        makePieChart()
        
        setupBarChart()
        
        view.addSubview(expensePercentageLabel)
        view.addSubview(remainingBudgetLabel)
        expensePercentageLabel.backgroundColor = ui.mint
        expensePercentageLabel.snp.makeConstraints { make in
            make.top.equalTo(pieChartView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview()
        }
        remainingBudgetLabel.backgroundColor = ui.mint
        remainingBudgetLabel.snp.makeConstraints { make in
            make.top.equalTo(expensePercentageLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview()
        }
        
        
    }
    
    private func setupBarChart() {
        // data for income and expenses
        // TODO: get data from database
        // show monthly spending and earning for the current year, if doesn;t have record just don't make bar
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: Date())
        print(formattedDate)
        
        
        
        DatabaseManager.shared.getAllExpense2(with: UserManager.cuser!.uid){result in
            switch result {
            case .success(let expenseData):
                self.expenseData_user = [:]
                self.expenseData_user = expenseData
                
                var monthlyTotals: [Double] = Array(repeating: 0.0, count: 12)
                
                for expense in self.expenseData_user {
                    let j : [String : Any] = expense.value as! [String : Any]
                    if let dateString = j["date"] as? String,
                       let amount = j["amount"] as? Double,
                       let date = dateFormatter.date(from: dateString) {
                        let calendar = Calendar.current
                        let month = calendar.component(.month, from: date)
                        // Month is 1-based index
                        monthlyTotals[month - 1] += amount
                    }
                }
                
                DatabaseManager.shared.getAllIncome(with: UserManager.cuser!.uid){result in
                    switch result {
                    case .success(let incomeData):
                        self.incomeData_user = [:]
                        self.incomeData_user = incomeData
                        
                        var monthlyTotals2: [Double] = Array(repeating: 0.0, count: 12)
                        
                        for income in self.incomeData_user {
                            let i : [String : Any] = income.value as! [String : Any]
                            if let dateString = i["date"] as? String,
                               let amount = i["amount"] as? Double,
                               let date = dateFormatter.date(from: dateString) {
                                let calendar = Calendar.current
                                let month = calendar.component(.month, from: date)
                                // Month is 1-based index
                                monthlyTotals2[month - 1] += amount
                            }
                        }
                        var incomeEntries: [BarChartDataEntry] = []
                        var expenseEntries: [BarChartDataEntry] = []

                        for i in 0..<self.monthArray.count {
                            let incomeEntry = BarChartDataEntry(x: Double(i), y: monthlyTotals2[i])
                            let expenseEntry = BarChartDataEntry(x: Double(i), y: monthlyTotals[i])
                            incomeEntries.append(incomeEntry)
                            expenseEntries.append(expenseEntry)
                        }

                        let incomeDataSet = BarChartDataSet(entries: incomeEntries, label: "Income")
                        incomeDataSet.setColor(ui.yellow) // Set color for income bars

                        let expenseDataSet = BarChartDataSet(entries: expenseEntries, label: "Expense")
                        expenseDataSet.setColor(ui.mint)

                        let groupSpace = 0.3
                        let barSpace = 0.05
                        let barWidth = 0.3

                        // Customize X-axis labels
                        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.monthArray)
                        self.barChartView.xAxis.labelCount = self.monthArray.count
                        self.barChartView.xAxis.labelPosition = .bottom
                        self.barChartView.xAxis.drawGridLinesEnabled = false
                        self.barChartView.xAxis.centerAxisLabelsEnabled = true
                        self.barChartView.xAxis.granularity = 1.0

                        //let dataSets: [BarChartDataSet] = [incomeDataSet, expenseDataSet]
                        
                        var dataSets: [BarChartDataSet] = []
                        if !self.expenseData_user.isEmpty {
                            dataSets.append(expenseDataSet)
                        }
                        dataSets.append(incomeDataSet)
                        
                        let data = BarChartData(dataSets: dataSets)
                        data.barWidth = barWidth
                        data.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)

                        self.barChartView.data = data
                        self.barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                        
                        // Calculate percentage of expense and income for current month
                        let currentMonth = Calendar.current.component(.month, from: Date())
                        let currentExpense = monthlyTotals[currentMonth - 1]
                        let currentIncome = monthlyTotals2[currentMonth - 1]
                        
                        if currentIncome > 0 {
                            let expensePercentage = (currentExpense / currentIncome) * 100
                            //let incomePercentage = 100 - expensePercentage
                            self.expensePercentageLabel.text = String(format: "Expense Percentage: %.2f%%", expensePercentage)
                            
                            
                        } else {
                            self.expensePercentageLabel.text = "No income data for the current month."
                            
                        }
                        
                        // Calculate remaining budget
                        let remainingBudget = currentIncome - currentExpense
                        self.remainingBudgetLabel.text = String(format: "Remaining Budget: $%.2f", remainingBudget)
                        print("Remaining Budget for current month: \(remainingBudget)")
                        
                        
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                }
            
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    @objc private func backButtonTapped(_ sender:UIButton) {
        // back button tap
        //self.dismiss(animated: true, completion: nil)
        if let parentVC = parent as? homeViewController {
                parentVC.showCalendarView()
        }
        //delegate?.didTapBackButton()
    }
    
    
    private func makePieChart() {
        // Data for the pie chart
        // TODO: get data from the database
        
        DatabaseManager.shared.getAllExpense2(with: UserManager.cuser!.uid){ result in
            switch result {
            case .success(let expenseData):
                self.expenseData_user = [:]
                self.expenseData_user = expenseData
                var expenseCategories: [String: Double] = [:]

                for expense in self.expenseData_user {
                    let j : [String : Any] = expense.value as! [String : Any]
                    if let category = j["category"] as? String,
                       let amount = j["amount"] as? Double {
                       if let existingAmount = expenseCategories[category] {
                           // Category already exists, add to the existing amount
                           expenseCategories[category] = existingAmount + amount
                       } else {
                           // Category doesn't exist, create a new entry
                           expenseCategories[category] = amount
                       }
                    }
                }
                // create entries for the pie chart
                var pieEntries: [PieChartDataEntry] = []
                for (category, amount) in expenseCategories {
                    let entry = PieChartDataEntry(value: amount, label: category)
                    pieEntries.append(entry)
                }

                let dataSet = PieChartDataSet(entries: pieEntries, label: "Expense Categories")
                dataSet.colors = [ui.mint, ui.green, ui.purple, ui.yellow, ui.red, ui.pink]
                dataSet.entryLabelColor = .black
                dataSet.valueTextColor = .black
                dataSet.drawValuesEnabled = true

                let data = PieChartData(dataSet: dataSet)
                self.pieChartView.data = data
                self.pieChartView.chartDescription.text = "Expense Distribution"
                self.pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                self.pieChartView.usePercentValuesEnabled = true //new added
                
            case .failure(let error):
                print(error)
            }
        }

    }
    
    
}


