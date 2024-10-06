//
//  scantextViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/3/24.
//
import Foundation
import UIKit
import Vision
import SnapKit


class scantextViewController:UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipt.count
    }
    //table that store reicpt information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell";
                
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
                
        cell.textLabel?.text = String(receipt[indexPath.row])
        return cell
    }
    
    private var imagePicker:UIImagePickerController!
    private var selectedCategory: String?
    private var receiptdetail : String = ""
    private var receipt: [String] = []
    //top colored bar
    lazy var topBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    //top title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Receipt Scanner"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    //tabel that store reciept
    lazy var infoView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor(red: 136/255, green: 227/255, blue: 205/255, alpha: 1).cgColor
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
   
    //scan reciept button
    lazy var inputButton: UIButton = {
        let x = UIButton(type: .system)
        x.translatesAutoresizingMaskIntoConstraints = false
        x.backgroundColor = ui.mint
        x.setTitle("Scan receipt", for: .normal)
        x.setTitleColor(.black, for: .normal)
        x.layer.cornerRadius = 10
        x.addTarget(self, action: #selector(uploadImage(_:)), for: .touchUpInside)
        return x
        
    }()
    //icon for amount input
    lazy var amountImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "amount")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(30.0, 30.0))
        imageView.image = scaledImage
        return imageView
    }()
    
    //back button
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backClick(_:)), for: .touchUpInside)
        return button
    }()
    //textfiled for amount input
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    //category button
    lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose Category", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 136/255, green: 227/255, blue: 205/255, alpha: 1)
        button.addTarget(self, action: #selector(showCategoryOptions(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        //top colored bar
        view.addSubview(topBackgroundView)
        topBackgroundView.backgroundColor = ui.mint
        topBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-60)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            //make.bottom.equalTo(pointsLabel.snp.bottom).offset(15)
            make.height.equalTo(115)
        }
        
        //top title
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
            make.centerX.equalTo(view)
            
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        //back button
        view.addSubview(backButton)
        backButton.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(view).offset(20)
        }

        //textfield for amount input
        view.addSubview(amountTextField)
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view).inset(20)
        }
        amountTextField.leftView = amountImageView
        amountTextField.leftViewMode = .always

        //category button
        view.addSubview(categoryButton)
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(50)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-50)
            make.centerX.equalTo(view)
        }
        //record button
        view.addSubview(recordButton)
        recordButton.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(50)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-50)
            make.centerX.equalTo(view)
        }
        //input button
        view.addSubview(inputButton)
        inputButton.snp.makeConstraints{make in
            make.top.equalTo(recordButton.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(50)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-50)
            make.centerX.equalTo(view)
        }
        
        //reciept table
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(inputButton.snp.bottom).offset(20)
            make.height.equalTo(550)
            //make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(40)
            
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
        }
        
        
    }
    
    //reciept scanner
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        
            guard let image = info[.editedImage] as? UIImage,
            let cgimage = image.cgImage else{
                return
            }
            imageView.image = image
            
            let requestHandler = VNImageRequestHandler(cgImage: cgimage)
            let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
            
            
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["ja-JP", "zh-Hans", "zh-Hant", "en-US",]
            
            picker.dismiss(animated: true)
            
            do {
                try requestHandler.perform([request])
              } catch {
                print("Unable to perform the requests: \(error).")
              }
            
    }
    //recognize text on reciept based on the given model
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
    
        receiptdetail = recognizedStrings.joined(separator: "\n")
        self.receipt = recognizedStrings
        //self.receiptLable.text = receiptdetail
        self.infoView.reloadData()
    }
    //function for click back button. return to home page
    @objc private func backClick(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //function for click upload image button.
    @objc private func uploadImage(_ sender: UIButton){
        self.present(imagePicker, animated: true)
    }
    
    //record button
    lazy var recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Record", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 136/255, green: 227/255, blue: 205/255, alpha: 1)
        button.addTarget(self, action: #selector(recordExpense(_:)), for: .touchUpInside)
        return button
    }()
    //function for click category button. it shows the category otption
    @objc private func showCategoryOptions(_ sender:UIButton) {
        let expenseCategoryVC = expenseCategoryViewController()
        expenseCategoryVC.didSelectedCategory = { [weak self] category in
            self?.selectedCategory = category
            self?.updateCategoryButtonTitle()
            print(self?.selectedCategory)
            
        }
        present(expenseCategoryVC, animated: true, completion: nil)
    }
    
    private func updateCategoryButtonTitle() {
        // Update the sourceButton title with the selected source
        categoryButton.setTitle("Category: \(selectedCategory!)", for: .normal)
    }
    //function for record button. it store the data and return to home page
    @objc private func recordExpense(_ sender:UIButton) {
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
        // TODO: store data to database
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        
        DatabaseManager.shared.addExpense(uid: UserManager.cuser!.uid, amount: amountDouble, category: selectedCategory, date: currentDate, detail: receiptdetail)
        DatabaseManager.shared.updatePoints(uid: UserManager.cuser!.uid)

        // navigate back to the calendar page
        self.dismiss(animated: true, completion: nil)
    }
    
    //function for showing alert based on given message
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

