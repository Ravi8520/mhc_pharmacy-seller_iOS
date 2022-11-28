//
//  NotificationTblCell.swift
//  My Pharmacy
//
//  Created by Jat42 on 20/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

class NotificationTblCell: UITableViewCell {

    @IBOutlet weak var uiViewShadow: UIView!
    @IBOutlet weak var uiViewCard: UIView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    var data: NotificationContentApiResponse? {
        didSet {
            labelTitle.text = data?.title
            labelDetail.text = data?.subtitle
            //labelTime.text = data?.createdAt
            labelDate.text = DateHelper.shared.convertAppDate(oldDate24: data?.created_date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        
        uiViewShadow.setCardView()
        uiViewCard.setCornerRadius(isMaskedToBound: true)
    }
    
}

extension NotificationTblCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: NotificationTblCell.self
            ),bundle: nil)
        
    }
    
    static func idetifire() -> String {
        String(describing: NotificationTblCell.self)
    }
    
}
