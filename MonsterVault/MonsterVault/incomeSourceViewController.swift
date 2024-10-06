//
//  incomeSourceViewController.swift
//  IncomeTest
//
//  Created by Chih-Hsin Chen on 2/12/24.
//

import Foundation
import UIKit
import SnapKit

class incomeSourceViewController: UIViewController {
    
    // Variable to store the user's choice
    var didSelectedSource: ((String) -> Void)?
    
    // Declare a view for top background
    lazy var topBackgroundView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    // Declare a label to show the title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Source"
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
    
    // Declare a wage button for the user to click on
    lazy var wageButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "wage")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(80.0, 80.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(wageButtonTapped(_:)), for: .touchUpInside)
        
        // Add label to the button
        let label = UILabel()
        label.text = "Wages"
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
    
    // Declare an investment button for the user to click on
    lazy var investmentButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "investment")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(80.0, 80.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(investmentButtonTapped(_:)), for: .touchUpInside)
        // Add label to the button
        let label = UILabel()
        label.text = "Investments"
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
    
    // Declare an bonus button for the user to click on
    lazy var bonusButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "bonus")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(80.0, 80.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(bonusButtonTapped(_:)), for: .touchUpInside)
        // Add the label to button
        let label = UILabel()
        label.text = "Bonuses"
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
        // Use stack view to arrange the source buttons
        let stackView = UIStackView(arrangedSubviews: [wageButton, investmentButton, bonusButton])
        stackView.axis = .horizontal            // in horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        view.addSubview(stackView)
        
        // Set constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topBackgroundView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            stackView.heightAnchor.constraint(equalToConstant: 110)
        ])
        
    }
    
    // Function to handle user's click on back button
    @objc private func backButtonTapped(_ sender:UIButton) {
        // back button tap
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle user's click on wage button
    @objc private func wageButtonTapped(_ sender:UIButton) {
        didSelectedSource?("Wages")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle user's click on investment button
    @objc private func investmentButtonTapped(_ sender:UIButton) {
        didSelectedSource?("Investments")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle user's click on bonus button
    @objc private func bonusButtonTapped(_ sender:UIButton) {
        didSelectedSource?("Bonuses")
        self.dismiss(animated: true, completion: nil)
    }
    
}

