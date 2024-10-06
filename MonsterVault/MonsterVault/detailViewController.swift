//
//  detailViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/6/24.
//

import Foundation
import SnapKit
//store expense or income id
class detailinfo{
    static var id: String?
}

class detailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //detail table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.detailarr.count
    }
    //cell of the detail table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell";
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
        cell.textLabel?.text = String((UserManager.detailarr![indexPath.row]))
        return cell
    }
    
    
    
    private var detailmessage: String = ""
    private var detailarr:[String.SubSequence] = []
    //back button
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    //detail button
    lazy var detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show detail", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = ui.mint
        button.addTarget(self, action: #selector(detailButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    lazy var topBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    //top title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Detail"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    //type label
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        
        DatabaseManager.shared.getAllIncome(with: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let incomes):
                for income in incomes{
                    if selectedData.id == income.key{
                        let j : [String : Any] = income.value as! [String : Any]
                        let type = j["source"] as! String
                        label.text = "Type: \(type)"
                    }
                }
            case .failure(let error):
                print("Failed to fetch point data for income: \(error.localizedDescription)")
            }
        }
        DatabaseManager.shared.getAllExpense(with: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let expenses):
                for expense in expenses{
                    if selectedData.id == expense.key{
                        let j : [String : Any] = expense.value as! [String : Any]
                        let category = j["category"] as! String
                        label.text = "Category: \(category)"
                    }
                }
            case .failure(let error):
                print("Failed to fetch point data for expense: \(error.localizedDescription)")
            }
        }
        //label.text = "Points: 0"
        return label
    }()
    //amount label
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        
        DatabaseManager.shared.getAllIncome(with: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let incomes):
                for income in incomes{
                    if selectedData.id == income.key{
                        let j : [String : Any] = income.value as! [String : Any]
                        let amount = j["amount"] as! Double
                        label.text = "Amount: \(amount)"
                    }
                }
            case .failure(let error):
                print("Failed to fetch point data for income: \(error.localizedDescription)")
            }
        }
        DatabaseManager.shared.getAllExpense(with: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let expenses):
                for expense in expenses{
                    if selectedData.id == expense.key{
                        let j : [String : Any] = expense.value as! [String : Any]
                        let amount = j["amount"] as! Double
                        label.text = "Amount: \(amount)"
                    }
                }
            case .failure(let error):
                print("Failed to fetch point data for expense: \(error.localizedDescription)")
            }
        }
        //label.text = "Points: 0"
        return label
        
    }()
    //date label
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        DatabaseManager.shared.getAllIncome(with: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let incomes):
                for income in incomes{
                    if selectedData.id == income.key{
                        let j : [String : Any] = income.value as! [String : Any]
                        let date = j["date"] as! String
                        label.text = "Date: \(date)"
                    }
                }
            case .failure(let error):
                print("Failed to fetch point data for income: \(error.localizedDescription)")
            }
        }
        DatabaseManager.shared.getAllExpense(with: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let expenses):
                for expense in expenses{
                    if selectedData.id == expense.key{
                        let j : [String : Any] = expense.value as! [String : Any]
                        let date = j["date"] as! String
                        label.text = "Date: \(date)"
                    }
                }
            case .failure(let error):
                print("Failed to fetch point data for expense: \(error.localizedDescription)")
            }
        }
        //label.text = "Points: 0"
        return label
    }()
    //the table that show more detail (receipt or object)
    lazy var infoView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateDetail()
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
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
            make.centerX.equalTo(view)
            
        }
        
        view.addSubview(backButton)
        view.addSubview(amountLabel)
        view.addSubview(typeLabel)
        view.addSubview(dateLabel)
        view.addSubview(infoView)
        view.addSubview(detailButton)
        //back button
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(view).offset(20)
        }
        //type label
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.equalTo(view).offset(20)
        }
        //amount label
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.top).offset(30)
            make.leading.equalTo(view).offset(20)
        }
        //date label
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.top).offset(30)
            make.leading.equalTo(view).offset(20)
        }
        //detail button
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.top).offset(30)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.centerX.equalTo(view)
        }
        //more detail table(reciept or object)
        infoView.snp.makeConstraints{make in
            make.top.equalTo(detailButton.snp.bottom).offset(30)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    //update more detail table(reciept or object)
    private func updateDetail(){
        DatabaseManager.shared.getAllIncome(with: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let incomes):
                for income in incomes{
                    if selectedData.id == income.key{
                        let j : [String : Any] = income.value as! [String : Any]
                        let detail = j["detail"] as! String
                        UserManager.detailarr = detail.split(separator: "\n")
                    }
                }
            case .failure(let error):
                print("Failed to fetch point data for income: \(error.localizedDescription)")
            }
        }
        DatabaseManager.shared.getAllExpense(with: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let expenses):
                for expense in expenses{
                    if selectedData.id == expense.key{
                        let j : [String : Any] = expense.value as! [String : Any]
                        let detail = j["detail"] as! String
                        UserManager.detailarr = detail.split(separator: "\n")
                    }
                }
            case .failure(let error):
                print("Failed to fetch point data for expense: \(error.localizedDescription)")
            }
        }
    }
    
    //Function for click back button. It returns to home page.
    @objc private func backButtonTapped(_ sender:UIButton) {
        // back button tap
        UserManager.detailarr = []
        self.dismiss(animated: true, completion: nil)
    }
    //Function for click detail button. It refresh the more detail table(reciept or object).
    @objc private func detailButtonTapped(_ sender:UIButton) {
        // back button tap
        infoView.reloadData()
    }
    
    
}
