//
//  SwipableTabBarVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 04/10/21.
//

import UIKit

extension SwipableTabBarVC {
    static func instantiate() -> SwipableTabBarVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: SwipableTabBarVC.self)) as! SwipableTabBarVC
    }
}

class SwipableTabBarVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet var btnTabBar: [UIButton]!
    @IBOutlet var uiViewUnderLine: [UIView]!
    
    @IBOutlet weak var uiViewTabContainer: UIView!
    
    private var tabViewController: SwipableTabViewController!
    
    static var delegate: MyTeamDelegate?
    
    private var selectedTabIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        setupTabbar()
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Today Delivery"
        uiViewToolBar.btnClearAll.isHidden = true
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        tabViewController.swipeDelegate = self
    }
    
    private func setupTabbar() {
        
        tabViewController = SwipableTabViewController()
        
        let vc1 = TodayPendingVC.instantiate()
        
        vc1.view.tag = 0
        
        let vc2 = TodayCompleteVC.instantiate()
        
        vc2.view.tag = 1
        
        tabViewController.swipeControllers = [vc1,vc2]
        
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

extension SwipableTabBarVC: ToolBarDelegate, SwipableTabViewControllerDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchModePressed() {
        uiViewToolBar.setSearchMode(with: true)
    }
    
    func searchPressed() {
        SwipableTabBarVC.delegate?.searchList(searchText: uiViewToolBar.searchBar.text ?? "")
    }
    
    func controllerDidSwipe(to index: Int) {
        selectedTabIndex = index
        setButtons()
        Log.d("Page swipe to: \(index)")
    }
}
