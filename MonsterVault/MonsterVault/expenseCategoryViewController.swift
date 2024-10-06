//
//  expenseCategoryViewController.swift
//  IncomeTest
//
//  Created by Chih-Hsin Chen on 2/12/24.
//

import Foundation
import UIKit
import SnapKit

class expenseCategoryViewController: UIViewController {
    
    // Variable to store the user's choice
    var didSelectedCategory: ((String) -> Void)?

    // Declare a view for top background
    lazy var topBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    // Declare a label to show the title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    // Declare a Back button on the left-top corner
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // Declare a food button for the user to click on
    lazy var foodButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "food")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(80.0, 80.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(foodButtonTapped(_:)), for: .touchUpInside)
        
        // Add label to the button
        let label = UILabel()
        label.text = "Food"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(2)
        }
        return button
    }()
    
    // Declare a clothes button for the user to click on
    lazy var clothesButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "clothes")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(80.0, 80.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(clothesButtonTapped(_:)), for: .touchUpInside)
        // Add label to the button
        let label = UILabel()
        label.text = "Clothes"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(2)
        }
        return button
    }()
    
    // Declare a housing button for the user to click on
    lazy var housingButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "house")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(80.0, 80.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(housingButtonTapped(_:)), for: .touchUpInside)
        // Add label to the button
        let label = UILabel()
        label.text = "Housing"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(2)
        }
        return button
    }()
    
    // Declare a transportation button for the user to click on
    lazy var transportationButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "transportation")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(80.0, 80.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(transportationButtonTapped(_:)), for: .touchUpInside)
        // Add label to the button
        let label = UILabel()
        label.text = "Transportation"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(2)
        }
        return button
    }()
    
    // Declare a academy button for the user to click on
    lazy var academyButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "academy")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(80.0, 80.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(academyButtonTapped(_:)), for: .touchUpInside)
        // Add label to the button
        let label = UILabel()
        label.text = "Academy"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(2)
        }
        return button
    }()
    
    // Declare a entertainment button for the user to click on
    lazy var entertainButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "entertainment")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(80.0, 80.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(entertainButtonTapped(_:)), for: .touchUpInside)
        // Add label to the button
        let label = UILabel()
        label.text = "Entertainment"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(2)
        }
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
            make.height.equalTo(130)
        }
        
        // Add to self view and set contraints
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(view).offset(20)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(view)
            
        }
        // Use stack view to arrange the category buttons
        // Separate into two rows, each has three buttons
        // First row for food, clothes, housing
        let firstRowStackView = UIStackView(arrangedSubviews: [foodButton, clothesButton, housingButton])
        firstRowStackView.axis = .horizontal
        firstRowStackView.alignment = .fill
        firstRowStackView.distribution = .fillEqually
        firstRowStackView.spacing = 20
        
        // Second row for transportation, academy, entertainment
        let secondRowStackView = UIStackView(arrangedSubviews: [transportationButton, academyButton, entertainButton])
        secondRowStackView.axis = .horizontal
        secondRowStackView.alignment = .fill
        secondRowStackView.distribution = .fillEqually
        secondRowStackView.spacing = 20
        
        // Use a new stack view to hold the first row stack view and the second row stack view
        let verticalStackView = UIStackView(arrangedSubviews: [firstRowStackView, secondRowStackView])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 20
        
        // Set constraints
        view.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topBackgroundView.bottomAnchor, constant: 20),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            verticalStackView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
    
        
    }
    
    // Function to handle user's click on back button
    @objc private func backButtonTapped(_ sender:UIButton) {
        // back button tap
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle user's click on food button
    @objc private func foodButtonTapped(_ sender:UIButton) {
        didSelectedCategory?("Food")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle user's click on clothes button
    @objc private func clothesButtonTapped(_ sender:UIButton) {
        didSelectedCategory?("Clothes")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle user's click on housing button
    @objc private func housingButtonTapped(_ sender:UIButton) {
        didSelectedCategory?("Housing")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle user's click on transportation button
    @objc private func transportationButtonTapped(_ sender:UIButton) {
        didSelectedCategory?("Transportation")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle user's click on academy button
    @objc private func academyButtonTapped(_ sender:UIButton) {
        didSelectedCategory?("Academy")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle user's click on entertainment button
    @objc private func entertainButtonTapped(_ sender:UIButton) {
        didSelectedCategory?("Entertainment")
        self.dismiss(animated: true, completion: nil)
    }
}


