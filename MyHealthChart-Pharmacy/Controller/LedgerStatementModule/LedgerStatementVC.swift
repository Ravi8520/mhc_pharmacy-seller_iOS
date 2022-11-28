//
//  LedgerStatementVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Miral vadher on 17/05/22.
//

import UIKit

extension LedgerStatementVC {
    static func instantiate() -> LedgerStatementVC {
        StoryBoardConstants.ledgerstatement.instantiateViewController(withIdentifier: String(describing: LedgerStatementVC.self)) as! LedgerStatementVC
    }
}



class LedgerStatementVC: UIViewController {

    @IBOutlet weak var uiViewToolbar: ToolBar!
    
    @IBOutlet var btnTabBar: [UIButton]!
    
    @IBOutlet var uiViewUnderLine: [UIView]!
    @IBOutlet weak var uiViewTabContainer: UIView!
    
    fileprivate var tabViewController: SwipableTabViewController!
    
    var selectedTabIndex = 0
    
    static var delegate: MyTeamDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        setupTabbar()
        setupDelegates()
        uiViewToolbar.labelTitle.text = "Ledger Statement"
        uiViewToolbar.btnSetting.isHidden = true
        uiViewToolbar.btnClearAll.isHidden = true
    }
    private func setupDelegates() {
        uiViewToolbar.delegate = self
       tabViewController.swipeDelegate = self
    }
    
    private func setupTabbar() {
        
        tabViewController = SwipableTabViewController()
        
        let vc1 = UnpaidVC.instantiate()
        
        vc1.view.tag = 0
        
        let vc2 = PaidVC.instantiate()
        
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
            uiViewToolbar.btnSetting.isHidden = true
            uiViewToolbar.btnSearch.isHidden = false
        } else {
            uiViewToolbar.btnSetting.isHidden = true
            uiViewToolbar.btnSearch.isHidden = false
        }
    }

}
extension LedgerStatementVC: ToolBarDelegate, SwipableTabViewControllerDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func searchModePressed() {
        uiViewToolbar.setSearchMode(with: true)
        uiViewToolbar.btnSetting.isHidden = true
    }
    
//    func searchPressed() {
//        if uiViewToolbar.searchBar.isHidden {
//            uiViewToolbar.btnSetting.isHidden = false
//        }
//        LedgerStatementVC.delegate?.searchList(searchText: uiViewToolbar.searchBar.text ?? "")
//    }
    
    func controllerDidSwipe(to index: Int) {
        selectedTabIndex = index
        setButtons()
        Log.d("Page swipe to: \(index)")
    }
}
