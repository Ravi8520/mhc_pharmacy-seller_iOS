//
//  CroppingVC.swift
//  Pharma
//
//  Created by Jatan  on 17/06/21.
//  Copyright © 2021 TFB. All rights reserved.
//

import UIKit

let croppingStoryBoard = UIStoryboard.init(name: "Cropping", bundle: .main)

protocol MediaPickerDelegate {
    func mediaPicked(media: MediaData)
}

final class CropperViewController: UIViewController {
    
    //  MARK: - Properties -
    
    var image: UIImage!
    
    // MARK: - Connections:-
    
    // MARK: -- Outlets -
    
    private var cropView: AKImageCropperView {
        return cropViewStoryboard
    }
    
    @IBOutlet weak var cropViewStoryboard: AKImageCropperView!
    
    
    @IBOutlet weak var overlayActionView: UIView!
    
    @IBOutlet weak var navigationView: UIView!
    
    var delegate: MediaPickerDelegate?
    
    // MARK: -  Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        cropView.delegate = self
        cropView.image = image
        cropView.showOverlayView(animationDuration: 0.3)
    }
    
    // MARK: -- Actions -
    
    @IBAction func backAction(_ sender: AnyObject) {
        
        guard !cropView.isEdited else {

            let alertController = UIAlertController(title: "Warning!", message:
                                                        "All changes will be lost.", preferredStyle: UIAlertController.Style.alert)

            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel, handler: { _ in

                 self.dismiss(animated: true, completion: nil)
            }))

            alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))

            present(alertController, animated: true, completion: nil)
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cropRandomAction(_ sender: AnyObject) {
        
        //        cropView.setCropRectAnin(CGRect(x: 50, y: 200, width: 100, height: 100))
        
        
        /*
         let randomWidth = max(UInt32(cropView.configuration.cropRect.minimumSize.width), arc4random_uniform(UInt32(cropView.scrollView.frame.size.width)))
         let randomHeight = max(UInt32(cropView.configuration.cropRect.minimumSize.height), arc4random_uniform(UInt32(cropView.scrollView.frame.size.height)))
         let offsetX = CGFloat(arc4random_uniform(UInt32(cropView.scrollView.frame.size.width) - randomWidth))
         let offsetY = CGFloat(arc4random_uniform(UInt32(cropView.scrollView.frame.size.height) - randomHeight))
         
         cropView.cropRect(CGRectMake(offsetX, offsetY, CGFloat(randomWidth), CGFloat(randomHeight)))*/
    }
    
    @IBAction func randomImageAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func cropImageAction(_ sender: AnyObject) {
        
        guard let image = cropView.croppedImage else {
            return
        }
        
        self.dismiss(animated: true) { [self] in
            delegate?.mediaPicked(
                media: MediaData(
                    image: image,
                    imageData: nil,
                    pdfData: nil,
                    fileType: .jpeg
                )
            )
        }
        
    }
    
    @IBAction func showHideOverlayAction(_ sender: AnyObject) {
        
        if cropView.isOverlayViewActive {
            
            cropView.hideOverlayView(animationDuration: 0.3)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.overlayActionView.alpha = 0
                
            }, completion: nil)
            
        } else {
            
            cropView.showOverlayView(animationDuration: 0.3)
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveLinear, animations: {
                self.overlayActionView.alpha = 1
                
            }, completion: nil)
            
        }
    }
    
    var angle: Double = 0.0
    
    @IBAction func rotateAction(_ sender: AnyObject) {
        
        angle += .pi/2
        
        cropView.rotate(angle, withDuration: 0.3, completion: { _ in
            
            if self.angle == 2 * .pi {
                self.angle = 0.0
            }
        })
    }
    
    @IBAction func resetAction(_ sender: AnyObject) {
        
        cropView.reset(animationDuration: 0.3)
        angle = 0.0
    }
    
}

//  MARK: - AKImageCropperViewDelegate -

extension CropperViewController: AKImageCropperViewDelegate {
    
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
        //        print("New crop rectangle: \(rect)")
    }
    
    static func instantiate() -> CropperViewController {
        croppingStoryBoard.instantiateViewController(withIdentifier: String(describing: CropperViewController.self)) as! CropperViewController
    }
    
}

