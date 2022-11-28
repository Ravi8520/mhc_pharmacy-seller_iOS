//
//  TodayOrderTblCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 04/10/21.
//

import UIKit

class TodayOrderTblCell: UITableViewCell {

    @IBOutlet weak var uiViewCard: UIView!
    
    @IBOutlet weak var labelOrderNoTitle: UILabel!
    @IBOutlet weak var labelReceiveTimeTitle: UILabel!
    @IBOutlet weak var labelCustomerNameTitle: UILabel!
    @IBOutlet weak var labelOrderAmtTitle: UILabel!
    
    @IBOutlet weak var labelOrderNo: UILabel!
    @IBOutlet weak var labelReceiveTime: UILabel!
    @IBOutlet weak var labelCustomerName: UILabel!
    @IBOutlet weak var labelOrderAmt: UILabel!
    
    var data: EarningContentApiResponse? {
        didSet {
            labelOrderNo.text = data?.orderNo
            labelReceiveTime.text = DateHelper.shared.getOrderFormateDate(serverDate: data?.orderTime)
            labelReceiveTime.text! += "\n\(data?.deliveryBoyname ?? "")"
            labelOrderAmt.text = "₹ "
            labelOrderAmt.text! += String(format: "%.2f", data?.orderAmt ?? 0)
            labelCustomerName.text! = "\n\(data?.customerName ?? "")"
        }
    }
    
    var deliveryData: DeliveryContentApiResponse? {
        didSet {
            labelReceiveTimeTitle.text = "Delivery Time"
            
            labelOrderAmt.isHidden = true
            labelOrderAmtTitle.isHidden = true
            
            labelOrderNo.text = deliveryData?.orderNo
            labelCustomerName.text = deliveryData?.customerName
            labelReceiveTime.text = DateHelper.shared.getOrderFormateDate(
                serverDate: deliveryData?.deliveryTime
            )
            labelReceiveTime.text! += "\n\(deliveryData?.deliveryBoyname ?? "")"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        uiViewCard.setCardView()
    }

    
    
}

extension TodayOrderTblCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: TodayOrderTblCell.self
            ),bundle: nil
        )
        
    }
    
    static func idetifire() -> String {
        String(describing: TodayOrderTblCell.self)
    }
    
}
