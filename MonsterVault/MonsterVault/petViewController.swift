//
//  petViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/3/24.
//

import Foundation
import UIKit
import SnapKit
import Charts

class petViewController: UIViewController {
    
    // Variable to store pet level
    private var petLevel: Int!
    
    // Views to display animation
    private var petImageView: UIImageView!
    private var walkingImageView: UIImageView!
    private var feedingImageView: UIImageView!
    
    // Timer set for changing animation
    private var walkingTimer: Timer?
    private var feedingTimer: Timer?
    
    // Records if it is currently displaying the walking animation
    private var currentWalkingImageIndex = 0
    // Boolean to check if we can display the walking animation
    private var isWalkingEnabled = false
    // Records if it is currently displaying the feeding animation
    private var isFeedingInProgress = false
    
    // Declare a view for top background
    lazy var topBackgroundView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    // Declare a Back button on the left-top corner
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // Declare a view to show points icon image
    lazy var pointsIconImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "point")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(30.0, 30.0))
        imageView.image = scaledImage
        return imageView
    }()
    
    // Declare a label to show the amount of points
    lazy var pointsLabel: UILabel = {
        let label = UILabel()
        // Get point data from point table in database
        DatabaseManager.shared.getPointData(uid: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let pointData):
                guard let currentPoints = pointData["point"] as? Double else {
                    print("ERROR!")
                    return
                }
                // updatethe label text based on data
                label.text = "Points: \(currentPoints)"
            case .failure(let error):
                print("Failed to fetch point data for buying: \(error.localizedDescription)")
            }
        }
        return label
    }()
    
    // Declare a progress view to show the experience
    lazy var experienceBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .green
        // Get experience data from pet table in database
        DatabaseManager.shared.getPetData(uid: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let petData):
                guard let currentExperience = petData["experience"] as? Double else {
                    print("ERROR!")
                    return
                }
                // Divide the experience by 100 since the max is 100
                progressView.setProgress(Float(currentExperience / 100.0), animated: true)
                
            case .failure(let error):
                print("Failed to fetch pet data: \(error.localizedDescription)")
            }
        }
        return progressView
    }()
    
    // Declare a label to show the pet's level
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        // Get level data from pet table in database
        DatabaseManager.shared.getPetData(uid: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let petData):
                guard let currentLevel = petData["level"] as? Double else {
                    print("ERROR!")
                    return
                }
                // Update lable text
                label.text = "Level: \(Int(currentLevel))"
                
            case .failure(let error):
                print("Failed to fetch pet data: \(error.localizedDescription)")
            }
        }
        return label
    }()
    
    // Declare a view for bottom background
    lazy var bottomBackgroundView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    // Declare a buy button for the user to click on
    lazy var buyButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "buy")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(30.0, 30.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(buyButtonTapped(_:)), for: .touchUpInside)
        
        // Add label to the button
        let label = UILabel()
        label.text = "Buy"
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
    
    // Declare a bag button for the user to click on
    lazy var bagButton: UIButton = {
        let button = UIButton(type: .system)
        // Add icon
        let image = UIImage(named: "bag")
        let scaledImage = ui.resizeImage(image: image!, targetSize: CGSizeMake(30.0, 30.0))
        button.setBackgroundImage(scaledImage, for: .normal)
        button.addTarget(self, action: #selector(bagButtonTapped(_:)), for: .touchUpInside)
        // Add label to the button
        let label = UILabel()
        label.text = "Backpack"
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
            make.height.equalTo(100)
        }
        // Add to self view and set contraints
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(view).offset(20)
        }
        view.addSubview(pointsLabel)
        pointsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.trailing.equalTo(view).offset(-20)
        }

        view.addSubview(pointsIconImageView)
        pointsIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(pointsLabel)
            make.trailing.equalTo(pointsLabel.snp.leading).offset(-5)
        }

        // Set a rectangle view for displaying the animation
        let rectangleView = UIView()
        //rectangleView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        rectangleView.backgroundColor = .white
        view.addSubview(rectangleView)
        rectangleView.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundView.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        // Add experienceBar, levelLabel, and bottomBackgroundView
        view.addSubview(experienceBar)
        experienceBar.trackTintColor = .black
        experienceBar.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundView.snp.bottom).offset(15)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(100)
        }
        view.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(experienceBar.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(20)
        }
        view.addSubview(bottomBackgroundView)
        bottomBackgroundView.backgroundColor = ui.mint
        bottomBackgroundView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            //make.top.equalTo(buyButton.snp.top)
        }
        // Add two buttons
        view.addSubview(buyButton)
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(bottomBackgroundView.snp.top).offset(15)
            make.trailing.equalTo(view).offset(-30)
        }
        view.addSubview(bagButton)
        bagButton.snp.makeConstraints { make in
            make.top.equalTo(bottomBackgroundView.snp.top).offset(15)
            make.leading.equalTo(view).offset(30)
        }
        
        // Initialize a view for displaying the pet animation
        petImageView = UIImageView()
        view.addSubview(petImageView)
        petImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(500)
            make.height.equalTo(500)
        }
        // Get pet data to determine which animation of levels it is going to display
        DatabaseManager.shared.getPetData(uid: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let petData):
                // Get current level
                let currentLevel = petData["level"] as! Int
                
                // Load the egg animation if the pet is in level 0
                // Otherwise, show monster animation
                if currentLevel == 0{
                    let images = self.loadBabyPetImages()
                    self.petImageView.animationImages = images
                    // Set the last view to make the pet standing there is animation is not playing
                    self.petImageView.image = images.last
                } else {
                    let images = self.loadPetImages()
                    self.petImageView.animationImages = images
                    // Set the last view to make the pet standing there is animation is not playing
                    self.petImageView.image = images.last
                }
                // Set the duration and repeat count of the animation
                self.petImageView.animationDuration = 8.0
                self.petImageView.animationRepeatCount = 1
                // Enable user interaction
                self.petImageView.isUserInteractionEnabled = true
                
                // Use UITapGestureRecognizer to detect if the user tap on the animation
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handlePetTap))
                self.petImageView.addGestureRecognizer(tapGesture)
                
                // Start animating
                self.petImageView.startAnimating()
                
                // Initialize a view for displaying the animation ofthe pet walking
                self.walkingImageView = UIImageView()
                self.view.addSubview(self.walkingImageView)
                self.walkingImageView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(500)
                    make.height.equalTo(500)
                }
                // Hide it at the first when the user doesn't tap on it
                self.walkingImageView.isHidden = true
                
                // Initialize a view for displaying the animation ofthe pet is being feed
                self.feedingImageView = UIImageView()
                self.view.addSubview(self.feedingImageView)
                self.feedingImageView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(500)
                    make.height.equalTo(500)
                }
                // Hide it at the first when the user doesn't feed the pet
                self.feedingImageView.isHidden = true
            case .failure(let error):
                print("Failed to fetch pet data: \(error.localizedDescription)")
            }
        }
    }
    
    // Function to display the feeding animation
    @objc private func loadFeedingAnimation() {
        // Set the boolean to be true
        self.isFeedingInProgress = true
        // Hide the pet view and make the feeding view unhidden
        petImageView.isHidden = true
        feedingImageView.isHidden = false
        
        // Get pet data to determine which animation of levels it is going to display
        DatabaseManager.shared.getPetData(uid: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let petData):
                // Get current level
                let currentLevel = petData["level"] as! Int
                
                // Load the egg animation if the pet is in level 0
                // Otherwise, show monster animation
                if currentLevel == 0{
                    // Reset the image
                    self.feedingImageView.image = nil
                    // Call the function to load a series of images
                    let feedingImages = self.loadBabyFeedingImages()
                    self.feedingImageView.animationImages = feedingImages
                } else {
                    // Call the function to load a series of images and update the pet
                    let images = self.loadPetImages()
                    self.petImageView.animationImages = images
                    self.petImageView.image = images.last
                    
                    // Reset the image
                    self.feedingImageView.image = nil
                    // Call the function to load a series of images
                    let feedingImages = self.loadFeedingImages()
                    self.feedingImageView.animationImages = feedingImages
                }
                // Set the duration and repeat count of the animation
                self.feedingImageView.animationDuration = 5.0
                self.feedingImageView.animationRepeatCount = 1
                self.feedingImageView.startAnimating()
                
                // Schedule timer to transition back to petImageView after feeding animation completes
                self.feedingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
                    guard let self = self else { return }
                    // After finishing diaplying, make it hidden again
                    self.feedingImageView.isHidden = true
                    if currentLevel == 0{
                        // The baby animation
                        let images = self.loadBabyPetImages()
                        self.petImageView.animationImages = images
                        // Set the last view to make the pet standing there is animation is not playing
                        self.petImageView.image = images.last
                    } else {
                        // The monster animation
                        let images = self.loadPetImages()
                        self.petImageView.animationImages = images
                        // Set the last view to make the pet standing there is animation is not playing
                        self.petImageView.image = images.last
                    }
                    // Make the pet view unhidden and turn the boolean for feeding to false
                    self.petImageView.isHidden = false
                    self.isFeedingInProgress = false
                }

            case .failure(let error):
                print("Failed to fetch pet data: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func loadWalkingAnimation() {
        // Show walkingImageView and hide petImageView
        petImageView.isHidden = true
        walkingImageView.isHidden = false
        
        // Get pet data to determine which animation of levels it is going to display
        DatabaseManager.shared.getPetData(uid: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let petData):
                // Get current level
                let currentLevel = petData["level"] as! Int
                
                // Load the egg animation if the pet is in level 0
                // Otherwise, show monster animation
                if currentLevel == 0{
                    // Reset the image
                    self.walkingImageView.image = nil
                    // Call the function to load a series of images
                    let walkingImages = self.loadBabyWalkingImages()
                    self.walkingImageView.animationImages = walkingImages
                } else{
                    // Call the function to load a series of images and update the pet
                    let images = self.loadPetImages()
                    self.petImageView.animationImages = images
                    self.petImageView.image = images.last
                    
                    // Reset the image
                    self.walkingImageView.image = nil
                    // Call the function to load a series of images
                    let walkingImages = self.loadWalkingImages()
                    self.walkingImageView.animationImages = walkingImages
                }
                // Set the duration and repeat count of the animation
                self.walkingImageView.animationDuration = 6.0
                self.walkingImageView.animationRepeatCount = 1
                self.walkingImageView.startAnimating()
                
                // Schedule timer to transition back to petImageView after feeding animation completes
                self.walkingTimer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { [weak self] _ in
                    guard let self = self else { return }
                    // Hide walkingImageView and show petImageView
                    self.walkingImageView.isHidden = true
                    if currentLevel == 0{
                        // The baby animation
                        let images = self.loadBabyPetImages()
                        self.petImageView.animationImages = images
                        // Set the last view to make the pet standing there is animation is not playing
                        self.petImageView.image = images.last
                    } else {
                        // The monster animation
                        let images = self.loadPetImages()
                        self.petImageView.animationImages = images
                        // Set the last view to make the pet standing there is animation is not playing
                        self.petImageView.image = images.last
                    }
                    // Make the pet view unhidden
                    self.petImageView.isHidden = false
                }
                
            case .failure(let error):
                print("Failed to fetch pet data: \(error.localizedDescription)")
            }
        }
    }
    
    // Function to handle user's tap on pet
    @objc private func handlePetTap() {
        // Change the booleean value
        isWalkingEnabled.toggle()
        // If yes, display the walking animation
        if isWalkingEnabled {
            loadWalkingAnimation()
        } else {
            // Make the pet view unhidden and turn the boolean for walking to true
            walkingImageView.isHidden = true
            petImageView.isHidden = false
        }
    }
    
    // Function to load a series of images for baby feeding animation
    private func loadBabyFeedingImages() -> [UIImage] {
        var images = [UIImage]()
        // loop through all images
        for index in 1...24 {
            if let image = UIImage(named: "BabyFeeding-\(index)") {
                images.append(image)
            }
        }
        return images
    }
    
    // Function to load a series of images for baby walking animation
    private func loadBabyWalkingImages() -> [UIImage] {
        var images = [UIImage]()
        // loop through all images
        for index in 1...29 {
            if let image = UIImage(named: "BabyWalking-\(index)") {
                images.append(image)
            }
        }
        return images
    }
    
    // Function to load a series of images for baby animation
    private func loadBabyPetImages() -> [UIImage] {
        var images = [UIImage]()
        // loop through all images
        for index in 1...21 {
            if let image = UIImage(named: "Baby-\(index)") {
                images.append(image)
            }
        }
        return images
    }
    
    // Function to load a series of images for monster feeding animation
    private func loadFeedingImages() -> [UIImage] {
        var images = [UIImage]()
        // loop through all images
        for index in 1...37 {                               //need to change a number
            if let image = UIImage(named: "Feeding-\(index)") {
                images.append(image)
            }
        }
        return images
    }
    
    // Function to load a series of images for monster walking animation
    private func loadWalkingImages() -> [UIImage] {
        var images = [UIImage]()
        // loop through all images
        for index in 1...42 {
            if let image = UIImage(named: "Walking-\(index)") {
                images.append(image)
            }
        }
        return images
    }
    
    // Function to load a series of images for monster animation
    private func loadPetImages() -> [UIImage] {
        var images = [UIImage]()
        // loop through all images
        for index in 1...31 {
            if let image = UIImage(named: "Monster-\(index)") {
                images.append(image)
            }
        }
        return images
    }
    
    // Handle if the page is closed
    // Close the timers
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        walkingTimer?.invalidate() // Invalidate the timer when the view disappears
        feedingTimer?.invalidate()
    }
    
    // Function to handle user's click on back button
    @objc private func backButtonTapped(_ sender:UIButton) {
        //go back to home page
        if let parentVC = parent as? homeViewController {
            parentVC.showCalendarView2()
        }
    }
    
    // Function to handle user's click on buy button
    @objc private func buyButtonTapped(_ sender: UIButton) {
        // Display a message to confirm if the user wants to buy
        let alertController = UIAlertController(title: "Confirmation", message: "Do you want to buy a bag of pet food?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Buy", style: .default, handler: { _ in
        
            // Handle the purchase logic here
            // Call the buyFood() function
            self.buyFood()
            
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    // Function handles the buying pet food logic
    private func buyFood() {
        // Get bages of pet food and point from point table in database
        guard let uid = UserManager.cuser?.uid else {
            print("User information is not available")
            return
        }
        DatabaseManager.shared.getPointData(uid: uid) { result in
            switch result {
            case .success(let pointData):
                guard let currentBags = pointData["bags"] as? Double,
                      let currentPoints = pointData["point"] as? Double else {
                    print("ERROR!")
                    return
                }
                // Update bags and points in database
                DatabaseManager.shared.buyPetFood(uid: uid, currentBags: currentBags, currentPoints: currentPoints) { result in
                    switch result {
                    case .success:
                        print("Purchase successfully!")
                        // Show message
                        self.displaySuccessAlert(message: "Pet food has been added to your backpack.")
                        // Update the experience bar or level label
                        self.updatePointsLabel()
                        
                    case .failure(let error):
                        print("Failed to buy pet food: \(error.localizedDescription)")
                        // Show message
                        self.displayFailureAlert(message: "Failed to buy pet food. Please try again.")
                    }
                }
                
            case .failure(let error):
                print("Failed to fetch point data for buying: \(error.localizedDescription)")
            }
        }
    
    }
    
    // Function to handle user's click on bag button
    @objc private func bagButtonTapped(_ sender: UIButton) {
        // Show how many bags of pet food the user has
        guard let uid = UserManager.cuser?.uid else {
            print("User information is not available")
            return
        }
        // Get the user's number of bags of pet food from point data in database
        DatabaseManager.shared.getPointData(uid: uid) { result in
            switch result {
            case .success(let pointData):
                guard let bags = pointData["bags"] as? Double else {
                    print("Failed to fetch bag count")
                    return
                }
                // Show an alert with bag count and options to feed or cancel
                let alertController = UIAlertController(title: "Pet Food Amount", message: "You have \(Int(bags)) bags of pet food.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Feed", style: .default, handler: { _ in
                    
                    // Call the function to show message and handle feeding logic
                    self.handlePetFoodClick()
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)

            case .failure(let error):
                print("Failed to fetch bag count: \(error.localizedDescription)")
            }
        }
    }
    
    // Function to show message and handle feeding logic
    private func handlePetFoodClick() {
        let alertController = UIAlertController(title: "Confirmation", message: "Do you want to feed the pet with a bag of pet food?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Feed", style: .default, handler: { _ in
            
            // Handle the feeding logic here
            self.feedPetWithBag()
            
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    // Function to handle feeding logic by updating data and labels
    private func feedPetWithBag() {
    
        guard let uid = UserManager.cuser?.uid else {
            print("User information is not available")
            return
        }
        // Get the user's number of bags of pet food from point data in database
        DatabaseManager.shared.getPointData(uid: uid) { result in
            switch result {
            case .success(let pointData):
                guard let currentBags = pointData["bags"] as? Double else {
                    print("ERROR!")
                    return
                }
                
                // Get the user's pet's experience and level data in database
                DatabaseManager.shared.getPetData(uid: uid) { result in
                    switch result {
                    case .success(let petData):
                        guard let currentExperience = petData["experience"] as? Double,
                              let currentLevel = petData["level"] as? Double else {
                            print("ERROR!")
                            return
                        }
                        // Update experience and level
                        DatabaseManager.shared.feedPet(uid: uid, currentBags: currentBags, currentExperience: currentExperience, currentLevel: currentLevel) { result in
                            switch result {
                            case .success:
                                print("Pet has been fed successfully!")
                                // Show message
                                self.displaySuccessAlert(message: "Pet has been fed successfully!")
                                // Update the experience bar or level label
                                self.updateExperienceBar()
                                self.updateLevelLabel()
                                
                                // Check if feeding animation is not already in progress
                                if !self.isFeedingInProgress {
                                    self.loadFeedingAnimation()
                                }
                                
                            case .failure(let error):
                                print("Failed to feed pet: \(error.localizedDescription)")
                                self.displayFailureAlert(message: "Failed to feed your pet. Please try again.")
                            }
                        }
                        
                    case .failure(let error):
                        print("Failed to fetch pet data: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                print("Failed to fetch point data for feeding: \(error.localizedDescription)")
            }
        }
        
    }
    
    // Function to update the experience bar
    private func updateExperienceBar() {
        // Assume max experience is 100
        // Get the user's pet's experience data in database
        DatabaseManager.shared.getPetData(uid: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let petData):
                guard let currentExperience = petData["experience"] as? Double else {
                    print("ERROR!")
                    return
                }
                print(currentExperience)
                let maxExperience: Double = 100.0
                let progress = Float(currentExperience / maxExperience)
                print(progress)
                self.experienceBar.setProgress(progress, animated: true)
            
            case .failure(let error):
                print("Failed to fetch pet data: \(error.localizedDescription)")
            }
        }
        
    }
    
    // Function to update the level label
    private func updateLevelLabel() {
        // Get the user's pet's level data in database
        DatabaseManager.shared.getPetData(uid: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let petData):
                guard let currentLevel = petData["level"] as? Double else {
                    print("ERROR!")
                    return
                }
                self.levelLabel.text = "Level: \(Int(currentLevel))"
                
            case .failure(let error):
                print("Failed to fetch pet data: \(error.localizedDescription)")
            }
        }
    }
    
    // Function to update the point level
    private func updatePointsLabel() {
        // Get the user's points from point data in database
        DatabaseManager.shared.getPointData(uid: UserManager.cuser!.uid) { result in
            switch result {
            case .success(let pointData):
                guard let currentPoints = pointData["point"] as? Double else {
                    print("ERROR!")
                    return
                }
                self.pointsLabel.text = "Points: \(currentPoints)"
           
            case .failure(let error):
                print("Failed to fetch point data for buying: \(error.localizedDescription)")
            }
        }
    }
    
    // Function to display message that show success
    private func displaySuccessAlert(message: String) {
        let alertController = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    // Function to display message that show failure
    private func displayFailureAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}

