//
//  AppThemeButton.swift
//  My Pharmacy
//
//  Created by Jat42 on 18/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

@IBDesignable
class AppThemeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
    }
    
    private func setUpButton() {
        self.setCornerRadius(radius: AppConfig.buttonCornerRadius, isMaskedToBound: true)
    }
    
}

@IBDesignable
class HalfCornerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
    }
    
    private func setUpButton() {
        self.setCornerRadius(radius: AppConfig.halfButtonCorderRadius, isMaskedBound: true, maskedBound: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
}

@IBDesignable
class BorderButton: UIButton {
    
    @IBInspectable var isRoundedCorners: Bool = true {
        didSet {
            setUpButton()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .appColor.appThemeColor {
        didSet {
            setUpButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
    }
    
    private func setUpButton() {
        self.setCornerRadius(
            radius: isRoundedCorners ? (self.frame.height / 2) : AppConfig.buttonCornerRadius,
            borderWidth: 1,
            borderColor: borderColor,
            isMaskedToBound: true
        )
    }
    
}


class CustomButton: UIButton {
    
    @IBInspectable lazy var isRoundRectButton : Bool = false
    
    @IBInspectable public var cornerRadius : CGFloat = 0.0 {
        didSet{
            setUpView()
        }
    }
    
    @IBInspectable public var borderColor : UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    //  MARK:   Awake From Nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    func setUpView() {
        if isRoundRectButton {
            self.layer.cornerRadius = self.bounds.height/2;
            self.clipsToBounds = true
        }
        else{
            self.layer.cornerRadius = self.cornerRadius;
            self.clipsToBounds = true
        }
    }
    
}
