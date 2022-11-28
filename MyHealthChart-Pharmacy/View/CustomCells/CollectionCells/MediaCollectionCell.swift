//
//  MediaCollectionCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 29/09/21.
//

import UIKit

class MediaCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageViewMedia: UIImageView!
    @IBOutlet weak var btnMediaCancel: UIButton!
    
    var mediaCancelHandler: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewMedia.setCornerRadius(
            radius: 4,
            isMaskedToBound: true
        )
    }
    
    var mediaData: MultiImageApiResponse? {
        didSet {
            Networking.remoteResource(
                at: mediaData?.image ?? "",
                isOneOf: [.pdf]) { isPdf in
                    
                    if isPdf {
                        self.imageViewMedia.image = #imageLiteral(resourceName: "ic_pdf")
                        self.imageViewMedia.contentMode = .scaleAspectFit
                    } else {
                        self.imageViewMedia.loadImageFromUrl(
                            urlString: self.mediaData?.image ?? "",
                            placeHolder: nil
                        )
                        self.imageViewMedia.contentMode = .scaleAspectFill
                    }
                    
                }
        }
    }
    
    var data: MediaData? {
        didSet {
            if data?.fileType == .pdf {
                imageViewMedia.image = #imageLiteral(resourceName: "ic_pdf")
            } else {
                imageViewMedia.image = data?.image
            }
        }
    }
    
    @IBAction func btnMedialCancelPressed(_ sender: UIButton) {
        mediaCancelHandler?()
    }
    
}

extension MediaCollectionCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: MediaCollectionCell.self
            ),bundle: nil)
        
    }
    
    static func idetifire() -> String {
        String(describing: MediaCollectionCell.self)
    }
    
}
