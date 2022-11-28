//
//  CreateOrderVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Mac Mini on 06/04/22.
//

import UIKit

extension CreateOrderVC {
    static func instantiate() -> CreateOrderVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: CreateOrderVC.self)) as! CreateOrderVC
    }
}

class CreateOrderVC: UIViewController {

    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var imgParcelImage: UIImageView!
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobileNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtAmount: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOpenCamera(_ sender: Any) {
        MediaPicker.shared.chooseOptionForMediaType(delegate: self)

    }
    
    @IBAction func btnCreateOrder(_ sender: Any) {
        createOrder()
    }
}

extension CreateOrderVC {
    
    private func validateForm() {
        
            if txtName.text!.isEmpty {
                txtName.errorMessage = Strings.emptyShopCloseTime
            } else {
                txtName.errorMessage = nil
            }
            
        }
        
    private func createOrder() {

        let param = [
            Parameter.orderAmount : txtAmount.text ?? "",
            Parameter.address: txtAddress.text ?? "",
            Parameter.mobileNumber: txtMobileNumber.text ?? "",
            Parameter.name : txtName.text ?? ""]
        
        var pharmacyLogo: FileData?
        
        if let image = imgParcelImage.image {
            pharmacyLogo = FileData(
                data: image.jpegData(compressionQuality: 0.7)!,
                mimeType: .jpeg,
                key: Parameter.parcelImages
            )
        }
        
        Networking.request(
            url: Urls.manualDeliveryOrderCreate,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: pharmacyLogo == nil ? nil : [pharmacyLogo!],
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
                            message: cmResponse.message!,
                            duration: .normal
                        ) { [self] in
                            
                            let vc = DeliveryorderVC.instantiate()
                            self.navigationController?.pushViewController(vc, animated: true)
//                            delegate?.profileUpdated()
//                            btnBackPressed()
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
    

extension CreateOrderVC: MediaPickerDelegate {
    
    func mediaPicked(media: MediaData) {
        imgParcelImage.image = media.image
    }
    
}
