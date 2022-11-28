//
//  PackageHistoryTblCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

class PackageHistoryTblCell: UITableViewCell {

    @IBOutlet weak var uiViewCard: UIView!
    @IBOutlet weak var labelPackageType: UILabel!
    @IBOutlet weak var labelDeliveries: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    var data: PackageListDataApiResponse? {
        didSet {
            labelPackageType.text = data?.packageName
            labelDeliveries.text = "\(data?.noOfDelivery ?? 0) Delivery"
            labelPrice.text = "\(data?.packageAmt ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        uiViewCard.setCardView()
        
    }
    
    
}

extension PackageHistoryTblCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: PackageHistoryTblCell.self
            ),bundle: nil
        )
        
    }
    
    static func idetifire() -> String {
        String(describing: PackageHistoryTblCell.self)
    }
    
}
