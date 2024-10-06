//
//  ViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/3/24.
//

import UIKit
import SnapKit
import Firebase

class ui{
    static var mint  = UIColor(red: 136/255, green: 227/255, blue: 205/255, alpha: 1)
    static var green = UIColor(red: 208/255, green: 230/255, blue: 165/255, alpha: 1)
    static var yellow = UIColor(red: 255/255, green: 221/255, blue: 149/255, alpha: 1)
    static var red = UIColor(red: 252/255, green: 136/255, blue: 122/255, alpha: 1)
    static var purple = UIColor(red: 206/255, green: 170/255, blue: 216/255, alpha: 1)
    static var pink = UIColor(red: 219/255, green: 162/255, blue: 176/255, alpha: 1)
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}



class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    private var container:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.carPlay,.sound]) { (granted, error) in
            if granted {
                print("Allow")
            }else{
                print("Don't Allow")
            }
        }
        createNotificationContent ()
        UNUserNotificationCenter.current().delegate = self
        
        self.container = UIView()
        container.backgroundColor = .white
        view.addSubview(container)
        
        let logoview = UIImageView()
        logoview.image = UIImage(named: "Logo")
        container.addSubview(logoview)
        //login button
        container.addSubview(loginButton)
        //signup button
        container.addSubview(signupButton)
        
        //text
        let textView = UILabel()
        textView.text = "Welcome"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = .gray
        container.addSubview(textView)
        
        container.snp.makeConstraints{make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-16)
        }
        
        logoview.snp.makeConstraints{make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
            
        }
        
        //text
        textView.snp.makeConstraints{make in
            make.bottom.equalToSuperview()
            
            make.centerX.equalToSuperview()
            
        }
        //signup
        signupButton.snp.makeConstraints{make in
            make.width.equalToSuperview()
            make.height.equalTo(42)
            
            make.bottom.equalTo(textView.snp.top).offset(-30)

        }
        //login
        loginButton.snp.makeConstraints{make in
            make.width.equalToSuperview()
            make.height.equalTo(42)
            
            make.bottom.equalTo(signupButton.snp.top).offset(-30)

        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
    }
    
    func createNotificationContent () {
        let content = UNMutableNotificationContent()
        content.title = "Monster Vault"
        content.subtitle = "Reminder"
        content.body = "Don't forget to take care of your pet!"
        content.badge = 1                                       //show on the top-right corner of the app icon
        content.sound = UNNotificationSound.defaultCritical     //notification sound
        
        var dateComponents = DateComponents()
        dateComponents.hour = 22 // 10pm
        dateComponents.minute = 0
        dateComponents.second = 0
        
        //without checking if the user has already used the app before 10pm
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for 10pm every day.")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .list, .sound])
    }
    
    @objc func LoginClick(_ sender:UIButton) {
        let lg = loginViewController()
        lg.modalPresentationStyle = .overFullScreen
        self.present(lg, animated: true, completion: nil)
    }
    
    @objc func SignupClick(_ sender:UIButton) {
        let sg = signupViewController()
        sg.modalPresentationStyle = .overFullScreen
        self.present(sg, animated: true, completion: nil)
    }
    
    lazy var loginButton: UIButton = {
        let x = UIButton(type:.system)
        x.setTitle("LOG IN", for: .normal)
        x.addTarget(self, action: #selector(LoginClick(_:)), for: .touchUpInside)
        x.backgroundColor = ui.mint
        x.layer.cornerRadius = 10
        x.setTitleColor(.black, for: .normal)
        x.setTitleColor(.gray, for: .highlighted)
        
        return x
    }()
    
    
    lazy var signupButton: UIButton = {
        let x = UIButton(type:.system)
        x.setTitle("SIGN UP", for: .normal)
        x.addTarget(self, action: #selector(SignupClick(_:)), for: .touchUpInside)
        x.backgroundColor = ui.mint
        x.layer.cornerRadius = 10
        x.setTitleColor(.black, for: .normal)
        x.setTitleColor(.gray, for: .highlighted)
        
        return x
    }()
    
}




