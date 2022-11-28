//
//  PrescriptionGridCell.swift
//  Pharma
//
//  Created by Jatan  on 19/05/21.
//  Copyright © 2021 TFB. All rights reserved.
//

import UIKit

class PrescriptionGridCell: UICollectionViewCell {

    @IBOutlet weak var imageViewPrescription: UIImageView!
    @IBOutlet weak var uiViewCard: UIView!
    
    @IBOutlet weak var imageViewType: UIImageView!
    
    @IBOutlet weak var labelCount: AppTagLabel!
    
    var currentIndex: Int? {
        didSet {
            labelCount.text = "\(currentIndex! + 1)"
        }
    }
    
//    var imageData: UpcomingOrderResponsePrescriptionImage? {
//        didSet {
//            setUpViews()
//        }
//    }
    
    var mediaData: MediaData? {
        didSet {
            if mediaData?.fileType == .pdf {
                imageViewPrescription.image = #imageLiteral(resourceName: "ic_pdf")
                imageViewType.image = #imageLiteral(resourceName: "ic_pdfTag")
            } else {
                imageViewPrescription.image = mediaData?.image
                imageViewType.image = #imageLiteral(resourceName: "ic_imageTag")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uiViewCard.setCornerRadius(isMaskedToBound: true)
        
    }
    
//    func setUpViews() {
//        
//        switch imageData!.mimetype {
//            case MimeTypes.jpeg.rawValue,
//                 MimeTypes.jpg.rawValue,
//                 MimeTypes.png.rawValue:
//                
//                imageViewPrescription.sd_setImage(
//                    with: URL.init(string: imageData!.image ?? ""),
//                    completed: nil
//                )
//                imageViewType.image = #imageLiteral(resourceName: "ic_imageTag")
//                
//            case MimeTypes.pdf.rawValue:
//                
//                imageViewPrescription.image = #imageLiteral(resourceName: "ic_pdf")
//                imageViewType.image = #imageLiteral(resourceName: "ic_pdfTag")
//            default:
//                break
//            
//        }
//        
//    }
    
}
