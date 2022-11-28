//
//  OrderPrescriptionDetailVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 07/10/21.
//

import UIKit

extension OrderPrescriptionDetailVC {
    static func instantiate() -> OrderPrescriptionDetailVC {
        StoryBoardConstants.orderDetail.instantiateViewController(withIdentifier: String(describing: OrderPrescriptionDetailVC.self)) as! OrderPrescriptionDetailVC
    }
}

class OrderPrescriptionDetailVC: UIViewController {

    @IBOutlet weak var imageViewPrescription: UIImageView!
    @IBOutlet weak var uiViewImageViewPrescriptionOverlay: UIView!
    @IBOutlet weak var labelImageCount: AppTagLabel!
    
    @IBOutlet weak var uiViewAcceptRejectButtons: UIView!
    @IBOutlet weak var btnAssign: HalfCornerButton!
    @IBOutlet weak var btnReassign: HalfCornerButton!
    @IBOutlet weak var btnConfirmReturn: HalfCornerButton!
    
    @IBOutlet weak var tableForOrder: UITableView!
    
    @IBOutlet weak var uiViewOrderNoteContainer: UIView!
    @IBOutlet weak var uiViewOrderContainer: UIView!
    
    @IBOutlet weak var labelOrderNote: UILabel!
    
    var data: OrderDetailDataApiResponse?
    
    var delegate: OrderUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        
        if let orderData = data {
            
            if orderData.order_type != OrderTypes.manualOrder.serverString {
                
                setPrescriptionOrderData()
                setupBottomButtons()
            }
        }
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotePressed(_ sender: UIButton) {
        
        if let orderData = data {
            if orderData.order_note != nil && !orderData.order_note!.isEmpty {
                
                uiViewOrderNoteContainer.isHidden = false
                labelOrderNote.text = orderData.order_note
                
            } else {
                uiViewOrderNoteContainer.isHidden = true
            }
        }
    }
    
    @IBAction func btnOrderPressed(_ sender: UIButton) {
     
        if let orderData = data {
            if orderData.manual_order != nil {
                
                self.tableForOrder.reloadData()
                self.uiViewOrderContainer.isHidden = false
                
            }
        }
    }
    
    @IBAction func btnNoteClosePressed(_ sender: UIButton) {
        
        uiViewOrderNoteContainer.isHidden = true
    }
    
    @IBAction func btnCloseOrderViewPressed(_ sender: UIButton) {
        
        uiViewOrderContainer.isHidden = true
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
        vc.orderId = data?.order_id ?? ""
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnReassignPressed(_ sender: HalfCornerButton) {
        let vc = InvoiceUploadVC.instantiate()
        vc.delegate = self
        vc.orderId = data?.order_id ?? ""
        vc.screenType = .reassignOrder
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnConfirmReturnPressed(_ sender: HalfCornerButton) {
        returnConfirmOrder()
    }
    
    @IBAction func btnImageViewfullScreenPressed(_ sender: UIButton) {
        let vc = FullScreenSwipableVC.instantiate()
        vc.imageUrl = data?.prescription_image?.map({ $0.image ?? "" }) ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupBottomButtons() {
        
        switch data!.order_status {
                
            case OrderStatus.upcoming.serverString:
                
                uiViewAcceptRejectButtons.isHidden = false
                btnAssign.isHidden = true
                btnReassign.isHidden = true
                
            case OrderStatus.accepted.serverString:
                
                uiViewAcceptRejectButtons.isHidden = true
                btnAssign.isHidden = false
                btnReassign.isHidden = true
                
            case OrderStatus.readyforpickup.serverString:
                
                uiViewAcceptRejectButtons.isHidden = true
                btnAssign.isHidden = true
                
                if data!.delivery_type == DeliveryType.internald.serverString || data!.delivery_type == DeliveryType.both.serverString {
                    btnReassign.isHidden = false
                } else {
                    btnReassign.isHidden = true
                }
                
            case OrderStatus.returned.serverString:
                
                uiViewAcceptRejectButtons.isHidden = true
                btnAssign.isHidden = true
                btnReassign.isHidden = true
                
                if data!.return_confirm_date!.isEmpty {
                    btnConfirmReturn.isHidden = false
                } else {
                    btnConfirmReturn.isHidden = true
                }
                
            default:
                uiViewAcceptRejectButtons.isHidden = true
                btnAssign.isHidden = true
                btnReassign.isHidden = true
        }
        
    }
    
    private func setPrescriptionOrderData() {

        guard data?.prescription_image != nil else { return }
        
        guard !data!.prescription_image!.isEmpty else { return }
        
        imageViewPrescription.image = #imageLiteral(resourceName: "ic_prescription_placeHolder")
        
        if data!.prescription_image!.count > 1 {
            uiViewImageViewPrescriptionOverlay.isHidden = false
            labelImageCount.text = "+\(data!.prescription_image!.count-1)"
        } else {
            uiViewImageViewPrescriptionOverlay.isHidden = true
        }
        
        // Pdf prescription setup is remains
        
        if data!.prescription_image!.first!.mimetype != MimeTypes.pdf.rawValue {
            
            let url = data!.prescription_image!.first!.image!
            
            imageViewPrescription.loadImageFromUrl(
                urlString: url,
                placeHolder: UIImage(named: "ic_prescription_placeHolder")
            )
            
        } else {
            imageViewPrescription.image = #imageLiteral(resourceName: "ic_prescription_placeHolder")
            //uiViewPrescriptionHolder.isHidden = true
        }
    }
}

extension OrderPrescriptionDetailVC: OrderUpdateDelegate {
    
    func orderUpdated(vc: UIViewController) {
        vc.navigationController?.popViewController(animated: false)
        delegate?.orderUpdated?(vc: self)
    }
    
}

extension OrderPrescriptionDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.manual_order?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManualOrderNewTblCell") as! ManualOrderNewTblCell
        
        cell.labelOrderName.text = data?.manual_order?[indexPath.row].product
        cell.labelQty.text = String(format:"%d",data!.manual_order![indexPath.row].qty!)
        
        return cell
    }
}

extension OrderPrescriptionDetailVC: RejectReasonDelegate {
    
    func rejectReasonSelected(id: Int, msg: String) {
        
        let param = [
            Parameter.orderId : data?.order_id ?? "",
            Parameter.reasonId : "\(id)"
        ]
        
        Networking.request(
            url: Urls.rejectOrder,
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
                    
                    let commonResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let cmResponse = commonResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if cmResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: cmResponse.message!)
                        
                        
                    } else {
                        AlertHelper.shared.showAlert(message: cmResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    func acceptOrder() {
        
        let param = [
            Parameter.orderId: data?.order_id ?? ""
        ]
        
        Networking.request(
            url: Urls.acceptOrder,
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
                    
                    let commonResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let cmResponse = commonResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if cmResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: cmResponse.message!, duration: .normal) { [self] in
                            
                            delegate?.orderUpdated?(vc: self)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: cmResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
        
    }
    
    func returnConfirmOrder() {
        
        let param = [
            Parameter.orderId: data?.order_id ?? ""
        ]
        
        Networking.request(
            url: Urls.confirmReturnOrder,
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
                    
                    let returnOrderResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let roResponse = returnOrderResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if roResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: roResponse.message!, duration: .normal) { [self] in
                            
                            delegate?.orderUpdated?(vc: self)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: roResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
        
    }
}

class ManualOrderNewTblCell: UITableViewCell {
    
    @IBOutlet weak var labelOrderName: UILabel!
    @IBOutlet weak var labelQty: UILabel!
        
}
