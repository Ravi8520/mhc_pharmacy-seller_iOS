//
//  AlertHelper.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {
    
    static let shared = AlertHelper()
    
    enum ToastDuration: Int {
        // In milliseconds
        case short = 800
        case normal = 1000
        case long = 1500
    }
    
    func showToast(
        message: String,
        duration: ToastDuration = .normal,
        completion: (() -> ())? = nil
    ) {
        
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        
        AppConfig.sceneDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(duration.rawValue)){
            
            AppConfig.sceneDelegate?.window?.rootViewController?.dismiss(animated: true) {
                completion?()
            }
        }
    }
    
    func showAlert(
        title: String = Strings.alertTitle,
        message: String,
        okAction: ((UIAlertAction) -> Void)? = nil
    ) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: Strings.okConfirmation , style: .default, handler: okAction)
        
        alert.addAction(okAction)
        
        AppConfig.sceneDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmAlert(
        title:String = Strings.alertTitle,
        message: String,
        yesActionTitle: String = Strings.yesConfirmation,
        noActionTitle: String = Strings.noConfirmation,
        yesActionStyle: UIAlertAction.Style = .default,
        noActionStyle: UIAlertAction.Style = .destructive,
        YesAction: ((UIAlertAction) -> Void)? = nil,
        NoAction: ((UIAlertAction) -> Void)? = nil
    ) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: noActionTitle, style: noActionStyle, handler: NoAction))
        
        alert.addAction(UIAlertAction(title: yesActionTitle, style: yesActionStyle, handler: YesAction))
        
        AppConfig.sceneDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}
