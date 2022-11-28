//
//  HalfCornerButton.swift
//  My Pharmacy
//
//  Created by Jat42 on 18/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

@IBDesignable
class HalfCornerView: UIView {
    
    @IBInspectable var isTheamButton: Bool = false { didSet { setUpView() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    private func setUpView() {
        self.setCornerRadius(
            radius: isTheamButton ? AppConfig.halfButtonCorderRadius : AppConfig.halfViewCornerRadius,
            isMaskedBound: true,
            maskedBound: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        )
    }
    
}

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var gradientColorOne: UIColor = .clear {
        didSet {
            setGradientView()
        }
    }
    
    @IBInspectable var gradientColorTwo: UIColor = .clear {
        didSet {
            setGradientView()
        }
    }
    
    private func setGradientView() {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            gradientColorOne.cgColor,
            gradientColorTwo.cgColor
        ]
        gradient.locations = [0, 1]
        gradient.frame = bounds
        layer.addSublayer(gradient)
        clipsToBounds = true
        layer.cornerRadius = AppConfig.cardViewCornerRadius
    }
    
}

@IBDesignable
class BorderView: UIView {
    
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

@IBDesignable
class CircularProgressBar: UIView {
    @IBInspectable var color: UIColor? = .gray {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var ringWidth: CGFloat = 5
    
    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    private var progressLayer = CAShapeLayer()
    private var backgroundMask = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask
        
        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }
    
    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath
        
        progressLayer.path = circlePath.cgPath
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = color?.cgColor
    }
}

@IBDesignable
class RoundView: UIView {
    
    @IBInspectable var isRoundedCorners: Bool = true {
        didSet {
            setUpButton()
        }
    }
    
    @IBInspectable var radius: CGFloat = AppConfig.buttonCornerRadius {
        didSet {
            setUpButton()
        }
    }
    
    @IBInspectable var isMaskedBound: Bool = true {
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
            radius: isRoundedCorners ? self.frame.height / 2 : radius,
            isMaskedToBound: isMaskedBound
        )
    }
    
}

// Created by:- https://github.com/GetLinks/GLTimeline
// Modified by:- Jat42

class GLTimelineView : UIView {
    
    var xPoint = CGFloat()
    
    @IBInspectable var completeColor : UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    @IBInspectable var incompleteColor : UIColor = UIColor.gray { didSet { setNeedsDisplay() } }
    
    @IBInspectable var pointRadius : CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    @IBInspectable var lineWidth : CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable var lineStatus : Int {
        get { return self.lineType.rawValue }
        set (index) {
            self.lineType = LineType(rawValue: index) ?? .normal
            self.setNeedsDisplay()
        }
    }
    
    var lineType : LineType = .begin { didSet { setNeedsDisplay() } }
    
    @IBInspectable var isComplete: Bool = false { didSet { setNeedsDisplay() } }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        isComplete ? completeColor.set() : incompleteColor.set()
        
        xPoint = bounds.size.width / 2
        
        switch lineType {
            case .begin:
                pathForLine(.bottom).stroke()
                isComplete ? pathForPoint().fill() : pathForPoint().stroke()
                break
            case .end:
                pathForLine(.top).stroke()
                break
            case .normal:
                pathForLine(.top).stroke()
                pathForLine(.bottom).stroke()
                break
            case .onlyOne:
                isComplete ? pathForPoint().fill() : pathForPoint().stroke()
                break
        }
        isComplete ? pathForPoint().fill() : pathForPoint().stroke()
    }
    
    func pathForLine(_ line:Line) -> UIBezierPath {
        
        let bezirePath = UIBezierPath()
        
        bezirePath.lineWidth = lineWidth
        
        var yOriginPoint = CGFloat()
        
        var yLastPoint = CGFloat()
        
        switch line {
            case .top:
                yLastPoint = getCenterLine() - pointRadius
                break
            case .bottom:
                yOriginPoint = getCenterLine() + pointRadius
                yLastPoint = bounds.size.height
                break
        }
        
        bezirePath.move(to: CGPoint(x: xPoint , y: yOriginPoint))
        bezirePath.addLine(to: CGPoint(x: xPoint, y: yLastPoint))
        
        bezirePath.close()
        
        return bezirePath
    }
    
    static func getTimeLineType(_ position:Int, items:Int) -> LineType {
        if items == 1 {
            return .onlyOne
        }
        if position == 0 {
            return .begin
        }
        if position + 1 == items {
            return .end
        }
        return .normal
    }
    
    func getCenterLine () -> CGFloat {
        return (bounds.size.height / 2)
    }
    
    func pathForPoint() -> UIBezierPath {
        return pathForCircle(getCenterPoint(), radius: pointRadius)
    }
    
    func getCenterPoint() -> CGPoint {
        let x = bounds.size.width / 2
        let y = bounds.size.height / 2
        return CGPoint(x: x,y: y)
    }
    
    fileprivate func pathForCircle (_ midPoint: CGPoint,radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        return path
    }
}



enum Line {
    case top
    case bottom
}

enum Point {
    case first
    case other
}

public enum LineType : Int {
    case normal = 0
    case onlyOne = 1
    case end = 2
    case begin = 3
}

class CustomView: UIView {
    
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
            self.layer.cornerRadius = self.bounds.height/2
            self.clipsToBounds = true
        }
        else{
            self.layer.cornerRadius = self.cornerRadius
            self.clipsToBounds = true
        }
    }
    
}
