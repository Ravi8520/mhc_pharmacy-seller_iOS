//
//  LoadingIndicatorHelper.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

class LoadingIndicator {
    
    private static let loadingText = LoadingLabel()
    
    class func showLoadingView(isUserInteractionAllow: Bool = false) {
        
        for view in AppConfig.sceneDelegate!.window!.subviews {
            if view.tag == 4444{
                return
            }
        }
        
        /// UIView Background View //
        
        let parentView = UIView()
        
        /// UIView Card View //
        
        let cardView = UIView(
            frame: CGRect.init(
                x: 0,
                y: 0,
                width: 110,
                height: 110
            )
        )
        
        /// cardView Formatting
        cardView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9803921569, blue: 0.9843137255, alpha: 1)
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardView.layer.shadowRadius = 1
        
        if isUserInteractionAllow {
            cardView.tag = 4444
            cardView.center = AppConfig.sceneDelegate!.window!.center
        } else {
            parentView.frame = AppConfig.sceneDelegate!.window!.bounds
            parentView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
            parentView.tag = 4444
            cardView.center = parentView.center
            parentView.addSubview(cardView)
        }
        
        let imageView = UIImageView()
        
        imageView.frame = CGRect(
            x: (cardView.frame.width/9),
            y: 0,
            width: 90,
            height: 90
        )
        
        imageView.image = UIImage.gifImageWithName("Capsule-Loading-without-bg", delayMicroSeconds: 130)
        
        cardView.addSubview(imageView)
        
        /// UILabel //
        loadingText.frame = CGRect.init(
            x: 10,
            y: (cardView.frame.height-20),
            width: cardView.frame.width,
            height: 15
        )
        
        loadingText.textAlignment = .left
        loadingText.text = Strings.pleaseWaitMesage
        loadingText.font = .appFont.regular(ofSize: 14)
        
        cardView.addSubview(loadingText)
        
        AppConfig.sceneDelegate!.window?.addSubview(isUserInteractionAllow ? cardView : parentView)
        loadingText.start()
    }
    
    class func hideLoadingView() {
        loadingText.stop(withText: "")
        for view in AppConfig.sceneDelegate!.window!.subviews {
            if view.tag == 4444{
                view.removeFromSuperview()
            }
        }
    }
    
}
