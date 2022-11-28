//
//  ReportTabbarVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

extension ReportTabbarVC {
    static func instantiate() -> ReportTabbarVC {
        StoryBoardConstants.report.instantiateViewController(withIdentifier: String(describing: ReportTabbarVC.self)) as! ReportTabbarVC
    }
}

class ReportTabbarVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet var btnTabBar: [UIButton]!
    @IBOutlet var uiViewUnderLine: [UIView]!
    
    @IBOutlet weak var uiViewTabContainer: UIView!
    
    fileprivate var tabViewController: SwipableTabViewController!
    
    var selectedTabIndex = 0
    
    static var delegate: MyTeamDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupTabbar()
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Reports"
        uiViewToolBar.btnSetting.isHidden = false
        uiViewToolBar.btnClearAll.isHidden = true
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        tabViewController.swipeDelegate = self
    }
    
    private func setupTabbar() {
        
        tabViewController = SwipableTabViewController()
        
        let vc1 = OrderReportVC.instantiate()
        
        vc1.view.tag = 0
        
        let vc2 = IncomeReportVC.instantiate()
        
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
        if selectedTabIndex == 0 {
            uiViewToolBar.btnSetting.isHidden = false
            uiViewToolBar.btnSearch.isHidden = false
        } else {
            uiViewToolBar.btnSetting.isHidden = true
            uiViewToolBar.btnSearch.isHidden = true
        }
    }
    
    
}

extension ReportTabbarVC: ToolBarDelegate, SwipableTabViewControllerDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    func settingsPressed() {
        ReportTabbarVC.delegate?.settingsPressed?()
    }
    
    func searchModePressed() {
        uiViewToolBar.setSearchMode(with: true)
        uiViewToolBar.btnSetting.isHidden = true
    }
    
    func searchPressed() {
        if uiViewToolBar.searchBar.isHidden {
            uiViewToolBar.btnSetting.isHidden = false
        }
        ReportTabbarVC.delegate?.searchList(searchText: uiViewToolBar.searchBar.text ?? "")
    }
    
    func controllerDidSwipe(to index: Int) {
        selectedTabIndex = index
        setButtons()
        Log.d("Page swipe to: \(index)")
    }
}
