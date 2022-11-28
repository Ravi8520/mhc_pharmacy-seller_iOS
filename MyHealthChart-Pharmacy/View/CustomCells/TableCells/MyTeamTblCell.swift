//
//  MyTeamTblCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Jatan Ambasana on 06/10/21.
//

import UIKit

class MyTeamTblCell: UITableViewCell {

    @IBOutlet weak var uiViewCard: UIView!
    @IBOutlet weak var uiViewUserStatus: RoundView!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelOrderCount: UILabel!
    @IBOutlet weak var switchUserAvailibility: UISwitch!
    @IBOutlet weak var btnCall: UIButton!
    
    var callHandler: (()->Void)?
    var switchHandler: ((Bool)->Void)?
    
    var data: MyTeamListDataApiResponse? {
        didSet {
            imageViewProfile.setCornerRadius(
                radius: 4,
                isMaskedToBound: true
            )
            imageViewProfile.loadImageFromUrl(
                urlString: data?.profile ?? "",
                placeHolder: UIImage(named: "ic_profile_placeholder")
            )
            labelName.text = data?.name?.capitalized
            labelOrderCount.text = data?.orderCount
            switchUserAvailibility.isOn = data?.isActive == "true" ? true : false
            uiViewCard.alpha = data?.isActive == "true" ? 1.0 : 0.5
            uiViewUserStatus.backgroundColor = data?.userStatus == "true" ?
                .appColor.standardColor :
                .appColor.expressColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uiViewCard.setCardView()
        selectionStyle = .none
    }

    @IBAction func btnCallPressed(_ sender: UIButton) {
        callHandler?()
    }
    
    @IBAction func switchStateChange(_ sender: UISwitch) {
        switchHandler?(sender.isOn)
    }
    
}

extension MyTeamTblCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: MyTeamTblCell.self
            ),bundle: nil
        )
        
    }
    
    static func idetifire() -> String {
        String(describing: MyTeamTblCell.self)
    }
    
}
