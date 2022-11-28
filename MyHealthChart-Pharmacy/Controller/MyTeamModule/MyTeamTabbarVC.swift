//
//  MyTeamTabbarVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jatan Ambasana on 06/10/21.
//

import UIKit

extension MyTeamTabbarVC {
    static func instantiate() -> MyTeamTabbarVC {
        StoryBoardConstants.myTeam.instantiateViewController(withIdentifier: String(describing: MyTeamTabbarVC.self)) as! MyTeamTabbarVC
    }
}

@objc protocol MyTeamDelegate {
    func searchList(searchText: String)
    @objc optional func settingsPressed()
}

class MyTeamTabbarVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet var btnTabBar: [UIButton]!
    @IBOutlet var uiViewUnderLine: [UIView]!
    
    @IBOutlet weak var uiViewTabContainer: UIView!
    
    fileprivate var tabViewController: SwipableTabViewController!
    
    static var delegate: MyTeamDelegate?
    
    var selectedTabIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupTabbar()
        setupDelegates()
        uiViewToolBar.labelTitle.text = "My Team"
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        tabViewController.swipeDelegate = self
    }
    
    private func setupTabbar() {
        
        tabViewController = SwipableTabViewController()
        
        let vc1 = AllTeamVC.instantiate()
        
        vc1.view.tag = 0
        
        let vc2 = SellerListVC.instantiate()
        
        vc2.view.tag = 1
        
        let vc3 = DeliveryBoyListVC.instantiate()
        
        vc3.view.tag = 2
        
        tabViewController.swipeControllers = [vc1,vc2,vc3]
        
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
    
    @IBAction func btnTabBarPressed(_ sender: UIButton) {
        tabViewController.navigateTo(index: sender.tag)
    }
    
    
    private func setButtons() {
        for (index,btn) in btnTabBar.enumerated() {
            if index == selectedTabIndex {
                btn.titleLabel?.font = .appFont.semiBold(ofSize: 14)
                btn.setTitleColor(.appColor.appThemeColor, for: .normal)
                uiViewUnderLine[index].isHidden = false
            } else {
                btn.titleLabel?.font = .appFont.regular(ofSize: 14)
                btn.setTitleColor(.appColor.placeHolderColor, for: .normal)
                uiViewUnderLine[index].isHidden = true
            }
        }
    }
    
    
}

extension MyTeamTabbarVC: ToolBarDelegate, SwipableTabViewControllerDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchModePressed() {
        uiViewToolBar.setSearchMode(with: true)
    }
    
    func searchPressed() {
        MyTeamTabbarVC.delegate?.searchList(searchText: uiViewToolBar.searchBar.text ?? "")
    }
    
    func settingsPressed() {
        self.navigationController?.pushViewController(FilterVC.instantiate(), animated: true)
    }
    
    func controllerDidSwipe(to index: Int) {
        selectedTabIndex = index
        setButtons()
        Log.d("Page swipe to: \(index)")
    }
}
