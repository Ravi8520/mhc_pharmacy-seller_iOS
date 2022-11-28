//
//  OrderDetailVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 07/10/21.
//

import UIKit
import Cosmos

extension OrderDetailVC {
    static func instantiate() -> OrderDetailVC {
        StoryBoardConstants.orderDetail.instantiateViewController(withIdentifier: String(describing: OrderDetailVC.self)) as! OrderDetailVC
    }
}

class OrderDetailVC: UIViewController {
   
    
    //===//
    @IBOutlet weak var uiViewPaymentDetail: UIView!
    

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblRefNo: UILabel!
    
    //===//
    
    
    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var scrollViewContent: UIScrollView!
    @IBOutlet weak var uiViewContent: UIView!
    
    // ==== //
    
    @IBOutlet weak var uiViewPrescriptionContainer: UIView!
    @IBOutlet weak var imageViewPrescription: UIImageView!
    @IBOutlet weak var uiViewPrecriptionOverlay: RoundView!
    @IBOutlet weak var labelPrescriptionCount: AppTagLabel!
    
    // ==== //
    
    @IBOutlet weak var uiViewPrescriptionHolder: UIView!
    @IBOutlet weak var stackViewOrderNote: UIStackView!
    @IBOutlet var labelPrescriptionOrderType: UILabel!
    @IBOutlet weak var labelOrderNote: UILabel!
    
    // ==== //
    
    @IBOutlet weak var uiViewManualOrderContainer: UIView!
    @IBOutlet weak var tableViewManualOrder: UITableView!
    @IBOutlet weak var manualOrderTblHeight: NSLayoutConstraint!
    
    // ==== //
    
    @IBOutlet weak var uiViewOrderDetailContainer: UIView!
    @IBOutlet weak var labelDeliveryType: UILabel!
    @IBOutlet weak var labelOrderType: UILabel!
    @IBOutlet weak var labelLeaveWithNeighbour: UILabel!
    
    // ==== //
    
    @IBOutlet weak var uiViewRating: CosmosView!
    
    @IBOutlet weak var uiViewOrderTimeLineHeaderContainer: UIView!
    @IBOutlet weak var imageViewOrderTimeLineClosure: UIImageView!
    
    // ==== //
    
    @IBOutlet weak var uiViewOrderTimeLineCotainer: UIView!
    
    // ====
    
    @IBOutlet weak var stackViewOrderReceivedAt: UIStackView!
    @IBOutlet weak var imageViewOrderReceivedBlueDot: UIImageView!
    @IBOutlet weak var imageViewOrderReceivedAtBlueLine: UIImageView!
    @IBOutlet weak var labelOrderReceivedAtDate: UILabel!
    
    // ====
    
    @IBOutlet weak var stackViewOrderAcceptAt: UIStackView!
    @IBOutlet weak var imageViewOrderAcceptedAtBlueLine1: UIImageView!
    @IBOutlet weak var imageViewOrderAcceptedAtBlueDot: UIImageView!
    @IBOutlet weak var imageViewOrderAcceptedAtBlueLine2: UIImageView!
    @IBOutlet weak var labelOrderAcceptedAtDate: UILabel!
    
    // ====
    
    @IBOutlet weak var stackViewOrderAssignAt: UIStackView!
    @IBOutlet weak var imageViewOrderAssignToBlueLine1: UIImageView!
    @IBOutlet weak var imageViewOrderAssignToBlueDot: UIImageView!
    @IBOutlet weak var imageViewOrderAssignToBlueLine2: UIImageView!
    @IBOutlet weak var labelAssignToDate: UILabel!
    @IBOutlet weak var stackViewOrderAssignToHolder: UIStackView!
    @IBOutlet weak var imageViewInvoice: UIImageView!
    @IBOutlet weak var uiViewInvoiceOverlay: RoundView!
    @IBOutlet weak var labelInvoiceCount: AppTagLabel!
    @IBOutlet weak var labelOrderAmount: UILabel!
    
    // ====
    
    @IBOutlet weak var stackViewOrderPickup: UIStackView!
    @IBOutlet weak var imageViewOrderPickupBlueLine1: UIImageView!
    @IBOutlet weak var imageViewOrderPickupBlueDot: UIImageView!
    @IBOutlet weak var imageViewOrderPickupBlueLine2: UIImageView!
    @IBOutlet weak var labelOrderPickupDate: UILabel!
    @IBOutlet weak var uiViewOrderPickupImageContainer: UIView!
    @IBOutlet weak var imageViewOrderPickupImage: UIImageView!
    @IBOutlet weak var uiViewOrderPickupOverlay: RoundView!
    @IBOutlet weak var labelOrderPickupImageCount: AppTagLabel!
    
    // ====
    
    @IBOutlet weak var stackViewOrderDrop: UIStackView!
    @IBOutlet weak var imageViewOrderDropBlueLine1: UIImageView!
    @IBOutlet weak var imageViewOrderDropBlueDot: UIImageView!
    @IBOutlet weak var labelOrderDropDate: UILabel!
    @IBOutlet weak var uiViewDropOrderImageContainer: UIView!
    @IBOutlet weak var imageViewOrderDropImage: UIImageView!
    @IBOutlet weak var uiViewOrderDropImageOverlay: RoundView!
    @IBOutlet weak var labelOrderDropImageCount: AppTagLabel!
    
    // ====
    
    @IBOutlet weak var stackViewDeliveryAttempted: UIStackView!
    @IBOutlet weak var imageViewDeliveryAttemptedBlueLine1: UIImageView!
    @IBOutlet weak var imageViewDeliveryAttemptedBlueDot: UIImageView!
    @IBOutlet weak var imageViewDeliveryAttemptedBlueLine2: UIImageView!
    @IBOutlet weak var labelDeliveryAttemptedDate: UILabel!
    
    // ====
    
    @IBOutlet weak var stackViewReturnAtMedical: UIStackView!
    @IBOutlet weak var imageViewReturnAtMedicalLine1: UIImageView!
    @IBOutlet weak var imageViewReturnAtMedicalBlueDot: UIImageView!
    @IBOutlet weak var labelReturnAtMedicalDate: UILabel!
    @IBOutlet weak var labelReturnReason: UILabel!
    
    // ====
    
    @IBOutlet weak var stackViewRejectedAt: UIStackView!
    @IBOutlet weak var labelRejectedAtDate: UILabel!
    @IBOutlet weak var labelRejectedAtReason: UILabel!
    
    // ====
    
    @IBOutlet weak var stackViewCancelledAt: UIStackView!
    @IBOutlet weak var labelCancelledAtDate: UILabel!
    @IBOutlet weak var labelCancelledAtReason: UILabel!
    
    // ==== //
    
    @IBOutlet weak var uiViewCustomerDetailHeaderContainer: UIView!
    @IBOutlet weak var imageViewCustomerDetailClosure: UIImageView!
    
    @IBOutlet weak var uiViewCustomerDetailContainer: UIView!
    @IBOutlet weak var labelCustomerName: UILabel!
    @IBOutlet weak var labelMobileNo: UILabel!
    @IBOutlet weak var labelCustomerLocation: UILabel!
    @IBOutlet weak var labelPrescriptionName: UILabel!
    
    @IBOutlet weak var stackViewUpcomingButtons: UIStackView!
    @IBOutlet weak var uiViewAcceptRejectButtons: HalfCornerView!
    @IBOutlet weak var btnAssign: HalfCornerButton!
    @IBOutlet weak var btnReassign: HalfCornerButton!
    @IBOutlet weak var btnConfirmReturn: HalfCornerButton!
    
    private var isCustomerDetailCollapse = true
    private var isOrderTimeLineCollapse = true
    
    var orderId = ""
    var status = ""
    
    
    var orderDetailData: OrderDetailDataApiResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        uiViewContent.isHidden = true
        setupDelegates()
        uiViewToolBar.btnSearch.isHidden = true
        if self.status == "paid"
        {
            self.uiViewPaymentDetail.isHidden = false
        }else{
            self.uiViewPaymentDetail.isHidden = true
        }
        
        tableViewManualOrder.estimatedRowHeight = 60
        tableViewManualOrder.rowHeight = UITableView.automaticDimension
        
        getOrderDetail()
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
    }
    
    @IBAction func btnFullScreenPressed(_ sender: UIButton) {
        let vc = OrderPrescriptionDetailVC.instantiate()
        vc.data = orderDetailData
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOrderTimeLinePressed(_ sender: UIButton) {
        
        isOrderTimeLineCollapse = !isOrderTimeLineCollapse
        uiViewOrderTimeLineCotainer.isHidden = isOrderTimeLineCollapse
        
        UIView.animate(withDuration: 0.3) { [self] in
            imageViewOrderTimeLineClosure.transform = CGAffineTransform(rotationAngle: isOrderTimeLineCollapse ? 0 : .pi/2)
            view.layoutSubviews()
            scrollViewContent.layoutSubviews()
            uiViewContent.layoutSubviews()
            
        }
        
    }
    
    @IBAction func btnInvoiceFullScreenPressed(_ sender: UIButton) {
        let vc = FullScreenSwipableVC.instantiate()
        vc.imageUrl = orderDetailData?.invoice?.map({ $0.image ?? "" }) ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOrderPickupImageFullScreenPressed(_ sender: UIButton) {
        let vc = FullScreenSwipableVC.instantiate()
        vc.imageUrl = orderDetailData?.pickup_images?.map({ $0.image ?? "" }) ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOrderDropImageFullScreenPressed(_ sender: UIButton) {
        let vc = FullScreenSwipableVC.instantiate()
        vc.imageUrl = orderDetailData?.drop_images?.map({ $0.image ?? "" }) ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func btnCustomerDetailPressed(_ sender: UIButton) {
        
        isCustomerDetailCollapse = !isCustomerDetailCollapse
        uiViewCustomerDetailContainer.isHidden = isCustomerDetailCollapse
        
        UIView.animate(withDuration: 0.3) { [self] in
            imageViewCustomerDetailClosure.transform = CGAffineTransform(rotationAngle: isCustomerDetailCollapse ? 0 : .pi/2)
            view.layoutSubviews()
            scrollViewContent.layoutSubviews()
            uiViewContent.layoutSubviews()
            
        }
        
    }
    
    @IBAction func btnMakeCallPressed(_ sender: UIButton) {
        if let number = orderDetailData?.mobile_number {
            Helper.shared.sendNumberForCall(num: number)
        }
    }
    
    @IBAction func btnRejectOrderPressed(_ sender: UIButton) {
        
        let vc = RejectReasonVC.instantiate()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnAcceptPressed(_ sender: UIButton) {
        acceptOrder()
    }
    
    @IBAction func btnAssignPressed(_ sender: HalfCornerButton) {
        let vc = InvoiceUploadVC.instantiate()
        vc.delegate = self
        vc.orderId = orderId
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnReassignPressed(_ sender: HalfCornerButton) {
        let vc = InvoiceUploadVC.instantiate()
        vc.delegate = self
        vc.orderId = orderId
        vc.screenType = .reassignOrder
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnConfirmReturnPressed(_ sender: HalfCornerButton) {
        returnConfirmOrder()
    }
    
    
}

@IBDesignable class shadowCornerView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}

extension OrderDetailVC: ToolBarDelegate, RejectReasonDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
}

@IBDesignable class shadowCornerRadiousView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            
            //self.roundCorners([.bottomLeft, .bottomRight], radius: cornerRadius)
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            
            self.layer.masksToBounds = false
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = 2
            
            let backgroundCGColor = backgroundColor?.cgColor
            backgroundColor = nil
            layer.backgroundColor =  backgroundCGColor
            
            setNeedsLayout()
        }
    }
}
