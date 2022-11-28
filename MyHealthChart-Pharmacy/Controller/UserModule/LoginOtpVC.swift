//
//  LoginOtpVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 28/09/21.
//

import UIKit

extension LoginOtpVC {
    static func instantiate() -> LoginOtpVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: LoginOtpVC.self)) as! LoginOtpVC
    }
}
class LoginOtpVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet var textFieldOtp: [UITextField]!
    
    var screenType: ScreenType = .login
    
    var mobileNumber = ""
    var forgotPwdData: ForgotPasswordDataApiResponse?
    var loginOtpData: LoginOtpModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupView()
    }
    
    private func setupView() {
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Verify OTP"
        uiViewToolBar.btnSearch.isHidden = true
        
        if AppConfig.appMode == .development {
            
            if screenType == .resetPassword &&
                forgotPwdData?.otp != nil &&
                forgotPwdData?.otp != nil {
                
                autoFillOtp(otp: forgotPwdData?.otp ?? "")
            } else {
                
                if loginOtpData != nil && !loginOtpData!.otp.isEmpty {
                    
                    autoFillOtp(otp: loginOtpData!.otp)
                }
            }
            
        }
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        for field in textFieldOtp {
            field.delegate = self
        }
        textFieldOtp[0].becomeFirstResponder()
    }
    
    private func autoFillOtp(otp: String) {
        
        if !otp.isEmpty {
            for (index, char) in otp.enumerated() {
                textFieldOtp[index].text! = "\(char)"
            }
        }
       
    }
    
    private func clearOtp() {
        for field in textFieldOtp {
            field.text = nil
        }
    }
    
    @IBAction func btnResendPressed(_ sender: UIButton) {
        
        if screenType == .resetPassword {
            resendForgotPassword()
        } else {
            resendLoginOtp()
        }
        
    }
    @IBAction func btnVerifyPressed(_ sender: HalfCornerButton) {
        
        for field in textFieldOtp {
            if field.text!.isEmpty {
                AlertHelper.shared.showToast(message: Strings.enterOtp)
                return
            }
        }
        if screenType == .login {
            verifyLoginOtp()
        } else {
            verifyForgotOtp()
        }
    }
}
extension LoginOtpVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
}

extension LoginOtpVC {
    
    private func resendLoginOtp() {
        
        guard let loginData = loginOtpData else { return }
        
        let param = [
            Parameter.mobileNo: loginData.mobileNo,
            Parameter.password: loginData.password,
            Parameter.fcmToken: loginData.fcmToken,
            Parameter.deviceType: "ios"
        ]
        
        Networking.request(
            url: Urls.loginWithOtp,
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
                    
                    let loginOtpResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: LoginOtpApiReponse.self)
                    
                    guard let loResponse = loginOtpResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if loResponse.status == StatusCode.success.rawValue {
                        
                        print(loResponse)
                        clearOtp()
                        
                        AlertHelper.shared.showToast(message: loResponse.message!, duration: .normal) { [self] in
                            
                            loginOtpData?.uuid = loResponse.data?.Uuid ?? ""
                            loginOtpData?.otp = loResponse.data?.otp ?? ""
                            
                            if AppConfig.appMode == .development && !loginOtpData!.otp.isEmpty {
                                
                                autoFillOtp(otp: loginOtpData!.otp)
                            }
                            
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: loResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
    }
    
    private func resendForgotPassword() {
        
        guard !mobileNumber.isEmpty else { return }
        
        let param = [
            Parameter.mobileNo: mobileNumber
        ]
        
        Networking.request(
            url: Urls.forgotPwd,
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
                    
                    let forgotResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: ForgotPasswordApiResponse.self)
                    
                    guard let fpResponse = forgotResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if fpResponse.status == StatusCode.success.rawValue {
                        
                        clearOtp()
                        
                        AlertHelper.shared.showToast(message: fpResponse.message!, duration: .normal) { [self] in
                            
                            forgotPwdData = fpResponse.data
                            
                            if AppConfig.appMode == .development &&
                                forgotPwdData?.otp != nil &&
                                forgotPwdData?.otp != nil {
                                
                                autoFillOtp(otp: forgotPwdData?.otp ?? "")
                            }
                            
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: fpResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getActiveModules(rs:LoginApiResponse) {
        
        let param = [
            Parameter.cityId: rs.data!.cityId!
        ] as [String : Any]
        
        Networking.requestNew(
            url: Urls.getActiveModules,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                
            case .success(let data):
                
                guard let jsonData = data else {
                    AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                    return
                }
                
                guard let rsResponse = self.convertToDictionary(text: String(data:jsonData, encoding:.utf8)!) else {
                    AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                    return
                }
                
                print(rsResponse["status"] as! Int)
                
                if rsResponse["status"] as! Int == StatusCode.success.rawValue {
                    
                    let cityArray = rsResponse["data"] as! NSArray
                    print(cityArray)
                    
                    let cityModule = cityArray[0] as! NSDictionary
                    
                    Parameter.is_pharmacy_manual_order_allow = cityModule["is_pharmacy_manual_order_allow"] as! Int == 1 ? true : false
                    Parameter.is_ledger_statement_allow = cityModule["is_ledger_statement_allow"] as! Int == 1 ? true : false
                    Parameter.deliveryTypeboth = cityModule["deliveryType"] as! String
                    Parameter.is_agreement = cityModule["is_agreement_allow"] as! Int == 1 ? true : false
                    Parameter.module_city_id = cityModule["city_id"] as! Int
                    
                    guard let userData = rs.data else { return }
                    
                    if Bool(userData.isPharmacyDetailComplete ?? "") ?? false  {
                        
                        if Bool(userData.isPharmacyApproved ?? "") ?? false {
                            
                            setUserData(userData: userData, message: rs.message ?? "")
                            
                        } else {
                            // Pharmacy not approved
                            
                            if userData.userType?.lowercased() == UserType.seller.serverString {
                                
                                setUserData(userData: userData, message: rs.message ?? "")
                                
                            } else {
                                
                                AlertHelper.shared.showAlert(
                                    title: Strings.alertTitle,
                                    message: Strings.memberShipUnderReviewMessage
                                ) { action in
                                    self.popToLoginVC()
                                }
                            }
                        }
                        
                    } else {
                        // Pharmacy detail is remains
                        navigateToPharmacyDetail(responseData: userData)
                    }
                    
                } else if rsResponse["status"] as! Int == StatusCode.notFound.rawValue {
                    present(UpdatePopup.instantiate(), animated: true, completion: nil)
                    
                } else {
                    present(UpdatePopup.instantiate(), animated: true, completion: nil)
                    //                        AlertHelper.shared.showAlert(message: rsResponse.message!)
                }
                
            case .failure(let error):
                AlertHelper.shared.showAlert(message: error.localizedDescription)
                Log.e(error.localizedDescription)
                Helper.shared.setLogout()
                
            }
        }
    }
    
    private func verifyLoginOtp() {
        
        var otp = ""
        
        for text in textFieldOtp {
            otp += text.text!
        }
        
        let param = [
            Parameter.uuid: loginOtpData?.uuid ?? "",
            Parameter.otp: otp
        ]
        
        Networking.request(
            url: Urls.verifyAndLogin,
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
                        AlertHelper.shared.showAlert(
                            message: CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let loginResponse = NetworkHelper.decodeJsonData(
                        data: jsonData, decodeWith: LoginApiResponse.self
                    )
                    
                    guard let lgResponse = loginResponse else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if lgResponse.status == StatusCode.success.rawValue {
                        
                        guard let userData = lgResponse.data else { return }
                        
                        UserDefaults.standard.set(lgResponse.data!.apiToken, forKey:UserDefaultHelper.keys.apiToken)
                        
                        Parameter.allowedDeliveryType = userData.allowedDeliveryType!
                        
                        self.getActiveModules(rs:lgResponse)
                        
                    } else {
                        AlertHelper.shared.showAlert(message: lgResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
    }
    
    private func setUserData(userData: LoginDataApiResponse, message: String) {
        
        UserDefaultHelper.shared.saveUserData(data: userData)
        
        UserDefaultHelper.shared.setUserPassword(
            password: loginOtpData?.password ?? ""
        )
        
        if userData.userType?.lowercased() == UserType.seller.serverString {
            AppConfig.userType = .seller
        } else if userData.userType?.lowercased() == UserType.pharmacy.serverString {
            AppConfig.userType = .pharmacy
        }
        
        UserDefaultHelper.shared.setAutoLogin()
        
        AlertHelper.shared.showToast(
            message: message,
            duration: .normal
        ) { [self] in
            navigateToDashboard()
        }
        
    }
    
    private func verifyForgotOtp() {
        
        var otp = ""
        
        for text in textFieldOtp {
            otp += text.text!
        }
        
        let param = [
            Parameter.uuid: forgotPwdData?.uuid ?? "",
            Parameter.mobileNoOtp: otp
        ]
        
        Networking.request(
            url: Urls.verifyForgotPwdOtp,
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
                    
                    let commonResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let cmResponse = commonResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if cmResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: cmResponse.message!, duration: .normal) { [self] in
                            navigateToResetPassword(uuid: forgotPwdData?.uuid ?? "")
                            
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
    
    private func popToLoginVC() {
        let vc = navigationController!.viewControllers.filter { $0 is LoginVC }.first!
        self.navigationController!.popToViewController(vc, animated: false)
    }
    
    func navigateToPharmacyDetail(responseData: LoginDataApiResponse) {
        let vc = PharmacyDetailsVC.instantiate()
        vc.loginResponse = responseData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToDashboard() {
        let vc = BottomTabbarVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToResetPassword(uuid: String) {
        let vc = ResetPwdVC.instantiate()
        vc.screenType = .resetPassword
        vc.uuid = uuid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LoginOtpVC : UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        guard string.rangeOfCharacter(from: Validation.mobileNoInvalidChars) == nil else { return false }
        
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            
            if textField == textFieldOtp[0] {
                textFieldOtp[1].becomeFirstResponder()
            }
            if textField == textFieldOtp[1] {
                textFieldOtp[2].becomeFirstResponder()
            }
            if textField == textFieldOtp[2] {
                textFieldOtp[3].becomeFirstResponder()
            }
            if textField == textFieldOtp[3] {
                textFieldOtp[4].becomeFirstResponder()
            }
            if textField == textFieldOtp[4] {
                textFieldOtp[5].becomeFirstResponder()
            }
            if textField == textFieldOtp[5] {
                textFieldOtp[5].resignFirstResponder()
            }
            
            textField.text = string
            return false
            
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            
            
            if textField == textFieldOtp[5] {
                textFieldOtp[4].becomeFirstResponder()
            }
            if textField == textFieldOtp[4] {
                textFieldOtp[3].becomeFirstResponder()
            }
            if textField == textFieldOtp[3] {
                textFieldOtp[2].becomeFirstResponder()
            }
            if textField == textFieldOtp[2] {
                textFieldOtp[1].becomeFirstResponder()
            }
            if textField == textFieldOtp[1] {
                textFieldOtp[0].becomeFirstResponder()
            }
            if textField == textFieldOtp[0] {
                textFieldOtp[0].resignFirstResponder()
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

