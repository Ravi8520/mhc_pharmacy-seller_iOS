//
//  SellerNameCollCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

class SellerNameCollCell: UICollectionViewCell {

    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var uiViewCard: UIView!
    
    var data: FilterUserModel? {
        didSet {
            labelName.text = data?.name
            labelName.backgroundColor = data!.isSelected ? .appColor.appThemeColor : .white
            labelName.textColor = data!.isSelected ? .white : .appColor.fontColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelName.setCornerRadius(isMaskedToBound: true)
        uiViewCard.setCardView()
    }

}

extension SellerNameCollCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: SellerNameCollCell.self
            ),
            bundle: nil
        )
        
    }
    
    static func idetifire() -> String {
        String(
            describing: SellerNameCollCell.self
        )
    }
    
}
