//
//  ReferralUserTblCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

class ReferralUserTblCell: UITableViewCell {

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var uiViewCard: UIView!
    
    var data: ReferralUsersContentApiResponse? {
        didSet {
            imageViewProfile.loadImageFromUrl(
                urlString: data?.profile ?? "", placeHolder: UIImage(named: "ic_profile_placeholder"))
            labelUserName.text = data?.userName
            labelDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data?.date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        uiViewCard.setCardView()
        imageViewProfile.setCardView()
    }

    
}

extension ReferralUserTblCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: ReferralUserTblCell.self
            ),bundle: nil
        )
        
    }
    
    static func idetifire() -> String {
        String(describing: ReferralUserTblCell.self)
    }
    
}
