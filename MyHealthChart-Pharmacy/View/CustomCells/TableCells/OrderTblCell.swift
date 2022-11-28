//
//  OrderTblCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 02/10/21.
//

import UIKit

class OrderTblCell: UITableViewCell {

    @IBOutlet weak var uiViewCard: UIView!
    
    @IBOutlet weak var labelOrderStatus: AppTagLabel!
    
    @IBOutlet weak var labelOrderNoTitle: UILabel!
    @IBOutlet weak var labelCustomerNameTitle: UILabel!
    @IBOutlet weak var labelTimeTitle: UILabel!
    
    @IBOutlet weak var labelOrderNo: UILabel!
    @IBOutlet weak var labelCustomerName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var stackViewOrderStatus: UIStackView!
    @IBOutlet weak var labelOrderStatusSearch: UILabel!
    
    var btnViewHandler: (()->Void)?

    
    @IBOutlet var uiViewBtnView: UIView!
    @IBOutlet var btnView: AppThemeButton!
    
    var upcomingData: CommonOrderContentApiReponse? {
        didSet {
            labelOrderNo.text = upcomingData?.orderNo
            labelCustomerName.text = upcomingData?.customerName
            labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: upcomingData?.receiveTime)
        }
    }
    
    var readyForPickupData: ReadyForPickupContentApiResponse? {
        didSet {
            
            labelTimeTitle.text = "Assign Time"
            btnView.setTitle("Re Assign", for: .normal)
            btnView.backgroundColor = .appColor.assignColor
            
            labelOrderNo.text = readyForPickupData?.orderNo
            labelCustomerName.text = readyForPickupData?.customerName
            labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: readyForPickupData?.assignTime)
            btnView.isHidden = readyForPickupData?.isLogisticDelivery == "true" ? true : false
        }
    }
    
    var outForDeliveryData: OutForDeliveryContentApiResponse? {
        didSet {
            labelTimeTitle.text = "Pickup"
            uiViewBtnView.isHidden = true
            
            let deliveryBoy = outForDeliveryData?.isLogisticDelivery == "true" ? "External Delivery boy" : outForDeliveryData?.deliveryBoyname
            
            labelOrderNo.text = outForDeliveryData?.orderNo
            labelCustomerName.text = outForDeliveryData?.customerName
            labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: outForDeliveryData?.pickupTime)
            labelTime.text! += ", \(deliveryBoy ?? "")"
        }
    }
    
    var rejectedOrderData: RejectOrderContentApiResponse? {
        didSet {
            btnView.isHidden = true
            labelTimeTitle.text = "Rejected Reason"
            
            labelOrderNo.text = rejectedOrderData?.orderNo
            labelCustomerName.text = rejectedOrderData?.customerName
            labelTime.text = rejectedOrderData?.rejectReason
            
        }
    }
    
    var cancelledOrderData: CancelOrderContentApiResponse? {
        didSet {
            btnView.isHidden = true
            labelTimeTitle.text = "Cancelled Reason"
            
            labelOrderNo.text = cancelledOrderData?.orderNo
            labelCustomerName.text = cancelledOrderData?.customerName
            labelTime.text = cancelledOrderData?.cancelledReason
        }
    }
    
    var returnOrderData: ReturnOrderContentApiResponse? {
        didSet {
            
            if let date = returnOrderData?.returnConfirmDate {
                if date.isEmpty {
                    btnView.isHidden = false
                    btnView.setTitle("Return", for: .normal)
                } else {
                    btnView.isHidden = true
                }
            } else {
                btnView.isHidden = false
                btnView.setTitle("Return", for: .normal)
            }
            
            labelTimeTitle.text = "Delivery Time"
            
            labelOrderNo.text = returnOrderData?.orderNo
            labelCustomerName.text = returnOrderData?.customerName
            
            let deliveryBoy = returnOrderData?.deliveryBoyname
            labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: returnOrderData?.deliveryTime)
            labelTime.text! += ", \(deliveryBoy ?? "")"
        }
    }
    
    var todayPendingOrderData: TodayPendingOrderContentApiResponse? {
        didSet {
            btnView.isHidden = true
            labelOrderStatus.isHidden = false
            
            let deliveryBoy = todayPendingOrderData?.deliveryBoyname
            
            labelOrderNo.text = todayPendingOrderData?.orderNo
            labelCustomerName.text = todayPendingOrderData?.customerName
            labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: todayPendingOrderData?.orderTime)
            labelTime.text! += ", \(deliveryBoy ?? "")"
            
            switch todayPendingOrderData?.orderStatus {
                    
                case OrderStatus.upcoming.serverString:
                    
                    labelOrderStatus.text = OrderStatus.upcoming.displayString
                    labelOrderStatus.textColor = .appColor.appThemeColor
                    labelOrderStatus.backgroundColor = .appColor.appThemeOpacColor
                    
                case OrderStatus.accepted.serverString:
                    
                    labelOrderStatus.text = OrderStatus.accepted.displayString
                    labelOrderStatus.textColor = .appColor.standardColor
                    labelOrderStatus.backgroundColor = .appColor.standardOpacColor
                    
                case OrderStatus.readyforpickup.serverString:
                    
                    labelOrderStatus.text = OrderStatus.readyforpickup.displayString
                    labelOrderStatus.textColor = .appColor.ratingFilledColor
                    labelOrderStatus.backgroundColor = .appColor.ratingOpacColor
                    
                case OrderStatus.outfordelivery.serverString:
                    
                    labelOrderStatus.text = OrderStatus.outfordelivery.displayString
                    labelOrderStatus.textColor = .appColor.assignColor
                    labelOrderStatus.backgroundColor = .appColor.assignOpacColor
                    
                case OrderStatus.returned.serverString:
                    
                    labelOrderStatus.text = OrderStatus.returned.displayString
                    labelOrderStatus.textColor = .appColor.expressColor
                    labelOrderStatus.backgroundColor = .appColor.expressOpacColor
                    
                case OrderStatus.cancelled.serverString:
                    
                    labelOrderStatus.text = OrderStatus.cancelled.displayString
                    labelOrderStatus.textColor = .appColor.expressColor
                    labelOrderStatus.backgroundColor = .appColor.expressOpacColor
                    
                case OrderStatus.rejected.serverString:
                    
                    labelOrderStatus.text = OrderStatus.rejected.displayString
                    labelOrderStatus.textColor = .appColor.expressColor
                    labelOrderStatus.backgroundColor = .appColor.expressOpacColor
                    
                case OrderStatus.completed.serverString:
                    
                    labelOrderStatus.text = OrderStatus.completed.displayString
                    labelOrderStatus.textColor = .appColor.appThemeColor
                    labelOrderStatus.backgroundColor = .appColor.appThemeOpacColor
                    
                default:
                    labelOrderStatus.text = todayPendingOrderData?.orderStatus?.capitalized
            }
            
        }
    }
    
    var dashboardSearch: DashBoardSearchDataApiReponse? {
        didSet {
            stackViewOrderStatus.isHidden = false
            labelOrderNo.text = dashboardSearch?.orderno
            labelCustomerName.text = dashboardSearch?.customerName
            
            switch dashboardSearch?.orderStatus {
                    
                case OrderStatus.upcoming.serverString:
                    
                    labelOrderStatusSearch.text = OrderStatus.upcoming.displayString
                    labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: dashboardSearch?.receiveTime)
                    
                case OrderStatus.accepted.serverString:
                    
                    labelOrderStatusSearch.text = OrderStatus.accepted.displayString
                    
                    labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: dashboardSearch?.receiveTime)
                    
                    btnView.setTitle("Assign", for: .normal)
                    btnView.backgroundColor = .appColor.assignColor
                    
                case OrderStatus.readyforpickup.serverString:
                    
                    labelTimeTitle.text = "Assign Time"
                    
                    labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: dashboardSearch?.assignTime)
                    
                    btnView.setTitle("Re Assign", for: .normal)
                    btnView.backgroundColor = .appColor.assignColor
                    labelOrderStatusSearch.text = OrderStatus.readyforpickup.displayString
                    btnView.isHidden = dashboardSearch?.isLogisticDelivery == "true" ? true : false
                    
                case OrderStatus.outfordelivery.serverString:
                    
                    labelTimeTitle.text = "Pickup"
                    uiViewBtnView.isHidden = true
                    
                    let deliveryBoy = dashboardSearch?.isLogisticDelivery == "true" ? "External Delivery boy" : dashboardSearch?.deliveryboyname
                    labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: dashboardSearch?.pickupTime)
                    labelTime.text! += ", \(deliveryBoy ?? "")"

                    labelOrderStatusSearch.text = OrderStatus.outfordelivery.displayString
                    
                case OrderStatus.completed.serverString:
                    
                    labelOrderStatusSearch.text = OrderStatus.completed.displayString
                    
                case OrderStatus.rejected.serverString:
                    
                    btnView.isHidden = true
                    labelTimeTitle.text = "Rejected Reason"
                    labelOrderStatusSearch.text = OrderStatus.rejected.displayString
                    labelTime.text = dashboardSearch?.rejectedReason
                    
                case OrderStatus.cancelled.serverString:
                    
                    btnView.isHidden = true
                    labelTimeTitle.text = "Cancelled Reason"
                    labelOrderStatusSearch.text = OrderStatus.cancelled.displayString
                    labelTime.text = dashboardSearch?.cancelledReason
                    
                case OrderStatus.returned.serverString:
                    
                    if let date = dashboardSearch?.returnConfirmTime {
                        if date.isEmpty {
                            btnView.isHidden = false
                            btnView.setTitle("Return", for: .normal)
                        } else {
                            btnView.isHidden = true
                        }
                    } else {
                        btnView.isHidden = false
                        btnView.setTitle("Return", for: .normal)
                    }
                    
                    labelTimeTitle.text = "Delivery Time"

                    let deliveryBoy = dashboardSearch?.deliveryboyname
                    labelTime.text = DateHelper.shared.getOrderFormateDate(serverDate: dashboardSearch?.returnTime)
                    labelTime.text! += ", \(deliveryBoy ?? "")"
                    
                    labelOrderStatusSearch.text = OrderStatus.returned.displayString
                    
                default:
                    labelOrderStatus.text = dashboardSearch?.orderStatus?.capitalized
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        uiViewCard.setCardView()
    }
    
    @IBAction func btnViewPressed(_ sender: AppThemeButton) {
        btnViewHandler?()
    }
    
}

extension OrderTblCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: OrderTblCell.self
            ),bundle: nil
        )
        
    }
    
    static func idetifire() -> String {
        String(describing: OrderTblCell.self)
    }
    
}
