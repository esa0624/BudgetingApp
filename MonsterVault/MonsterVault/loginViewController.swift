//
//  loginViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/3/24.
//

import Foundation
import UIKit
import SnapKit
import Firebase
import FirebaseAuth


class loginViewController:UIViewController{
    private var logincontainer:UIView!

    //TextField for username
    private var usernameTextField : UITextField = {
        
        let x = UITextField()
        x.borderStyle = UITextField.BorderStyle.roundedRect
        let placeholderText = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        x.attributedPlaceholder = placeholderText
        x.backgroundColor = .white
        x.layer.borderWidth = 2
        x.textColor = .gray
        x.layer.borderColor = UIColor(red: 136/255, green: 227/255, blue: 205/255, alpha: 1).cgColor
        x.layer.cornerRadius = 8
        return x
        
    }()
    //TextField for password
    private var passwordTextField : UITextField = {
        
        let x = UITextField()
        x.borderStyle = UITextField.BorderStyle.roundedRect
        let placeholderText = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        x.attributedPlaceholder = placeholderText
        x.backgroundColor = .white
        x.layer.borderWidth = 2
        x.textColor = .gray
        x.layer.borderColor = UIColor(red: 136/255, green: 227/255, blue: 205/255, alpha: 1).cgColor
        x.layer.cornerRadius = 8
        return x
        
    }()
    // login button
    lazy var loginButton: UIButton = {
        let x = UIButton(type:.system)
        x.setTitle("Login", for: .normal)
        x.addTarget(self, action: #selector(loginClick(_:)), for: .touchUpInside)
        x.backgroundColor = ui.mint
        x.layer.cornerRadius = 10
        x.setTitleColor(.black, for: .normal)
        x.setTitleColor(.gray, for: .highlighted)
        return x
    }()
    //back button
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backClick(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //container
        self.logincontainer = UIView()
        view.addSubview(logincontainer)
        logincontainer.backgroundColor = .white
        
        //back
        view.addSubview(backButton)
        
        //username input
        logincontainer.addSubview(usernameTextField)
        
        //password input
        logincontainer.addSubview(passwordTextField)
        
        //login button
        logincontainer.addSubview(loginButton)
        
        //container that contains all textfield and button(more convinient for future change)
        logincontainer.snp.makeConstraints{make in
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
            make.top.equalTo(logincontainer.snp.top).offset(100)
        }
        
        //password
        passwordTextField.snp.makeConstraints{make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(usernameTextField.snp.bottom).offset(30)
        }
        //login
        loginButton.snp.makeConstraints{make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.width.equalToSuperview().offset(-200)
            make.height.equalTo(40)
        }
        
        
    }
    //Function for click login button
    @objc func loginClick(_ sender:UIButton){
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!, completion: { (result, error) in
          if error == nil {
              UserManager.cuser = result?.user
              print(UserManager.cuser?.uid)
              DatabaseManager.shared.getInstructionData(uid: UserManager.cuser!.uid) { result in
                  switch result {
                  case .success(let instructionData):
                      guard let currentBool = instructionData["bool"] as? Int else {
                          print("ERROR!")
                          return
                      }
                      
                      if currentBool == 0{
                          let ins = instructionViewController()
                          ins.modalPresentationStyle = .overFullScreen
                          self.present(ins, animated: true, completion: nil)
                      } else {
                          let h = homeViewController()
                          h.modalPresentationStyle = .overFullScreen
                          self.present(h, animated: true, completion: nil)
                      }
                      
                  case .failure(let error):
                      print("Failed to fetch instruction data: \(error.localizedDescription)")
                  }
              }

          } else {
              let errormessage = String(error!.localizedDescription)
              self.showAlert(message: errormessage)
          }
        })
        
    }

    //Function for click back button
    @objc func backClick(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //Function for show error message
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}

