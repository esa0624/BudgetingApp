//
//  scanobjectViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/4/24.
//
import Foundation
import UIKit
import Vision
import SnapKit


class scanobjectViewController:UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    private var selectedCategory: String?
    private var objectdetail: String! = ""
    private var objects: [String] = []
    private var imagePicker:UIImagePickerController!
    //top colored bar
    lazy var topBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    //top title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Object Scanner"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    //open object detector
    lazy var inputButton: UIButton = {
        let x = UIButton(type: .system)
        x.translatesAutoresizingMaskIntoConstraints = false
        x.backgroundColor = ui.mint
        x.setTitle("Object Detect", for: .normal)
        x.setTitleColor(.black, for: .normal)
        x.layer.cornerRadius = 10
        x.addTarget(self, action: #selector(uploadImage(_:)), for: .touchUpInside)
        return x
    }()
    //back button
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backClick(_:)), for: .touchUpInside)
        return button
    }()
    //text field for input amount
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    //choose category
    lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose Category", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 136/255, green: 227/255, blue: 205/255, alpha: 1)
        button.addTarget(self, action: #selector(showCategoryOptions(_:)), for: .touchUpInside)
        return button
    }()
    //icon for amount
    lazy var amountImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "amount")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(30.0, 30.0))
        imageView.image = scaledImage
        return imageView
    }()
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
    //select the objects detected
    lazy var objectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose Object detected", for: .normal)
        button.addTarget(self, action: #selector(showObjectOptions(_:)), for: .touchUpInside)
        return button
    }()
    //main
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
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(view).offset(20)
        }
        //text field for amount input
        view.addSubview(amountTextField)
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view).inset(20)
        }
        amountTextField.leftView = amountImageView
        amountTextField.leftViewMode = .always
                
        //button for select category
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
        //open object detector
        view.addSubview(inputButton)
        inputButton.snp.makeConstraints{make in
            make.top.equalTo(recordButton.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(50)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-50)
        }
        //select the objects detected
        view.addSubview(objectButton)
        objectButton.snp.makeConstraints{make in
            make.top.equalTo(inputButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
    }
    //object detector
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        
            guard let image = info[.editedImage] as? UIImage,
            let cgimage = image.cgImage else{
                return
            }
            
            
            let requestHandler = VNImageRequestHandler(cgImage: cgimage)
            let request = VNClassifyImageRequest(completionHandler: recognizeObjectHandler)

            
            picker.dismiss(animated: true)
            
            do {
                try requestHandler.perform([request])
              } catch {
                print("Unable to perform the requests: \(error).")
              }
            
    }
    //recognize object based on the given model
    private func recognizeObjectHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNClassificationObservation] else {
            return
        }
        var recognizedObject = [String]()
        print (observations)
        for result in observations where result.confidence > 0.4{
            
            recognizedObject.append(result.identifier)
        }
        
        objects = recognizedObject
        
    }
    //function for click back button. return to home page
    @objc private func backClick(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //function for click upload image button.
    @objc private func uploadImage(_ sender: UIButton){
        self.present(imagePicker, animated: true)
    }
    
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
    //update category title when it changed
    private func updateCategoryButtonTitle() {
        // Update the sourceButton title with the selected source
        categoryButton.setTitle("Category: \(selectedCategory!)", for: .normal)
    }
    //upate object title when it changed
    private func updateObjectButtonTitle() {
        // Update the sourceButton title with the selected source
        objectButton.setTitle("Object: \(objectdetail!)", for: .normal)
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
        
        DatabaseManager.shared.addExpense(uid: UserManager.cuser!.uid, amount: amountDouble, category: selectedCategory, date: currentDate, detail: objectdetail!)
        DatabaseManager.shared.updatePoints(uid: UserManager.cuser!.uid)

        // navigate back to the calendar page
        self.dismiss(animated: true, completion: nil)
    }
    //function for click choose object button. it shows all objects detected
    @objc private func showObjectOptions(_ sender:UIButton) {
        let alertController = UIAlertController(title: "Choose the Object", message: nil, preferredStyle: .actionSheet)
        
        for object in objects{
            let Action = UIAlertAction(title: object, style: .default) { _ in
                self.objectdetail = object
                self.updateObjectButtonTitle()
            }
            alertController.addAction(Action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    //function for showing alert based on given message
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    
}


