//
//  Config.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

struct AppConfig {
    static let screenHight = UIScreen.main.bounds.height
    static let screenWidth = UIScreen.main.bounds.width
    
    //static let appMode: AppMode = .development
    static let appMode: AppMode = .production
    static var userType: UserType = .pharmacy
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private static let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    static var sceneDelegate: SceneDelegate? = windowScene?.delegate as? SceneDelegate
        
    static var rootVC = AppConfig.sceneDelegate?.window?.rootViewController
    static let window = AppConfig.sceneDelegate?.window
    
    static let buttonCornerRadius: CGFloat = 8
    static let halfViewCornerRadius: CGFloat = 24
    static let halfButtonCorderRadius: CGFloat = 14
    static let cardViewCornerRadius: CGFloat = 8
}


