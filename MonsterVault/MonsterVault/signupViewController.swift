//
//  signupViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/3/24.
//

import Foundation
import UIKit
import SnapKit
import Firebase
import FirebaseAuth

class signupViewController:UIViewController{
    private var signupcontainer:UIView!
    private var user: User?
    //Text field for username
    private var usernameTextField : UITextField = {
        
        let x = UITextField()
        x.borderStyle = UITextField.BorderStyle.roundedRect
        let placeholderText = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        x.attributedPlaceholder = placeholderText
        x.backgroundColor = .white
        x.textColor = .gray
        x.layer.borderWidth = 2
        x.layer.borderColor = UIColor(red: 136/255, green: 227/255, blue: 205/255, alpha: 1).cgColor
        x.layer.cornerRadius = 8
        return x
        
    }()
    //Text field for password
    private var passwordTextField : UITextField = {
        
        let x = UITextField()
        x.borderStyle = UITextField.BorderStyle.roundedRect
        let placeholderText = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        x.attributedPlaceholder = placeholderText
        x.textColor = .gray
        x.backgroundColor = .white
        x.layer.borderWidth = 2
        x.layer.borderColor = UIColor(red: 136/255, green: 227/255, blue: 205/255, alpha: 1).cgColor
        x.layer.cornerRadius = 8
        return x
        
    }()
    //Button for sign up
    lazy var signupButton: UIButton = {
        let x = UIButton(type:.system)
        x.setTitle("Signup", for: .normal)
        x.addTarget(self, action: #selector(signupClick(_:)), for: .touchUpInside)
        x.backgroundColor = ui.mint
        x.layer.cornerRadius = 10
        x.setTitleColor(.black, for: .normal)
        x.setTitleColor(.gray, for: .highlighted)
        return x
    }()
    //Button for back
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backClick(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        self.signupcontainer = UIView()
        view.addSubview(signupcontainer)
        signupcontainer.backgroundColor = .white
        
        //back
        view.addSubview(backButton)
        
        //username input
        signupcontainer.addSubview(usernameTextField)
        
        //password input
        signupcontainer.addSubview(passwordTextField)
        
        //login button
        signupcontainer.addSubview(signupButton)
        
        //signup button
        signupcontainer.snp.makeConstraints{make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-100)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-20)
        }
        //back
        backButton.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(view).offset(20)
        }
        
        //username
        usernameTextField.snp.makeConstraints{make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(signupcontainer.snp.top).offset(100)
        }
        
        //password
        passwordTextField.snp.makeConstraints{make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(usernameTextField.snp.bottom).offset(30)
        }
        //login
        signupButton.snp.makeConstraints{make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.width.equalToSuperview().offset(-200)
            make.height.equalTo(40)
        }
        
        
    }
    
    // function for click the signup button
    @objc func signupClick(_ sender:UIButton) {
        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
          if error == nil {
              self.showAlert_succ(message: "Successfully create the account, return back to login.")
              
              DatabaseManager.shared.setDefaultPoints(uid: user!.user.uid)
              DatabaseManager.shared.setDefaultPet(uid: user!.user.uid)
              DatabaseManager.shared.setDefaultBool(uid: user!.user.uid)
          } else {
              let errormessage = String(error!.localizedDescription)
              self.showAlert_error(message: errormessage)
          }
        })
        

    }
    //Function for click back button
    @objc func backClick(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //Function for show error message when creating account.
    private func showAlert_error(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    //Function for show message when successfully creating account.
    private func showAlert_succ(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            self.back()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    //Go back to the home page
    private func back() {
        // Update the sourceButton title with the selected source
        self.dismiss(animated: true, completion: nil)
    }
}

