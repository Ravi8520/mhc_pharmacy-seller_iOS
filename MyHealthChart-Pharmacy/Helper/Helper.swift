//
//  Helper.swift
//  My Pharmacy
//
//  Created by iOS Dev on 31/12/20.
//  Copyright © 2020 iOS Dev. All rights reserved.
//

import UIKit

// MARK:- StoryBoards -

class Helper: NSObject {
    
    static let shared = Helper()
    
    func setLogout() {
        
        clearUserData()
        
        let rootViewController = UINavigationController(
            rootViewController: LoginVC.instantiate()
        )
        
        rootViewController.navigationBar.isHidden = true

        AppConfig.sceneDelegate?.window?.rootViewController = rootViewController
        AppConfig.sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    private func clearUserData() {
        UserDefaultHelper.shared.removeAllUserData()
    }
    
    func setTableViewEmpatyPlaceHolder(
        count: Int,
        message: String,
        anchorView: UITableView,
        textAlignMent: NSTextAlignment = .center,
        textColor: UIColor = .appColor.fontColor
    ) {
        
        if count == 0 {
            
            for view in anchorView.subviews {
                if view.tag == 5400 {
                    return
                }
            }
            
            anchorView.tableFooterView = UIView(frame: CGRect.zero)
            anchorView.backgroundColor = UIColor.clear
            
            let label = UILabel()
            
            label.frame.size.height = 42
            label.frame.size.width = anchorView.frame.size.width - 16
            label.center = anchorView.center
            label.center.y = anchorView.frame.size.height/2
            label.numberOfLines = 0
            label.textColor = textColor
            label.text = message
            label.textAlignment = .center
            label.tag = 5400
            label.backgroundColor = .clear
            label.textAlignment = textAlignMent
            
            anchorView.addSubview(label)
            
        }else{
            for view in anchorView.subviews {
                if view.tag == 5400 {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    func createSpinnerFooterView(view: UIView) -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        
        let spinnerView = UIActivityIndicatorView()
        spinnerView.center = footerView.center
        spinnerView.color = .appColor.appThemeColor
        footerView.addSubview(spinnerView)
        spinnerView.startAnimating()
        return footerView
    }
    
    func sendNumberForCall(num: String) {
        if num != "" {
            let phoneNumber = URL.init(string: "telprompt://\(num)")
            if let phoneNumber = phoneNumber {
                if UIApplication.shared.canOpenURL(phoneNumber) {
                    UIApplication.shared.open(phoneNumber, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func getPercentage<T: BinaryInteger>(value1: T, value2: T) -> T {
        
        guard !(value1 == 0 || value2 == 0) else { return 0 as! T }

        return  value1 / value2
    }
    
    func shareApp(msg: String?) {
        
        var objectsToShare: [Any] = []
        
        guard let m = msg else { return }
        
        //        if let m = msg, !m.isEmpty {
        
        objectsToShare = [m]
        
        //        } else {
        //
        //            objectsToShare = [
        //                Helper.downloadText,
        //                Helper.appStoreLinkShare,
        //                Helper.playStoreLink,
        //                Helper.userCode,
        //                Helper.footerText
        //            ]
        //
        //        }
        
        let activityVC = UIActivityViewController(
            activityItems: objectsToShare,
            applicationActivities: nil
        )
        
        let controller = AppConfig.sceneDelegate?.window?.rootViewController
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popup = activityVC.popoverPresentationController {
                popup.sourceView = controller?.view
                popup.sourceRect = CGRect(
                    x: controller!.view!.frame.size.width / 2,
                    y: controller!.view!.frame.size.height / 4,
                    width: 0, height: 0
                )
            }
        }
        
        controller?.present(activityVC, animated: true, completion: nil)
    }
    
}
