//
//  CompleteOrderTblCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 02/10/21.
//

import UIKit

class CompleteOrderTblCell: UITableViewCell {

    @IBOutlet weak var uiViewCard: UIView!
    
    @IBOutlet weak var labelOrderNoTitle: UILabel!
    @IBOutlet weak var labelCustomerNameTitle: UILabel!
    @IBOutlet weak var labelTimeTitle: UILabel!
    
    @IBOutlet weak var labelOrderNo: UILabel!
    @IBOutlet weak var labelCustomerName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var imageViewStar: UIImageView!
    
    @IBOutlet weak var stackViewOrderStatus: UIStackView!
    @IBOutlet weak var labelDashboardSearchStatus: UILabel!
    @IBOutlet weak var labelDashboardSearchTitle: UILabel!
    
    
    
    @IBOutlet weak var ladgerDateTime: UILabel!
    @IBOutlet weak var LadgerDateTimeTitle: UILabel!
    @IBOutlet weak var ladgerDatestackView: UIStackView!
    
    @IBOutlet weak var lblAmountTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAmountView: UIView!
    
    
    @IBOutlet var uiViewStarView: UIView!
    
    var completeOrderData: CompleteOrderContentApiResponse? {
        didSet {
            labelOrderNo.text = completeOrderData?.orderNo
            labelCustomerName.text = completeOrderData?.customerName
            labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: completeOrderData?.deliveryTime)+", "+String(completeOrderData?.deliveryBoyname ?? "")
            labelRating.text = completeOrderData?.rating == "" ? "N/A" : completeOrderData?.rating
            imageViewStar.image = imageViewStar.image?.withRenderingMode(.alwaysTemplate)
            imageViewStar.tintColor = completeOrderData?.rating == "" ? .appColor.shadowColor : .appColor.ratingFilledColor
        }
    }
    
    var orderReportData: OrderReportListContentApiReponse? {
        didSet {
            labelOrderNo.text = orderReportData?.orderNo
            labelCustomerName.text = orderReportData?.customerName
            labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: orderReportData?.deliveryTime)
            
            if let name = orderReportData?.deliveryBoyname {
                if !name.isEmpty {
                    labelTime.text! += ", \(name)"
                }
            }
            labelRating.text = orderReportData?.rating == "" ? "N/A" : orderReportData?.rating
            imageViewStar.image = imageViewStar.image?.withRenderingMode(.alwaysTemplate)
            imageViewStar.tintColor = orderReportData?.rating == "" ? .appColor.shadowColor : .appColor.ratingFilledColor
        }
    }
    
    var UnpaidData: UnpidlDataApiResponse? {
        didSet {
            labelOrderNo.text = UnpaidData?.order_number
            labelCustomerName.text = UnpaidData?.customer_name
            labelTime.text = UnpaidData?.deliver_datetime
            labelTime.text =  "₹ \(UnpaidData?.order_amount ?? "")"
            labelTimeTitle.text = "Order Amount"
        }
    }
    
    var orderDataList: OrderData? {
        didSet {
            lblAmountView.isHidden = false
            labelOrderNo.text = orderDataList?.order_number
            labelCustomerName.text = orderDataList?.customer_name
            
            let assignDate = orderDataList?.deliver_datetime
            let deliveryBoy = orderDataList?.delivery_boy
          
            labelTime.text = "\(assignDate!), \(deliveryBoy!)"
            labelRating.text = orderDataList?.rating == "" ? "N/A" : orderDataList?.rating
            imageViewStar.image = imageViewStar.image?.withRenderingMode(.alwaysTemplate)
            imageViewStar.tintColor = orderDataList?.rating == "" ? .appColor.shadowColor : .appColor.ratingFilledColor
            
            lblAmountTitle.text = "Amount"
            lblAmount.text =  "₹ \(orderDataList?.order_amount ?? "")"
            
        }
    }
    
    
    
    
    var dashboardSearch: DashBoardSearchDataApiReponse? {
        didSet {
            stackViewOrderStatus.isHidden = false
            labelOrderNo.text = dashboardSearch?.orderno
            labelCustomerName.text = dashboardSearch?.customerName
            labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: dashboardSearch?.deliveredTime)
            
            switch dashboardSearch?.orderStatus {

                case OrderStatus.completed.serverString:

                    labelDashboardSearchStatus.text = OrderStatus.completed.displayString

                    labelRating.text = dashboardSearch?.rating == "" ? "N/A" : dashboardSearch?.rating
                    imageViewStar.image = imageViewStar.image?.withRenderingMode(.alwaysTemplate)
                    imageViewStar.tintColor = dashboardSearch?.rating == "" ? .appColor.shadowColor : .appColor.ratingFilledColor
                    
                default:
                    labelDashboardSearchStatus.text = dashboardSearch?.orderStatus?.capitalized
            }
        }
    }
    var orderFeedbackData: OrderFeedBackContentApiResponse? {
        didSet {
            labelTimeTitle.text = "Order Status"
            
            labelOrderNo.text = orderFeedbackData?.orderNumber
            labelCustomerName.text = orderFeedbackData?.customerName
            
            labelRating.text = orderFeedbackData?.rating == "" ? "N/A" : orderFeedbackData?.rating
            imageViewStar.image = imageViewStar.image?.withRenderingMode(.alwaysTemplate)
            imageViewStar.tintColor = orderFeedbackData?.rating == "" ? .appColor.shadowColor : .appColor.ratingFilledColor
            
            switch orderFeedbackData?.orderStatus {
                    
                case OrderStatus.upcoming.serverString:
                    labelTime.text = OrderStatus.upcoming.displayString
                case OrderStatus.accepted.serverString:
                    labelTime.text = OrderStatus.accepted.displayString
                case OrderStatus.readyforpickup.serverString:
                    labelTime.text = OrderStatus.readyforpickup.displayString
                case OrderStatus.outfordelivery.serverString:
                    labelTime.text = OrderStatus.outfordelivery.displayString
                case OrderStatus.completed.serverString:
                    labelTime.text = OrderStatus.completed.displayString
                case OrderStatus.rejected.serverString:
                    labelTime.text = OrderStatus.rejected.displayString
                case OrderStatus.cancelled.serverString:
                    labelTime.text = OrderStatus.cancelled.displayString
                case OrderStatus.returned.serverString:
                    labelTime.text = OrderStatus.returned.displayString
                default:
                    labelTime.text = orderFeedbackData?.orderStatus?.capitalized
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        lblAmountView.isHidden = true
        uiViewCard.setCardView()
    }
}

extension CompleteOrderTblCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: CompleteOrderTblCell.self
            ),bundle: nil
        )
        
    }
    
    static func idetifire() -> String {
        String(describing: CompleteOrderTblCell.self)
    }
    
}
