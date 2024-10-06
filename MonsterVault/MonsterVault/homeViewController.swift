//
//  homeViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/3/24.
//

import Foundation
import UIKit
import FSCalendar
import SnapKit
//Errors
enum DatabaseError: Error{
    case failedToFetch
    case invaildData
    case insufficientPoints
    case insufficientPetFood
}
//Dataset of Income
struct Income {
    var source: String
    var amount: Double
    var id: String
}
//Dataset of Expense
struct Expense {
    var category: String
    var amount: Double
    var id: String
}
//userid
class selectedData{
    static var id: String?
}


//main
class homeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tablerows.count
    }
    //table that contains all incomes/expenses
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell";
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
        cell.textLabel?.text = String(Tablerows[indexPath.row])
        //detail button
        let detailButton = UIButton()
        detailButton.setTitle("...", for: .normal)
        detailButton.titleLabel?.font = .systemFont(ofSize:16)
        detailButton.addTarget(self, action: #selector(detailClick(_:)), for: .touchUpInside)
        detailButton.backgroundColor = .white
        detailButton.setTitleColor(.blue, for: .normal)
        detailButton.setTitleColor(.gray, for: .highlighted)
        if ids.count > 0{
            let iconView: UIImageView = self.icons[indexPath.row]
            
            buttons.append(detailButton)
            cell.addSubview(detailButton)
            cell.addSubview(iconView)
        
            
            //detail button place
            detailButton.snp.makeConstraints{make in
                make.top.equalTo(cell.snp.top)
                make.right.equalTo(cell.snp.right)
                make.width.equalTo(20)
                make.bottom.equalTo(cell.snp.bottom)
            }
            //icon place
            iconView.snp.makeConstraints{make in
                make.top.equalTo(cell.snp.top).offset(20)
                make.left.equalTo(cell.snp.left).offset(20)
                make.width.equalTo(60)
                make.bottom.equalTo(cell.snp.bottom).offset(-20)
            }
            
            
        }
        return cell
    }
    //detial table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    private var StatsViewController: statsViewController?
    private var PetViewController: petViewController?
    private var UserViewController: userViewController?
    private var incomeData: [Income] = []
    private var expenseData: [Expense] = []
    private var incomeData_user: [String:Any] = [:]
    private var expenseData_user: [String:Any] = [:]
    private var Tablerows: [String] = []
    private var ids: [String] = []
    private var buttons : [UIButton] = []
    private var icons : [UIImageView] = []
    //calender
    fileprivate var calendar: FSCalendar!
    //cells in the detail table
    lazy var infoView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 149/255, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    
    //plus button
    lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    //Implement segmentedControl for four options, Calendar, Statistics, Pet, User
    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Calendar", "Statistics", "Pet", "User"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        return control
    }()
    //Container
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.calendar = FSCalendar()
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.view.addSubview(calendar)
        // calendar
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        // header
        calendar.appearance.headerTitleColor = ui.mint
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20)
        // weekday header
        calendar.appearance.weekdayTextColor = ui.mint
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 18)
        // event dots
        calendar.appearance.eventDefaultColor = ui.pink
        calendar.appearance.eventSelectionColor = ui.pink
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        // today
        calendar.appearance.todayColor = ui.mint
        calendar.appearance.titleTodayColor = .black
        // selected date
        calendar.appearance.selectionColor = ui.yellow
        calendar.appearance.titleSelectionColor = .black
        //place calender
        let shorterViewHeight: CGFloat = 350
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            //make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(shorterViewHeight)
        }
        //place detail table
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.height.equalTo(410)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
        }
        //place container
        view.addSubview(containerView)
        containerView.backgroundColor = ui.mint
        containerView.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(40)
            make.height.equalTo(130)
        }
        //place segmentedControl
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.height.equalTo(30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        // add the plus sign button to the navigation bar
        view.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-16)

        }
        
        
        
    }
    //Function for click detail button
    @objc private func detailClick(_ sender:UIButton){
        let i = buttons.firstIndex(of: sender)
        print(buttons)
        print(i)
        selectedData.id = ids[i!]
        let de = detailViewController()
        de.modalPresentationStyle = .overFullScreen
        present(de, animated: true, completion: nil)
    }
    
    //Function for call out statictics page
    @objc private func showStatisticsViewController() {
        StatsViewController = statsViewController()
        addChild(StatsViewController!)
        view.addSubview(StatsViewController!.view)
        StatsViewController!.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        StatsViewController!.didMove(toParent: self)
    }
    
    // Function for statsViewController to call for returning back to this page
    func showCalendarView() {
        // Existing code to hide the StatisticsViewController
        // Remove the StatisticsViewController's view from its superview
        StatsViewController?.view.removeFromSuperview()
        // Remove StatisticsViewController from its parent
        StatsViewController?.removeFromParent()
        showCalendarViewController()
        segmentedControl.selectedSegmentIndex = 0
    }
    
    // Function for petViewController to call for returning back to this page
    func showCalendarView2() {
        // Existing code to hide the StatisticsViewController
        // Remove the StatisticsViewController's view from its superview
        PetViewController?.view.removeFromSuperview()
        // Remove StatisticsViewController from its parent
        PetViewController?.removeFromParent()
        showCalendarViewController()
        segmentedControl.selectedSegmentIndex = 0
    }
    
    // Function for userViewController to call for returning back to this page
    func showCalendarView3() {
        // Existing code to hide the StatisticsViewController
        // Remove the StatisticsViewController's view from its superview
        UserViewController?.view.removeFromSuperview()
        // Remove StatisticsViewController from its parent
        UserViewController?.removeFromParent()
        showCalendarViewController()
        segmentedControl.selectedSegmentIndex = 0
    }
    
    // Function to control the segmented control on the bottom of this page
    // Call corresponding view controller
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                showCalendarViewController()
            case 1:
                showStatisticsViewController()
            case 2:
                showPetViewController()
            case 3:
                showUserViewController()
            default:
                break
        }
    }
    //Function for call out pet page
    private func showPetViewController() {
        PetViewController = petViewController()
        addChild(PetViewController!)
        view.addSubview(PetViewController!.view)
        PetViewController!.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        PetViewController!.didMove(toParent: self)
    }
    
    //Function for call out user page
    private func showUserViewController() {

        UserViewController = userViewController()
        addChild(UserViewController!)
        view.addSubview(UserViewController!.view)
        UserViewController!.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UserViewController!.didMove(toParent: self)
    }

    private func showCalendarViewController() {
        // Existing code to show current view controller
    }
    
    //TODO: Add a "plus sign" button on the top-right corner
    // click the plus sign and choose either input income or expense and go the the incomeViewController or expenseViewController
    @objc func plusButtonTapped(_ sender:UIButton) {
            // Handle the plus sign button tap
        print("Plus button tapped!")
        showOptionsAlert()
    }
    //show options, income, expense and cancel.
    private func showOptionsAlert() {
        let alertController = UIAlertController(title: "Select an option", message: nil, preferredStyle: .actionSheet)
        let incomeAction = UIAlertAction(title: "Income", style: .default) { _ in
            self.presentIncomeViewController()
        }
        let expenseAction = UIAlertAction(title: "Expense", style: .default) { _ in
            self.showExpenseAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(incomeAction)
        alertController.addAction(expenseAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    //show options, scan receipt, scan object, and manual input
    private func showExpenseAlert(){
        let alertController = UIAlertController(title: "Select an option", message: "Choose a option to input expense", preferredStyle: .actionSheet)
        let receiptAction = UIAlertAction(title: "Scan Receipt", style: .default) { _ in
            self.presentReceiptViewController()
        }
        let objectAction = UIAlertAction(title: "Scan object", style: .default) { _ in
            self.presentObjectViewController()
        }
        let textfieldAction = UIAlertAction(title: "Manual Input", style: .default) { _ in
            self.presentExpenseViewController()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(receiptAction)
        alertController.addAction(objectAction)
        alertController.addAction(textfieldAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true,completion: nil)
    }
    //Function for call out income input page
    private func presentIncomeViewController() {
        let IncomeViewController = incomeViewController()
        IncomeViewController.modalPresentationStyle = .overFullScreen
        present(IncomeViewController, animated: true, completion: nil)
    }
    //Function for call out expense manual input page
    private func presentExpenseViewController() {
        let ExpenseViewController = expenseViewController()
        ExpenseViewController.modalPresentationStyle = .overFullScreen
        present(ExpenseViewController, animated: true, completion: nil)
    }
    //Function for call out expense scan receipt input page
    private func presentReceiptViewController(){
        let receiptViewController = scantextViewController()
        receiptViewController.modalPresentationStyle = .overFullScreen
        present(receiptViewController,animated: true,completion: nil)
    }
    //Function for call out expense scan object input page
    private func presentObjectViewController(){
        let objectViewController = scanobjectViewController()
        objectViewController.modalPresentationStyle = .overFullScreen
        present(objectViewController,animated: true,completion: nil)
    }
    
    
    // MARK: - FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Handle calendar date selection
        //Get data from database and show total expense and income on the selected date below the calendar as list.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        UserManager.detailarr.removeAll()
        ids.removeAll()
        buttons.removeAll()
        DatabaseManager.shared.getAllIncome(with: UserManager.cuser!.uid){result in
            switch result {
            case .success(let incomeData):
                self.incomeData_user = [:]
                self.incomeData_user = incomeData
                self.getIncomeData(with: formattedDate)
            case .failure(let error):
                print(error)
            }
            
        }
        DatabaseManager.shared.getAllExpense(with: UserManager.cuser!.uid){ result in
            switch result {
            case .success(let expenseData):
                self.expenseData_user = [:]
                self.expenseData_user = expenseData
                self.getExpenseData(with: formattedDate)
            case .failure(let error):
                print(error)
            }
        }
        
        icons.removeAll()
        Tablerows.removeAll()
        if !incomeData.isEmpty {
            for (index, income) in incomeData.enumerated() {
                ids.append(income.id)
                Tablerows.append("                     \(income.source): $\(income.amount)")
                addIcon(type: String(income.source))
            }
            print("Success")
        }

        if !expenseData.isEmpty {
            // Display expense information
            for (index, expense) in expenseData.enumerated() {
                ids.append(expense.id)
                Tablerows.append("                    \(expense.category): $\(expense.amount)")
                addIcon(type: String(expense.category))
            }
            print("Success")
        }
        if incomeData.isEmpty && expenseData.isEmpty {
            Tablerows.append("No data. Please click [+] to add new record.")
        }
        infoView.reloadData()
    }
    
    //add icons for each expense/income
    private func addIcon(type : String){
        print(type)
        if type == "Food"{
            let imageView = UIImageView()
            imageView.image = UIImage(named: "food")
            icons.append(imageView)
        }
        if type == "Housing"{
            let imageView = UIImageView()
            imageView.image = UIImage(named: "house")
            icons.append(imageView)
        }
        if type == "Transportation"{
            let imageView = UIImageView()
            imageView.image = UIImage(named: "transportation")
            icons.append(imageView)
        }
        if type == "Academy"{
            let imageView = UIImageView()
            imageView.image = UIImage(named: "academy")
            icons.append(imageView)
        }
        if type == "Clothes"{
            let imageView = UIImageView()
            imageView.image = UIImage(named: "clothes")
            icons.append(imageView)
        }
        if type == "Entertainment"{
            let imageView = UIImageView()
            imageView.image = UIImage(named: "entertainment")
            icons.append(imageView)
        }
        if type == "Wages"{
            let imageView = UIImageView()
            imageView.image = UIImage(named: "wage")
            icons.append(imageView)
        }
        if type == "Investments"{
            let imageView = UIImageView()
            imageView.image = UIImage(named: "investment")
            icons.append(imageView)
        }
        if type == "Bonuses"{
            let imageView = UIImageView()
            imageView.image = UIImage(named: "bonus")
            icons.append(imageView)
        }
    
    }
    
    //get income data form database
    private func getIncomeData(with date: String) -> [Income]{
        self.incomeData = []
        for i in incomeData_user{
            let j : [String : Any] = i.value as! [String : Any]
            if j["date"] as! String == date{
                let ic = Income(source: j["source"] as! String, amount: j["amount"] as! Double, id: i.key)
                self.incomeData.append(ic)
            }
        }
        return self.incomeData
    }
    //get expense data from database
    private func getExpenseData(with date: String) -> [Expense]{
        self.expenseData = []
        for i in expenseData_user{
            let j : [String : Any] = i.value as! [String : Any]
            if j["date"] as! String == date{
                let ec = Expense(category: j["category"] as! String, amount:j["amount"] as! Double, id: i.key )
                self.expenseData.append(ec)
            }
        }
        return self.expenseData
    }
    
    
}


