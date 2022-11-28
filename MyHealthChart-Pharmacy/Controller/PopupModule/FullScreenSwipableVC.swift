//
//  FullScreenSwipableVC.swift
//  Pharma
//
//  Created by Jat42 on 28/10/21.
//  Copyright © 2021 TFB. All rights reserved.
//

import UIKit

extension FullScreenSwipableVC {
    
    static func instantiate() -> FullScreenSwipableVC {
        StoryBoardConstants.orderDetail.instantiateViewController(withIdentifier: String(describing: FullScreenSwipableVC.self)) as! FullScreenSwipableVC
    }
    
}

class FullScreenSwipableVC: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    
    @IBOutlet var uiViewTabContainer: UIView!
    
    var images: [UIImage] = []
    var imageUrl: [String] = []
    
    var titleText = ""
    
    private var viewConrollers: [DisplayFullScreenImageVC] = []
    
    fileprivate var tabViewController: SwipableTabViewController!
    
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        
        labelTitle.text = titleText
        
        for (index,url) in imageUrl.enumerated() {
            let vc = DisplayFullScreenImageVC.instantiate()
            vc.imageUrl = url
            vc.view.tag = index
            viewConrollers.append(vc)
        }
        
        labelCount.text = "\(selectedIndex + 1)/\(imageUrl.count)"
        
        setupTabbar()
        setupDelegates()
    }
    
    private func setupDelegates() {
        tabViewController.swipeDelegate = self
    }
    
    private func setupTabbar() {
        
        tabViewController = SwipableTabViewController()
        
        tabViewController.swipeControllers = viewConrollers
        
        addChild(tabViewController)
        
        // we need to re-size the page view controller's view to fit our container view
        tabViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // add the page VC's view to our container view
        uiViewTabContainer.addSubview(tabViewController.view)
        
        // constrain it to all 4 sides
        NSLayoutConstraint.activate([
            tabViewController.view.topAnchor.constraint(equalTo: uiViewTabContainer.topAnchor, constant: 0.0),
            tabViewController.view.bottomAnchor.constraint(equalTo: uiViewTabContainer.bottomAnchor, constant: 0.0),
            tabViewController.view.leadingAnchor.constraint(equalTo: uiViewTabContainer.leadingAnchor, constant: 0.0),
            tabViewController.view.trailingAnchor.constraint(equalTo: uiViewTabContainer.trailingAnchor, constant: 0.0),
        ])
        
        tabViewController.didMove(toParent: self)
        
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}

extension FullScreenSwipableVC: SwipableTabViewControllerDelegate {
    
    func controllerDidSwipe(to index: Int) {
        
        selectedIndex = index
        if images.isEmpty {
            labelCount.text = "\(selectedIndex + 1)/\(imageUrl.count)"
            
        } else {
            labelCount.text = "\(selectedIndex + 1)/\(images.count)"
            
        }
        
    }
}
