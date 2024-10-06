//
//  userViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/8/24.
//

import Foundation
import UIKit
import SnapKit
import FirebaseAuth

class userViewController: UIViewController {
    //top colored bar
    lazy var topBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    //top title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "User"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
    //email address
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email: \(UserManager.cuser!.email!)"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    //log out button
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log out", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 136/255, green: 227/255, blue: 205/255, alpha: 1)
        button.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
        return button
    }()
    //main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //place top colored bar
        view.addSubview(topBackgroundView)
        topBackgroundView.backgroundColor = ui.mint
        topBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-60)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            //make.bottom.equalTo(pointsLabel.snp.bottom).offset(15)
            make.height.equalTo(115)
        }
        //place back button
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(view).offset(20)
        }
        //place top title
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
            make.centerX.equalTo(view)
            
        }
        //place email
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints{make in
            make.top.equalTo(topBackgroundView.snp.bottom).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.centerX.equalTo(view)
        }
        //place log out button
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.centerX.equalTo(view)
        }
    }
    //Function for click back button. It returns to home page.
    @objc private func backButtonTapped(_ sender:UIButton) {
        // back button tap
        //self.dismiss(animated: true, completion: nil)
        if let parentVC = parent as? homeViewController {
                parentVC.showCalendarView3()
        }
        //delegate?.didTapBackButton()
    }
    //Function for click log out button. It returns to start page.
    @objc private func logout(_ sender:UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        var empty: User?
        UserManager.cuser = empty
        print(UserManager.cuser)
    }
    
    
}
