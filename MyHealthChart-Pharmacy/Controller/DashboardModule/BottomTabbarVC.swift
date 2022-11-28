//
//  BottomTabbarVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 30/09/21.
//

import UIKit

extension BottomTabbarVC {
    static func instantiate() -> BottomTabbarVC {
        StoryBoardConstants.dashboard.instantiateViewController(withIdentifier: String(describing: BottomTabbarVC.self)) as! BottomTabbarVC
    }
}

class BottomTabbarVC: UIViewController {
    
    @IBOutlet var tabImages: [UIImageView]!
    @IBOutlet var tabLabels: [UILabel]!
    @IBOutlet var tabButtons: [UIButton]!
    
    @IBOutlet var centerConstraint: [NSLayoutConstraint]!
    
    @IBOutlet weak var uiViewTabbar: HalfCornerView!
    @IBOutlet weak var uiViewShadowView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    private var selectedIcons: [UIImage] = [#imageLiteral(resourceName: "ic_home_blue"), #imageLiteral(resourceName: "ic_rejected_blue"), #imageLiteral(resourceName: "ic_cancel_blue"), #imageLiteral(resourceName: "ic_return_blue"), #imageLiteral(resourceName: "ic_more_blue")]
    private var nonSelectedIcons: [UIImage] = [#imageLiteral(resourceName: "ic_home_grey"), #imageLiteral(resourceName: "ic_rejected_grey"), #imageLiteral(resourceName: "ic_cancel_grey"), #imageLiteral(resourceName: "ic_return_grey"), #imageLiteral(resourceName: "ic_more_greay")]
    
    private var selectedTabIndex = 0
    private var previousTabIndex = 0
    
    private var viewControllers: [UIViewController]!
    
    private var dashboardVC: UIViewController!
    private var rejectedOrderVC: UIViewController!
    private var cancelledOrderVC: UIViewController!
    private var returnOrderVC: UIViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
//        checkForUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setupView() {
//        uiViewShadowView.setShadow(shadowRadius: 5,shadowOffset: CGSize(width: -3, height: 3))
        
        dashboardVC = DashboardVC.instantiate()
        rejectedOrderVC = RejectedOrderVC.instantiate()
        cancelledOrderVC = CancelledOrderVC.instantiate()
        returnOrderVC = ReturnOrderVC.instantiate()
        
        viewControllers = [
            dashboardVC,
            rejectedOrderVC,
            cancelledOrderVC,
            returnOrderVC
        ]
        
        btnTabbarPressed(tabButtons[selectedTabIndex])
        
    }
    
    @IBAction func btnCreateOrder(_ sender: Any) {
        
        if Parameter.is_pharmacy_manual_order_allow {
            let vc = CreateOrderVC.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let popUp = ComingSoonVC.instanciate()
            present(popUp, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnTabbarPressed(_ sender: UIButton) {
        
        previousTabIndex = selectedTabIndex
        
        selectedTabIndex = sender.tag
        
        Log.d("Selected tab index:- \(selectedTabIndex)")
        
        setIcons()
        setLabels()
        setConstraints()
        setVC()
        
        selectedTabIndex == 4 ? (view.backgroundColor = .white) : (view.backgroundColor = .appColor.appBgColor)
    }
    
    private func setIcons() {
        for (index,_) in tabImages.enumerated() {
            if index == selectedTabIndex {
                tabImages[index].image = selectedIcons[index]
            } else {
                tabImages[index].image = nonSelectedIcons[index]
            }
        }
    }
    
    private func setLabels() {
        for (index,_) in tabLabels.enumerated() {
            if index == selectedTabIndex {
                tabLabels[index].isHidden = false
            } else {
                tabLabels[index].isHidden = true
            }
        }
    }
    
    private func setConstraints() {
        
//        for (index,_) in centerConstraint.enumerated() {
//            if index == selectedTabIndex {
//               // centerConstraint[index].constant = -22
//            } else {
//              //  centerConstraint[index].constant = 10
//            }
//        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setVC() {
        
        let previousVC = viewControllers![previousTabIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        let vc = viewControllers[selectedTabIndex]
        addChild(vc)
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
}

extension BottomTabbarVC {
    
    private func checkForUpdate() {
        
        let param = [
            Parameter.version: Bundle.main.releaseVersionNumber ?? "1.0",
            Parameter.appType: "2",
            Parameter.device_type: 1
        ] as [String : Any]
        
        Networking.request(
            url: Urls.checkVersion,
            method: .post,
            headers: nil,
            defaultHeader: false,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let resetResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let rsResponse = resetResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    if rsResponse.status == StatusCode.success.rawValue {
                        
                        //present(UpdatePopup.instantiate(), animated: true, completion: nil)
                        
                        
                    } else if rsResponse.status == StatusCode.notFound.rawValue {
                        present(UpdatePopup.instantiate(), animated: true, completion: nil)
                        
                    } else {
                        present(UpdatePopup.instantiate(), animated: true, completion: nil)
                        //                        AlertHelper.shared.showAlert(message: rsResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
                    Helper.shared.setLogout()
                    
            }
            
        }
    }
    
}

