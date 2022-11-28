//
//  FullScreenVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 29/09/21.
//

import UIKit

extension FullScreenVC {
    static func instantiate() -> FullScreenVC {
        StoryBoardConstants.popup.instantiateViewController(withIdentifier: String(describing: FullScreenVC.self)) as! FullScreenVC
    }
}

class FullScreenVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var uiViewBackBtnBG: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var uiViewContainer: UIView!
    
    var scrollImg: UIScrollView = UIScrollView()
    var imageView = UIImageView()
    var uiViewBtn = UIView()
    var imageBackBtn = UIImageView()
    var image = UIImage()
    var remoteUrl = ""
    var count = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageViewBackArrow.image = #imageLiteral(resourceName: "Symbol 5 – 50").withTintColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        //labelCount.text = count
        
        
        let vWidth = uiViewContainer.frame.width
        let vHeight = uiViewContainer.frame.height
        uiViewContainer.backgroundColor = .black
        
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x: 0,
                                 y: 0,
                                 width: vWidth,
                                 height: vHeight)
        
        scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        scrollImg.backgroundColor = .black
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 6.0
        
        uiViewContainer.addSubview(scrollImg)
        imageView.frame = CGRect(x: 0,
                                 y: -90,
                                 width: scrollImg.frame.width,
                                 height: scrollImg.frame.height)
        
        imageView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFit
        if remoteUrl.isEmpty {
            imageView.image = image
        } else {
            imageView.loadImageFromUrl(urlString: remoteUrl)
        }
        scrollImg.addSubview(imageView)
        
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //
    //        if #available(iOS 13.0, *) {
    //            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
    //            statusBar.backgroundColor = .white
    //            UIApplication.shared.keyWindow?.addSubview(statusBar)
    //        } else {
    //            UIApplication.shared.statusBarStyle = .lightContent
    //        }
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        if #available(iOS 13.0, *) {
    //            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
    //            statusBar.backgroundColor = .white
    //            UIApplication.shared.keyWindow?.addSubview(statusBar)
    //        } else {
    //            UIApplication.shared.statusBarStyle = .default
    //        }
    //    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
