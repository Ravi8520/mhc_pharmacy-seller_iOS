//
//  CreateAccOtpVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 30/09/21.
//

import UIKit

extension CreateAccOtpVC {
    static func instantiate() -> CreateAccOtpVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: CreateAccOtpVC.self)) as! CreateAccOtpVC
    }
}

class CreateAccOtpVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var labelEmailInfo: UILabel!
    @IBOutlet weak var labelMobileInfo: UILabel!
    
    
    @IBOutlet var textfieldEmailOtp: [UITextField]!
    @IBOutlet var textfieldMobileNoOtp: [UITextField]!

    var registrationData: RegisterationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setUpScreen()
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Verify OTP"
        uiViewToolBar.btnSearch.isHidden = true
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        for field in textfieldEmailOtp {
            field.delegate = self
        }
        for field in textfieldMobileNoOtp {
            field.delegate = self
        }
        textfieldEmailOtp[0].becomeFirstResponder()
    }
    
    private func setUpScreen() {
        
        if let data = registrationData {
            
            labelEmailInfo.text = "Enter the verification code we\nsent you on your Email \(data.email)"
            labelMobileInfo.text = "Enter the verification code we\nsent you on your Mobile No \(data.pharmacyOwnerMobileNumber!)"
            
            if AppConfig.appMode == .development && data.mobileOtp != nil && data.emailOtp != nil {
                autoFillOtp(emailOtp: data.emailOtp!, mobileOtp: data.mobileOtp!)
            }
        }
        
    }
    
    private func autoFillOtp(emailOtp: String, mobileOtp: String) {
        
        if !emailOtp.isEmpty {
            for (index, char) in emailOtp.enumerated() {
                textfieldEmailOtp[index].text! = "\(char)"
            }
        }
        
        if !mobileOtp.isEmpty {
            for (index, char) in mobileOtp.enumerated() {
                textfieldMobileNoOtp[index].text! = "\(char)"
            }
        }
        
    }
    
    private func clearEmailOtp() {
        for field in textfieldEmailOtp {
            field.text = nil
        }
    }
    
    private func clearMobileOtp() {
        for field in textfieldMobileNoOtp {
            field.text = nil
        }
    }
    
    private func clearOtp() {
        clearEmailOtp()
        clearMobileOtp()
    }
    
    @IBAction func btnResendEmailOtpPressed(_ sender: UIButton) {
        resendEmailOtp()
    }
    
    @IBAction func btnResendMobileOtpPressed(_ sender: UIButton) {
        resendMobileOtp()
    }
    
    @IBAction func btnVerifyPressed(_ sender: HalfCornerButton) {
        validateForm()
//        navigateToPharmacyDetail()
    }
    
    

}

extension CreateAccOtpVC: ToolBarDelegate {
    
    func validateForm() {
        
        var isValidEmailOtp = true
        var isValidMobileOtp = true
        
        for textfield in textfieldEmailOtp {
            if textfield.text!.isEmpty {
                isValidEmailOtp = false
                break
            }
        }
        
        if !isValidEmailOtp {
            AlertHelper.shared.showToast(message: Strings.enterEmailOtp)
            return
        }
        
        for textfield in textfieldMobileNoOtp {
            if textfield.text!.isEmpty {
                isValidMobileOtp = false
                break
            }
        }
        
        if !isValidMobileOtp {
            AlertHelper.shared.showToast(message: Strings.enterMobileOtp)
            return
        }
        
        verifyOtp()
        
    }
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    func resendMobileOtp() {
        
        let param = [
            Parameter.email: "",
            Parameter.mobileNo: registrationData!.pharmacyOwnerMobileNumber!
        ]
        
        Networking.request(
            url: Urls.registerOtp,
            method: .post,
            headers: nil,
            defaultHeader: false,
            param: param,
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
                    let registerResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: RegisterWithOtpResponse.self)
                    
                    guard let rsResponse = registerResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if rsResponse.status == StatusCode.success.rawValue {
                        
                        clearMobileOtp()
                        
                        AlertHelper.shared.showToast(message: rsResponse.message!, duration: .normal) { [self] in
                            if AppConfig.appMode == .development {
                                autoFillOtp(emailOtp: "", mobileOtp: rsResponse.data!.mobileOtp ?? "")
                            }
                        }
    
                    } else {
                        AlertHelper.shared.showAlert(message: rsResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    func resendEmailOtp() {
        
        let param = [
            Parameter.email: registrationData!.email,
            Parameter.mobileNo: ""
        ]
        
        Networking.request(
            url: Urls.registerOtp,
            method: .post,
            headers: nil,
            defaultHeader: false,
            param: param,
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
                    
                    let registerResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: RegisterWithOtpResponse.self)
                    
                    guard let rsResponse = registerResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if rsResponse.status == StatusCode.success.rawValue {
                        
                        clearEmailOtp()
                        
                        AlertHelper.shared.showToast(message: rsResponse.message!, duration: .normal) { [self] in
                            if AppConfig.appMode == .development {
                                autoFillOtp(emailOtp: rsResponse.data!.emailOtp ?? "", mobileOtp: "")
                            }
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: rsResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    func verifyOtp() {
        
        guard let data = registrationData else { return }
        
        var emailOtp = ""
        var mobileOtp = ""
        
        for text in textfieldEmailOtp {
            emailOtp += text.text!
        }
        
        for text in textfieldMobileNoOtp {
            mobileOtp += text.text!
        }
        
        let param = [
            Parameter.uuid: data.uuid,
            Parameter.emailOtp: emailOtp,
            Parameter.mobileNoOtp: mobileOtp,
            Parameter.firmType: data.firmType,
            Parameter.fullName: data.fullName,
            Parameter.partnerName: data.partnerName,
            Parameter.email: data.email,
            Parameter.mobileNo: data.pharmacyOwnerMobileNumber!,
            Parameter.serviceMobileNo: data.pharmacyServiceMobileNumber ?? "",
            Parameter.managerMobileNo: data.pharmacyManagerMobileNumber ?? "",
            Parameter.drugLicenceNo: data.drugLicenceNumber,
            Parameter.validUptoyear: data.validUpToYear,
            Parameter.password: data.password
        ] as [String : Any]
        
        var partnerShipDeed: [FileData]? = []
        var drugLicence: [FileData] = []
        var adharCardFront: FileData?
        var adharCardBack: FileData?
        var panCard: FileData?
        var ownerPhoto: FileData?
        
        if let partnerSheepDeed = data.partnerShipDeed {
            partnerShipDeed?.append(
                contentsOf: partnerSheepDeed.map({ file in
                    
                    if let img = file.image {
                        return FileData(
                            data: img.jpegData(compressionQuality: 0.7)!,
                            mimeType: file.fileType,
                            key: Parameter.partnerShipDeed
                        )
                    } else {
                        return FileData(
                            data: file.pdfData!,
                            mimeType: file.fileType,
                            key: Parameter.partnerShipDeed
                        )
                    }
            }))
        }
        
        if !data.drugLicence.isEmpty {
            drugLicence.append(contentsOf: data.drugLicence.map({ file in
                
                if let img = file.image {
                    return FileData(
                        data: img.jpegData(compressionQuality: 0.7)!,
                        mimeType: file.fileType,
                        key: Parameter.drugLicence
                    )
                } else {
                    return FileData(
                        data: file.pdfData!,
                        mimeType: file.fileType,
                        key: Parameter.drugLicence
                    )
                }
            }))
        }
        
        if let img = data.adharCardFrontSide.image {
            
            adharCardFront = FileData(
                data: img.jpegData(compressionQuality: 0.7)!,
                mimeType: data.adharCardFrontSide.fileType,
                key: Parameter.adharCardfront
            )
            
        } else {
            
            adharCardFront = FileData(
                data: data.adharCardFrontSide.pdfData!,
                mimeType: data.adharCardFrontSide.fileType,
                key: Parameter.adharCardfront
            )
            
        }
        
        if let backAdharData = data.adharCardBackSide {
            
            adharCardBack = FileData(
                data: backAdharData.image!.jpegData(compressionQuality: 0.7)!,
                mimeType: backAdharData.fileType,
                key: Parameter.adharCardback
            )
        }
        
        if let img = data.panCard.image {
            
            panCard = FileData(
                data: img.jpegData(compressionQuality: 0.7)!,
                mimeType: data.panCard.fileType,
                key: Parameter.panCard
            )
            
            
        } else {
            
            panCard = FileData(
                data: data.panCard.pdfData!,
                mimeType: data.panCard.fileType,
                key: Parameter.panCard
            )
        }
        
        if let img = data.ownerPhoto.image {
            
            ownerPhoto = FileData(
                data: img.jpegData(compressionQuality: 0.7)!,
                mimeType: data.ownerPhoto.fileType,
                key: Parameter.ownerPhoto
            )
        }
            
        Networking.makeNetworkRequestForCreateAccount(
            url: Urls.verifyRegister,
            method: .post,
            headers: nil,
            defaultHeader: false,
            param: param,
            partnerShipDeed: partnerShipDeed,
            drugLicence: drugLicence,
            adharCardFront: adharCardFront!,
            adharCardBack: adharCardBack,
            panCard: panCard!,
            ownerPhoto: ownerPhoto!,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
        
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let registerResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: LoginApiResponse.self)
                    
                    guard let rsResponse = registerResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if rsResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: rsResponse.message!, duration: .normal) { [self] in
                            if let resData = rsResponse.data {
                                navigateToPharmacyDetail(responseData: resData)
                            }
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: rsResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    func navigateToPharmacyDetail(responseData: LoginDataApiResponse) {
        let vc = PharmacyDetailsVC.instantiate()
        vc.loginResponse = responseData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToPharmacyDetail() {
        let vc = PharmacyDetailsVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CreateAccOtpVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard string.rangeOfCharacter(from: Validation.mobileNoInvalidChars) == nil else { return false }
        
        for textfield in textfieldEmailOtp {
            if textfield == textField {
                return otpFunctionalityForEmail(textfield, shouldChangeCharactersIn: range, replacementString: string)
            }
        }
        
        for textfield in textfieldMobileNoOtp {
            if textfield == textField {
                return otpFunctionalityForMobileNo(textfield, shouldChangeCharactersIn: range, replacementString: string)
            }
        }
        
        return true
    }
    
    private func otpFunctionalityForEmail(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            
            if textField == textfieldEmailOtp[0] {
                textfieldEmailOtp[1].becomeFirstResponder()
            }
            if textField == textfieldEmailOtp[1] {
                textfieldEmailOtp[2].becomeFirstResponder()
            }
            if textField == textfieldEmailOtp[2] {
                textfieldEmailOtp[3].becomeFirstResponder()
            }
            if textField == textfieldEmailOtp[3] {
                textfieldEmailOtp[4].becomeFirstResponder()
            }
            if textField == textfieldEmailOtp[4] {
                textfieldEmailOtp[5].becomeFirstResponder()
            }
            if textField == textfieldEmailOtp[5] {
                textfieldEmailOtp[5].resignFirstResponder()
            }
            
            textField.text = string
            return false
            
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            
            
            if textField == textfieldEmailOtp[5] {
                textfieldEmailOtp[4].becomeFirstResponder()
            }
            if textField == textfieldEmailOtp[4] {
                textfieldEmailOtp[3].becomeFirstResponder()
            }
            if textField == textfieldEmailOtp[3] {
                textfieldEmailOtp[2].becomeFirstResponder()
            }
            if textField == textfieldEmailOtp[2] {
                textfieldEmailOtp[1].becomeFirstResponder()
            }
            if textField == textfieldEmailOtp[1] {
                textfieldEmailOtp[0].becomeFirstResponder()
            }
            if textField == textfieldEmailOtp[0] {
                textfieldEmailOtp[0].resignFirstResponder()
            }
            
            textField.text = ""
            return false
            
        } else if (textField.text?.count)! >= 1 {
            
            textField.text = string
            return false
        }
        
        return true
    }
    
    private func otpFunctionalityForMobileNo(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            
            if textField == textfieldMobileNoOtp[0] {
                textfieldMobileNoOtp[1].becomeFirstResponder()
            }
            if textField == textfieldMobileNoOtp[1] {
                textfieldMobileNoOtp[2].becomeFirstResponder()
            }
            if textField == textfieldMobileNoOtp[2] {
                textfieldMobileNoOtp[3].becomeFirstResponder()
            }
            if textField == textfieldMobileNoOtp[3] {
                textfieldMobileNoOtp[4].becomeFirstResponder()
            }
            if textField == textfieldMobileNoOtp[4] {
                textfieldMobileNoOtp[5].becomeFirstResponder()
            }
            if textField == textfieldMobileNoOtp[5] {
                textfieldMobileNoOtp[5].resignFirstResponder()
            }
            
            textField.text = string
            return false
            
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            
            
            if textField == textfieldMobileNoOtp[5] {
                textfieldMobileNoOtp[4].becomeFirstResponder()
            }
            if textField == textfieldMobileNoOtp[4] {
                textfieldMobileNoOtp[3].becomeFirstResponder()
            }
            if textField == textfieldMobileNoOtp[3] {
                textfieldMobileNoOtp[2].becomeFirstResponder()
            }
            if textField == textfieldMobileNoOtp[2] {
                textfieldMobileNoOtp[1].becomeFirstResponder()
            }
            if textField == textfieldMobileNoOtp[1] {
                textfieldMobileNoOtp[0].becomeFirstResponder()
            }
            if textField == textfieldMobileNoOtp[0] {
                textfieldMobileNoOtp[0].resignFirstResponder()
            }
            
            textField.text = ""
            return false
            
        } else if (textField.text?.count)! >= 1 {
            
            textField.text = string
            return false
        }
        
        return true
    }
    
}
