//
//  instructionViewController.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/13/24.
//

import Foundation
import UIKit
import SnapKit


class instructionViewController: UIViewController, UIScrollViewDelegate{

    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    
    // Declare a view for top background
    lazy var topBackgroundView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    // Declare a button for user to clink start and go to the home page of app
    lazy var startButton: UIButton = {
        let x = UIButton(type:.system)
        x.setTitle("Start", for: .normal)
        x.addTarget(self, action: #selector(startClick(_:)), for: .touchUpInside)
        x.backgroundColor = ui.mint
        x.layer.cornerRadius = 10
        x.setTitleColor(.black, for: .normal)
        x.setTitleColor(.gray, for: .highlighted)
        return x
    }()
    
    // Declare a view to show the image "let's get started"
    lazy var start_iamge: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Monster_Start")
        return imageview
    }()
    
    // Declare a view for displaying instruction pages
    lazy var Instruction_iamge_1: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Instruction_1")
        return imageview
    }()
    
    // main function in Swift
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let fullSize = UIScreen.main.bounds.size
        // Initialize a scoll view
        // Set the frame, content size, and other boolean values determining if it can be paging
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 20, width: fullSize.width, height: fullSize.height)
        scrollView.contentSize = CGSize(width: fullSize.width * 2, height: fullSize.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        // pageControl: showing which page is displaying now, it is a set of dots on the bottom
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.85, height: 50))
        pageControl.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.85)
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        
        // Set frame for the view for instruction images
        Instruction_iamge_1.frame = CGRect(x: 0, y: 0, width: 300, height: 600)
        Instruction_iamge_1.center = CGPoint(x: fullSize.width * (0.5), y: fullSize.height * 0.5)
        // Set start button size and position
        startButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        startButton.center = CGPoint(x: fullSize.width * (1.5), y: fullSize.height * 0.78)
        // Set frame for the view for the start image
        start_iamge.frame = CGRect(x: 0, y: 0, width: fullSize.width, height: 550)
        start_iamge.center = CGPoint(x: fullSize.width * (1.5), y: fullSize.height * 0.5)
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        scrollView.addSubview(Instruction_iamge_1)
        scrollView.addSubview(start_iamge)
        scrollView.addSubview(startButton)
        
    }
    
    //Function to split and make the scroll pages for instructions an images
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
    //Function to handle if the user scoll the page
    @objc private func pageChanged(_ sender: UIPageControl) {

        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated:true)
    }

    // Function to handle user click on the "start" button
    @objc private func startClick(_ sender: UIButton){
        DatabaseManager.shared.updateBool(uid: UserManager.cuser!.uid)
        let h = homeViewController()
        h.modalPresentationStyle = .overFullScreen
        self.present(h, animated: true, completion: nil)
    }
    
}

