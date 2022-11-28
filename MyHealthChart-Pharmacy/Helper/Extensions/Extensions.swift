//
//  Extensions.swift
//  My Pharmacy
//
//  Created by iOS Dev on 31/12/20.
//  Copyright © 2020 iOS Dev. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct appColor {
        
        static var appThemeColor: UIColor {
            UIColor.init(named: "AppThemeColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var appThemeOpacColor: UIColor {
            UIColor.init(named: "AppThemeOpacColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var appBgColor: UIColor {
            UIColor.init(named: "AppGrayBgColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var shadowColor: UIColor {
            UIColor.init(named: "AppShadowColor") ?? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        static var fontColor: UIColor {
            UIColor.init(named: "AppFontColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var placeHolderColor: UIColor {
            UIColor.init(named: "AppPlaceHolderColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var assignColor: UIColor {
            UIColor.init(named: "AppAssignColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var assignOpacColor: UIColor {
            UIColor.init(named: "AppAssignOpacColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var standardColor: UIColor {
            UIColor.init(named: "AppStandardColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var standardOpacColor: UIColor {
            UIColor.init(named: "AppStandardOpacColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var expressColor: UIColor {
            UIColor.init(named: "AppExpressColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var expressOpacColor: UIColor {
            UIColor.init(named: "AppExpressOpacColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var focusedTextFieldColor: UIColor {
            UIColor.init(named: "AppFocusedTextFieldColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var unFocusedTextFieldColor: UIColor {
            UIColor.init(named: "AppUnFocusedTextFieldColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var ratingFilledColor: UIColor {
            UIColor.init(named: "RatingFilledColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var ratingOpacColor: UIColor {
            UIColor.init(named: "RatingOpacColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var gradientColorOne: UIColor {
            UIColor.init(named: "AppGradientOneColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var gradientColorTwo: UIColor {
            UIColor.init(named: "AppGradientTwoColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var gradientColorThree: UIColor {
            UIColor.init(named: "AppGradientThreeColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static var gradientColorFour: UIColor {
            UIColor.init(named: "AppGradientFourColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
}

extension UIFont {
    
    struct appFont {
        
        static func regular(ofSize size: CGFloat) -> UIFont {
            UIFont.init(name: "Metropolis-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static func medium(ofSize size: CGFloat) -> UIFont {
            UIFont.init(name: "Metropolis-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static func semiBold(ofSize size: CGFloat) -> UIFont {
            UIFont.init(name: "Metropolis-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static func bold(ofSize size: CGFloat) -> UIFont {
            UIFont.init(name: "Metropolis-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
    }
    
}



extension UIView {
    
    enum GradientDirection {
        case crossTopLeftToBottomRight
        case crossBottomRightToTopLeft
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    
    func setGradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
        
        //        let gradientMaskLayer = CAGradientLayer()
        //        gradientMaskLayer.frame = backgroundMaskedView.bounds
        //        gradientMaskLayer.colors = [UIColor.systemPurple.cgColor, UIColor.clear.cgColor]
        //        gradientMaskLayer.locations = [0, 0.4]
        //
        //        backgroundMaskedView.layer.mask = gradientMaskLayer
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        
        switch direction {
            case .crossTopLeftToBottomRight:
                gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            case .crossBottomRightToTopLeft:
                gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
            case .bottomToTop:
                gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
            case .topToBottom:
//                gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
//                gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
                gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
            case .leftToRight:
                gradient.locations = [0, 0.4]
                gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            case .rightToLeft:
                gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func setShadow(
        shadowRadius: CGFloat = 2.0,
        shadowColor: CGColor = UIColor.appColor.shadowColor.cgColor,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 0,
        isMaskedToBound: Bool = false
    ) {
        self.layer.cornerRadius = radius
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = shadowColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
        self.layer.masksToBounds = isMaskedToBound
    }
    
    func setShadow1(
        shadowRadius: CGFloat = 2.0,
        shadowColor: CGColor = UIColor.appColor.shadowColor.cgColor,
        shadowOffset: CGSize = CGSize(width: 0, height: 3)
    ) {
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = shadowColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
    
    func setCornerRadius(
        radius: CGFloat = 8,
        isMaskedToBound: Bool = false
    ) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = isMaskedToBound
    }
    
    func setCornerRadius(
        radius: CGFloat = 8,
        isMaskedBound:Bool = false,
        maskedBound: CACornerMask
    ) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = isMaskedBound
        self.layer.maskedCorners = maskedBound
    }
    
    func setCornerRadius(
        radius: CGFloat = 8,
        borderWidth: CGFloat = 1,
        borderColor: UIColor,
        isMaskedToBound: Bool = false
    ) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = isMaskedToBound
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func setCardView() {
        self.setShadow(shadowRadius: 3,
                       shadowColor: UIColor.appColor.shadowColor.cgColor, // 41464D // 20% opt
                       shadowOffset: CGSize(width: 0, height: 2),
                       radius: 8,
                       isMaskedToBound: false)
    }
    
    //https://stackoverflow.com/questions/62434770/how-add-corner-radius-to-dashed-border-around-an-uiview
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: UIColor) -> CALayer {
        let borderLayer = CAShapeLayer()
        
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: radius, height: radius)
        ).cgPath
        
        layer.addSublayer(borderLayer)
        return borderLayer
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
}
