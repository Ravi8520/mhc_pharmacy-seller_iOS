//
//  DisplayFullScreenImageVC.swift
//  Pharma
//
//  Created by Unity 3D Game Dev on 12/09/20.
//  Copyright © 2020 TFB. All rights reserved.
//

import UIKit

extension DisplayFullScreenImageVC {
    
    static func instantiate() -> DisplayFullScreenImageVC {
        StoryBoardConstants.orderDetail.instantiateViewController(withIdentifier: String(describing: DisplayFullScreenImageVC.self)) as! DisplayFullScreenImageVC
    }
    
}

class DisplayFullScreenImageVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollImg: UIScrollView!
    var imageView = UIImageView()
    var uiViewBtn = UIView()
    var imageBackBtn = UIImageView()
    var image = UIImage()
    var imageUrl = ""
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let vWidth = self.view.frame.width
//        let vHeight = self.view.frame.height
        //self.view.backgroundColor = .black

        scrollImg.delegate = self
        //scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        //scrollImg.backgroundColor = .black
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 4.0

        self.view.addSubview(scrollImg)
        
        imageView.frame = CGRect(x: 0,
                                 y: -90, //-90
                                 width: scrollImg.frame.width,
                                 height: scrollImg.frame.height)
        
        //imageView.center = scrollImg.center
    
        imageView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFit
        
        if imageUrl.isEmpty {
            imageView.image = image
        } else {
            imageView.loadImageFromUrl(
                urlString: imageUrl, placeHolder: UIImage(named: "ic_prescription_placeHolder"))
        }
        
        scrollImg.addSubview(imageView)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = .white
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = .white
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
