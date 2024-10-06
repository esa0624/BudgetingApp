//
//  expenseViewController.swift
//  IncomeTest
//
//  Created by Chih-Hsin Chen on 2/12/24.
//

import Foundation
import UIKit
import SnapKit


class expenseViewController: UIViewController {
    // Variable to store the category the user chose
    private var selectedCategory: String?
    
    // Declare a view for top background
    lazy var topBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    // Declare a label to show title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Expense"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    // Declare a label to display the selected date
    private let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    // Declare a view to to show amount
    lazy var amountImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "amount")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(30.0, 30.0))
        imageView.image = scaledImage
        return imageView
    }()
    
    // Declare a view to show details
    lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "detail")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(30.0, 30.0))
        imageView.image = scaledImage
        return imageView
    }()
    
    // Declare a textfleid for user to input amount
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // Declare a textfleid for user to input amount
    private let detailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Detail (Optional)"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // Declare a Category button for user to choose category
    lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = ui.mint
        button.setTitle("Choose Category", for: .normal)
        button.addTarget(self, action: #selector(showCategoryOptions(_:)), for: .touchUpInside)
        return button
    }()
    
    // Declare a Record button to record the input by the user
    lazy var recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Record", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = ui.mint
        button.addTarget(self, action: #selector(recordExpense(_:)), for: .touchUpInside)
        
        // Add record icon to it
        let imageView = UIImageView()
        let image = UIImage(named: "record")
        // Resize the icon image
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(20.0, 20.0))
        imageView.image = scaledImage
        
        button.addSubview(imageView)
        imageView.snp.makeConstraints{ make in
            make.top.equalTo(button.snp.top).offset(5)
            make.left.equalTo(button.snp.left).offset(3)
        }
        return button
    }()
    
    // Declare a Back button on the left-top corner
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.tintColor = .black
        // add function that handles the user click
        button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Start with topbackgroundview
        view.addSubview(topBackgroundView)
        topBackgroundView.backgroundColor = ui.mint
        topBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-60)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            //make.bottom.equalTo(pointsLabel.snp.bottom).offset(15)
            make.height.equalTo(115)
        }
        
        // Add UI components to the view
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(selectedDateLabel)
        view.addSubview(amountTextField)
        view.addSubview(categoryButton)
        view.addSubview(recordButton)
        view.addSubview(detailTextField)
        
        backButton.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(view).offset(20)
        }
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
            make.centerX.equalTo(view)
            
        }

        // Set up constraints
        selectedDateLabel.snp.makeConstraints {make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }

        amountTextField.snp.makeConstraints {make in
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        
        detailTextField.snp.makeConstraints {make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        // Add icons
        amountTextField.leftView = amountImageView
        amountTextField.leftViewMode = .always
        detailTextField.leftView = detailImageView
        detailTextField.leftViewMode = .always
        
        categoryButton.snp.makeConstraints {make in
            make.top.equalTo(detailTextField.snp.bottom).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.centerX.equalTo(view)
        }

        recordButton.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(30)
            make.width.equalTo(95)
            make.trailing.equalTo(view).inset(20)
        }
    }
    
    // Function to display all category options by calling out the expenseCategoryViewController page
    @objc private func showCategoryOptions(_ sender:UIButton) {
        let expenseCategoryVC = expenseCategoryViewController()
        expenseCategoryVC.didSelectedCategory = { [weak self] category in
            self?.selectedCategory = category
            self?.updateCategoryButtonTitle()
            print(self?.selectedCategory)
            
        }
        present(expenseCategoryVC, animated: true, completion: nil)
    }
    
    // Function to update the category button title to the category the user chose
    private func updateCategoryButtonTitle() {
        // Update the categoryButton title with the selected category
        categoryButton.setTitle("Category: \(selectedCategory!)", for: .normal)
    }
    
    // Function to handle user's click on back button
    @objc func backButtonTapped(_ sender:UIButton) {
        // back button tap
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle if the user click on record button
    @objc func recordExpense(_ sender:UIButton) {
        guard let amount = amountTextField.text, !amount.isEmpty, let selectedCategory = selectedCategory else {
            // show an alert if any required field is missing
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        guard let amountDouble = Double(amount) else {
            print("Error!")
            return
        }
        // Perform the record operation
        // store data to database
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        
        DatabaseManager.shared.addExpense(uid: UserManager.cuser!.uid, amount: amountDouble, category: selectedCategory, date: currentDate, detail: detailTextField.text!)
        DatabaseManager.shared.updatePoints(uid: UserManager.cuser!.uid)

        // Navigate back to the calendar page
        self.dismiss(animated: true, completion: nil)
    }
    
    // Show a message box to show the alert
    // Allow user to click OK
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}



