//
//  OrderDetailsVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Mac Mini on 08/04/22.
//

import UIKit

extension OrderDetailsVC {
    static func instantiate() -> OrderDetailsVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: OrderDetailsVC.self)) as! OrderDetailsVC
    }
}


class OrderDetailsVC: UIViewController {
    
    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var scrollViewContent: UIScrollView!
    @IBOutlet weak var uiViewContent: UIView!
    
    
    @IBOutlet weak var btnCancel: HalfCornerButton!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet weak var lblOrdercancelAt: UILabel!
    @IBOutlet weak var lblOrderReturnTime: UILabel!
    @IBOutlet weak var lblOrderPickupTime: UILabel!
    @IBOutlet weak var lblOrderCreatedat: UILabel!
    
    @IBOutlet weak var stackVOrderPickUp: UIStackView!
    @IBOutlet weak var stackVOrderReturn: UIStackView!
    @IBOutlet weak var stackViewCancelOrder: UIStackView!
    @IBOutlet weak var uiViewCustomerDetailContainer: UIView!
    @IBOutlet weak var lblOrderAmount: UILabel!
    
    @IBOutlet weak var imageViewCustomerDetailClosure: UIImageView!
    
    @IBOutlet weak var uiViewcancelReason: CustomView!
    
    @IBOutlet weak var txtReason: SkyFloatingLabelTextField!
    
    private var isCustomerDetailCollapse = true
    private var isOrderTimeLineCollapse = true
    
    var orderId = ""
    var cancelbtn = false
    var canelOrder = false
    
    var orderDetailData: ManualOrderDetailDataApiResponse?
        var orderTimeLine : [Ordertime] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrderId==>>" , orderId)
        setupView()
        if cancelbtn {
            btnCancel.isHidden = true
        }else{
            btnCancel.isHidden = false
        }
        
        if canelOrder {
            stackViewCancelOrder.isHidden = false
            stackVOrderReturn.isHidden = true
            stackVOrderPickUp.isHidden = true

        }else{
            stackViewCancelOrder.isHidden = true
            stackVOrderReturn.isHidden = false
            stackVOrderPickUp.isHidden = false
        }
        
    }
    
    private func setupView() {
        setupDelegates()
        uiViewToolBar.btnSearch.isHidden = true
        uiViewcancelReason.isHidden = true
        getOrderDetail()
    }
    private func setupDelegates() {
        uiViewToolBar.delegate = self
    }
    
    func setupData(){
        
        self.lblCustomerName.text = orderDetailData?.name
        self.lblMobileNumber.text = orderDetailData?.mobile_number
        self.lblLocation.text = orderDetailData?.address
        lblOrderAmount.text = "Order Amount   ₹ " + String(orderDetailData?.order_amount ?? 0)
        uiViewToolBar.labelTitle.text = "#" + (orderDetailData?.order_number ?? "")
        
        for data in orderTimeLine {
            switch data.slug
            {
            case "created":
                lblOrderCreatedat.text = data.date
                break
                
            case "pickup":
                
                if data.title == "Order pickup at" {
                    lblOrderPickupTime.text = data.date
                }else{
                    lblOrderPickupTime.isHidden = true
                    
                }
                
                break
                
            case "complete":
                if data.title == "Order complete at" {
                    lblOrderReturnTime.text = data.date
                }else{
                    lblOrderReturnTime.isHidden = true
                }
                
                break
                
            case "cancel":
                if data.title == "Order cancel at" {
                    lblOrdercancelAt.text = data.date
                }else{
                    lblOrdercancelAt.isHidden = true
                }
                
                break
            default:
                print("** Error")
                break
            }
            
        }
        
    }
    
    func CancelOrder() {
        
        guard !orderId.isEmpty else { return }
        
        let param = [
            Parameter.ordersId : orderId,
            Parameter.CancelReason : txtReason.text!
        ]
        
        Networking.request(
            url: Urls.manualDeliveryOrderCancel,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            switch response {
                
            case .success(let data):
                
                guard let jsonData = data else {
                    AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                    return
                }
                
                let resetResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                
                guard let rsResponse = resetResponse else {
                    AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                    return
                }
                
                if rsResponse.status == StatusCode.success.rawValue {
                    
                    // self.present(UpdatePopup.instantiate(), animated: true, completion: nil)
                    self.setupView()
                    self.navigationController?.popViewController(animated: true)
                    
                    
                } else if rsResponse.status == StatusCode.notFound.rawValue {
                    self.present(UpdatePopup.instantiate(), animated: true, completion: nil)
                    
                } else {
                    // present(UpdatePopup.instantiate(), animated: true, completion: nil)
                    AlertHelper.shared.showAlert(message: rsResponse.message!)
                }
                
            case .failure(let error):
                AlertHelper.shared.showAlert(message: error.localizedDescription)
                Log.e(error.localizedDescription)
                Helper.shared.setLogout()
                
            }
        }
        
    }
    
    
    func getOrderDetail() {
        
        guard !orderId.isEmpty else { return }
        
        let param = [
            Parameter.ordersId : orderId
        ]
        
        Networking.request(
            url: Urls.manualDeliveryOrderDetails,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            switch response {
                
            case .success(let data):
                
                guard let jsonData = data else {
                    AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                    return
                }
                
                let orderDetailResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: ManualOrderDetailsApiResponse.self)
                
                guard let odResponse = orderDetailResponse else {
                    AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                    return
                }
                
                if odResponse.status == StatusCode.success.rawValue {
                    
                    guard let data = odResponse.data else { return }
                    
                    self.orderDetailData = data.first ?? nil
                    self.orderTimeLine = self.orderDetailData?.ordertime ?? []
                    self.setupData()
                    
                } else {
                    AlertHelper.shared.showAlert(message: odResponse.message!)
                }
                
            case .failure(let error):
                AlertHelper.shared.showAlert(message: error.localizedDescription)
                Log.e(error.localizedDescription)
            }
        }
        
    }
    
    
    @IBAction func btnCancel(_ sender: Any) {
        uiViewcancelReason.isHidden = false
    }
    
    @IBAction func btnBack(_ sender: Any) {
        uiViewcancelReason.isHidden = true
        
    }
    
    @IBAction func btnCancelOrder(_ sender: Any) {
        if txtReason.text == "" {
            AlertHelper.shared.showAlert(message: "Please enter reason.")
        }else{
            CancelOrder()
        }
        
    }
    @IBAction func btnCustomerDetailPressed(_ sender: Any) {
        
        isCustomerDetailCollapse = !isCustomerDetailCollapse
        uiViewCustomerDetailContainer.isHidden = isCustomerDetailCollapse
        
        UIView.animate(withDuration: 0.3) { [self] in
            imageViewCustomerDetailClosure.transform = CGAffineTransform(rotationAngle: isCustomerDetailCollapse ? 0 : .pi/2)
            view.layoutSubviews()
            scrollViewContent.layoutSubviews()
            uiViewContent.layoutSubviews()
            
        }
        
    }
    @IBAction func btnPhone(_ sender: Any) {
        if let number = orderDetailData?.mobile_number {
            Helper.shared.sendNumberForCall(num: number)
        }
    }
    
}

extension OrderDetailsVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
}
