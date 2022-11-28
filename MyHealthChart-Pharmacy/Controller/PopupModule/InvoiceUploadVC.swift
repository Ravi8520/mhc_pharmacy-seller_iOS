//
//  InvoiceUploadVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 04/10/21.
//

import UIKit

extension InvoiceUploadVC {
    static func instantiate() -> InvoiceUploadVC {
        StoryBoardConstants.popup.instantiateViewController(withIdentifier: String(describing: InvoiceUploadVC.self)) as! InvoiceUploadVC
    }
}

class InvoiceUploadVC: UIViewController {
    
    @IBOutlet weak var textFieldAmount: SkyFloatingLabelTextField!
    @IBOutlet weak var collectionViewInvoice: UICollectionView!
    
    @IBOutlet weak var labelDeliveryBoyName: UILabel!
    @IBOutlet weak var uiViewUnderLine: UIView!
    
    @IBOutlet weak var uiViewPopup: UIView!
    @IBOutlet var uiViewAssignTo: UIView!
    
    @IBOutlet var uiViewBorder: UIView!
    
    @IBOutlet var stackViewUploadPrescription: UIStackView!
    
    @IBOutlet var btnDeliveryType: [UIButton]!
    
    @IBOutlet var btnInternal: UIButton!
    @IBOutlet var btnLogstic: UIButton!
    
    var delegate: OrderUpdateDelegate?
    
    private var deliveryBoyDropDown = DropDown()
    
    private var imageArray: [MediaData] = []
    private var deliveryBoyDataSource: [ActiveDeliveryBoyDataApiReponse] = []
    
    private var selectedDeliveryType = 0
    private var selectedDeliveryBoyId = ""
    var orderId = ""
    var userType = ""
    
    var screenType: ScreenType = .assignOrder
    
    var invoiceData: ((String, [FileData])->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
                
        if Parameter.deliveryTypeboth.lowercased() == "both" {
            
            //let deliveryType = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.allowedDeliveryType) as? String
            
            let deliveryType = Parameter.allowedDeliveryType.lowercased()
            
            //if let type = deliveryType {
                
                switch deliveryType {
                    
                case DeliveryType.internald.serverString:
                    getDeliveryBoyList()
                    btnDeliveryType[1].isHidden = true
                    btnDeliveryTypePressed(btnDeliveryType[0])
                case DeliveryType.external.serverString:
                    btnDeliveryType[0].isHidden = true
                    btnDeliveryTypePressed(btnDeliveryType[1])
                case DeliveryType.both.serverString:
                    getDeliveryBoyList()
                    break
                default:
                    break
                }
            //}
            
            /*if userType.lowercased() == "corporate" {
                btnDeliveryType[0].isHidden = true
                btnDeliveryType[1].isHidden = false
                btnDeliveryTypePressed(btnDeliveryType[1])
            }
            else {
                btnDeliveryType[0].isHidden = false
                btnDeliveryType[1].isHidden = false
                btnDeliveryTypePressed(btnDeliveryType[0])
            }*/
        }
        else {
            
            if userType.lowercased() == "corporate" {
                //btnDeliveryType[0].isHidden = true
                //btnDeliveryType[1].isHidden = false
                //btnDeliveryTypePressed(btnDeliveryType[1])
                
                if Parameter.deliveryTypeboth.lowercased() == "logistic" {
                    btnDeliveryType[0].isHidden = true
                    btnDeliveryType[1].isHidden = false
                    btnDeliveryTypePressed(btnDeliveryType[1])
                }
            }
            else {
                                
                if Parameter.deliveryTypeboth.lowercased() == "internal" {
                    getDeliveryBoyList()
                    btnDeliveryType[1].isHidden = true
                    btnDeliveryTypePressed(btnDeliveryType[0])
                }
                else {
                    btnDeliveryType[0].isHidden = true
                    btnDeliveryTypePressed(btnDeliveryType[1])
                }
            }
        }
        
        if screenType == .reassignOrder {
            stackViewUploadPrescription.isHidden = true
            textFieldAmount.isHidden = true
        }
        
        uiViewBorder.addLineDashedStroke(pattern: [2,2], radius: 8, color: .appColor.fontColor)
        uiViewPopup.setCornerRadius(radius: 16)
        textFieldAmount.delegate = self
        setupDropDown()
        
    }
    
    private func setupDropDown() {
        deliveryBoyDropDown.anchorView = uiViewUnderLine
        deliveryBoyDropDown.backgroundColor = .white
        deliveryBoyDropDown.cornerRadius = 4
        deliveryBoyDropDown.bottomOffset = CGPoint(
            x: 0,
            y:(deliveryBoyDropDown.anchorView?.plainView.bounds.height)!
        )
        deliveryBoyDropDown.topOffset = CGPoint(
            x: 0,
            y:-(deliveryBoyDropDown.anchorView?.plainView.bounds.height)!
        )
        
        deliveryBoyDropDown.selectionAction = { [self] (index, title) in
            labelDeliveryBoyName.text = title
            selectedDeliveryBoyId = deliveryBoyDataSource[index].id!
        }
    }
    
    @IBAction func btnDropDownPressed(_ sender: UIButton) {
        
        if !deliveryBoyDataSource.isEmpty {
            deliveryBoyDropDown.dataSource = deliveryBoyDataSource.map({ deliveryBoy in return deliveryBoy.deliveryBoyname ?? "" })
            deliveryBoyDropDown.show()
        }
        
    }
    
    
    @IBAction func btnUploadInvoicePressed(_ sender: UIButton) {
        MediaPicker.shared.chooseOptionForMediaType(delegate: self, isAllowedPdf: false)
    }
    
    @IBAction func btnDeliveryTypePressed(_ sender: UIButton) {
        
        selectedDeliveryType = sender.tag
        
        for btn in btnDeliveryType {
            if btn.tag == selectedDeliveryType {
                btn.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btn.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        if selectedDeliveryType == 0 {
            uiViewAssignTo.isHidden = false
        } else {
            uiViewAssignTo.isHidden = true
        }
    }
    
    
    @IBAction func btnAssignPressed(_ sender: AppThemeButton) {
        if validateForm() {
            if screenType == .assignOrder {
                assignOrder()
            } else {
                reassignOrder()
            }
        }
    }
    
    
    @IBAction func btnCancelPressed(_ sender: BorderButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
}

extension InvoiceUploadVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty && string == "." {
            return false
        }
        
        if textField.text!.contains(".") && string == "." {
            return false
        }
        
        return Validation.shouldAllowTyping(
            textField,
            range: range,
            string: string,
            maxRange: Validation.maxMobileNoLength
        ) &&
        (
            string.rangeOfCharacter(
                from: Validation.invalidAmountValue
            ) == nil)
        
    }
    
}

extension InvoiceUploadVC {
    
    private func validateForm() -> Bool {
        
        var isValidDeliveryBoy = false
        var isValidAmount = false
        var isValidInvoice = false
        
        if selectedDeliveryType == 0 {
            
            if labelDeliveryBoyName.text!.isEmpty || selectedDeliveryBoyId.isEmpty {
                AlertHelper.shared.showToast(message: "Please select delivery boy")
            } else {
                isValidDeliveryBoy = true
            }
            
        } else {
            isValidDeliveryBoy = true
        }
        
        if screenType == .assignOrder {
            
            if textFieldAmount.text!.isEmpty {
                textFieldAmount.errorMessage = "Please enter amount"
            } else if Double(textFieldAmount.text!.trimmingCharacters(in: .whitespaces))! < 1 {
                textFieldAmount.errorMessage = "Please enter valid amount"
            } else {
                isValidAmount = true
                textFieldAmount.errorMessage = nil
            }
            
            if imageArray.isEmpty {
                AlertHelper.shared.showToast(message: "Please upload invoice image")
            } else {
                isValidInvoice = true
            }
            
        } else {
            isValidAmount = true
            isValidInvoice = true
        }
        
        return isValidAmount && isValidInvoice && isValidDeliveryBoy
    }
    
}

extension InvoiceUploadVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: InvoiceImageCollCell.self),
            for: indexPath
        ) as! InvoiceImageCollCell
        
        cell.imageViewInvoice.image = imageArray[indexPath.row].image
        
        cell.btnCancelHandler = { [self] in
            imageArray.remove(at: indexPath.row)
            collectionView.reloadData()
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let img = imageArray[indexPath.row].image {
            let vc = FullScreenVC.instantiate()
            vc.image = img
            present(vc, animated: true, completion: nil)
        }
        
    }
    
}

extension InvoiceUploadVC: MediaPickerDelegate {
    
    func mediaPicked(media: MediaData) {
        imageArray.append(media)
        collectionViewInvoice.reloadData()
    }
    
}

extension InvoiceUploadVC {
    
    private func getDeliveryBoyList() {
        
        Networking.request(
            url: Urls.activeDeliveryBoyList,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: nil,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
        
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let deliveryBoyResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: ActiveDeliveryBoyApiReponse.self)
                    
                    guard let dbResponse = deliveryBoyResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if dbResponse.status == StatusCode.success.rawValue {
                        
                        deliveryBoyDataSource.removeAll()
                        deliveryBoyDataSource = dbResponse.data ?? []
                        
                    } else {
                        AlertHelper.shared.showAlert(message: dbResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func assignOrder() {
    
        let param = [
            Parameter.orderId: orderId,
            Parameter.deliveryBoyId: selectedDeliveryType == 0 ?
            selectedDeliveryBoyId : "",
            Parameter.amount: textFieldAmount.text ?? "0"
        ]
        
        var invoiceData: [FileData] = []
        
        if !imageArray.isEmpty {
            invoiceData.append(
                contentsOf: imageArray.map({ image in
                    return FileData(
                        data: image.image!.jpegData(compressionQuality: 0.7)!,
                        mimeType: image.fileType,
                        key: Parameter.invoice
                    )
                })
            )
        }
        
        Networking.request(
            url: Urls.assignOrder,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: invoiceData,
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
                        
                        AlertHelper.shared.showToast(
                            message: cmResponse.message!, duration: .normal
                        ) {
                            
                            self.delegate?.orderUpdated?(vc: self)
                            
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
    
    private func reassignOrder() {
        
        let param = [
            Parameter.orderId: orderId,
            Parameter.deliveryBoyId: selectedDeliveryType == 0 ?
            selectedDeliveryBoyId : "",
        ]
        
        Networking.request(
            url: Urls.reassignOrder,
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
                        
                        AlertHelper.shared.showToast(
                            message: cmResponse.message!, duration: .normal
                        ) {
                            
                            self.delegate?.orderUpdated?(vc: self)
                            
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
    
}

class InvoiceImageCollCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewInvoice: UIImageView!
    
    var btnCancelHandler: (()->Void)?
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        btnCancelHandler?()
    }
    
}

