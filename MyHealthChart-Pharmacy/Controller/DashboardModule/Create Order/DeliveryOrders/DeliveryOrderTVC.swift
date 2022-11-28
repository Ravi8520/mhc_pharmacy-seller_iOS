//
//  DeliveryOrderTVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Mac Mini on 07/04/22.
//

import UIKit

class DeliveryOrderTVC: UITableViewCell {

    @IBOutlet weak var uiView: UIView!

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        uiView.setCardView()
    }
    
    
    var ManualOrderData: ManualOrderContentApiResponse? {
        didSet {
            
            lblCustomerName.text = ManualOrderData?.customerName
            lblOrderNumber.text = "#" + (ManualOrderData?.orderNo ?? "")
            lblStatus.text = "Created Time"
            lblTime.text = (ManualOrderData?.createTime ?? "") + "," + (ManualOrderData?.createdBy ?? "")
        }
    }
    var ManualOrderDataCancel : ManualOrderContentApiResponse? {
        didSet {
            
            lblCustomerName.text = ManualOrderDataCancel?.customerName
            lblOrderNumber.text = "#" + (ManualOrderDataCancel?.orderNo ?? "")
            lblStatus.text = "Cancel Time"
            lblTime.text = (ManualOrderDataCancel?.cancelTime ?? "") + "," + (ManualOrderDataCancel?.createdBy ?? "")
        }
    }
    var ManualOrderDataPickup : ManualOrderContentApiResponse? {
        didSet {
            
            lblCustomerName.text = ManualOrderDataPickup?.customerName
            lblOrderNumber.text = "#" + (ManualOrderDataPickup?.orderNo ?? "")
            lblStatus.text = "Pickup Time"
            lblTime.text = (ManualOrderDataPickup?.pickupTime ?? "") + "," + (ManualOrderDataPickup?.createdBy ?? "")
        }
    }
    var ManualOrderDataComplete : ManualOrderContentApiResponse? {
        didSet {
            
            lblCustomerName.text = ManualOrderDataComplete?.customerName
            lblOrderNumber.text = "#" + (ManualOrderDataComplete?.orderNo ?? "")
            lblStatus.text = "Delivery Time"
            lblTime.text = (ManualOrderDataComplete?.createTime ?? "") + "," + (ManualOrderDataComplete?.createdBy ?? "")
        }
    }
    var ManualOrderDataInComplete : ManualOrderContentApiResponse? {
        didSet {
            
            lblCustomerName.text = ManualOrderDataInComplete?.customerName
            lblOrderNumber.text = "#" + (ManualOrderDataInComplete?.orderNo ?? "")
            lblStatus.text = "Return Time"
            lblTime.text = (ManualOrderDataInComplete?.createTime ?? "") + "," + (ManualOrderDataInComplete?.createdBy ?? "")
        }
    }
}
