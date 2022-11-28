//
//  ResetPwdVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 01/10/21.
//

import UIKit

extension ResetPwdVC {
    static func instantiate() -> ResetPwdVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: ResetPwdVC.self)) as! ResetPwdVC
    }
}

class ResetPwdVC: UIViewController {
    
    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var uiViewCurrentPassword: UIView!
    
    @IBOutlet weak var textFieldNewPwd: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldConfirmPwd: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldCurrentPwd: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnEyeCurrent: UIButton!
    @IBOutlet weak var btnEyeNew: UIButton!
    @IBOutlet weak var btnEyeConf: UIButton!
    
    @IBOutlet weak var btnUpdate: HalfCornerButton!
    
    private var isCurrentPwdHidden = true
    private var isNewPwdHidden = true
    private var isConfPwdHidden = true
    
    var screenType: ScreenType = .resetPassword
    var uuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        if screenType == .resetPassword {
            uiViewToolBar.labelTitle.text = "Set Password"
            uiViewCurrentPassword.isHidden = true
        } else {
            uiViewToolBar.labelTitle.text = "Change Password"
            uiViewCurrentPassword.isHidden = false
        }
        uiViewToolBar.btnSearch.isHidden = true
        setupDelegates()
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        textFieldCurrentPwd.delegate = self
        textFieldNewPwd.delegate = self
        textFieldConfirmPwd.delegate = self
    }
    
    
    @IBAction func btnEyePressed(_ sender: UIButton) {
        
        Log.m("btn eye pressed")
        
        if sender == btnEyeCurrent {
            isCurrentPwdHidden = !isCurrentPwdHidden
            textFieldCurrentPwd.isSecureTextEntry = isCurrentPwdHidden
            sender.setImage(
                isCurrentPwdHidden ? #imageLiteral(resourceName: "ic_eye_grey") : #imageLiteral(resourceName: "ic_eye_blue") ,
                for: .normal
            )
        } else if sender == btnEyeNew {
            isNewPwdHidden = !isNewPwdHidden
            textFieldNewPwd.isSecureTextEntry = isNewPwdHidden
            sender.setImage(
                isNewPwdHidden ? #imageLiteral(resourceName: "ic_eye_grey") : #imageLiteral(resourceName: "ic_eye_blue") ,
                for: .normal
            )
        } else {
            isConfPwdHidden = !isConfPwdHidden
            textFieldConfirmPwd.isSecureTextEntry = isConfPwdHidden
            sender.setImage(
                isConfPwdHidden ? #imageLiteral(resourceName: "ic_eye_grey") : #imageLiteral(resourceName: "ic_eye_blue") ,
                for: .normal
            )
        }
    }
    
    @IBAction func btnUpdatePressed(_ sender: HalfCornerButton) {
        validateForm()
    }
    
    
    
}

extension ResetPwdVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return Validation.shouldAllowTyping(textField, range: range, string: string, maxRange: Validation.maxPwdLength)
    }
    
}

private extension ResetPwdVC {
    
    func validateForm() {
        
        var isValidCurrentPwd = false
        var isValidNewPwd = false
        var isValidConfPwd = false
        
        if screenType == .changePassword {
            if textFieldCurrentPwd.text!.isEmpty {
                textFieldCurrentPwd.errorMessage = Strings.emptyPasswordError
            } else if textFieldCurrentPwd.text!.count < Validation.minPwdLength {
                textFieldCurrentPwd.errorMessage = Strings.inValidPasswordError(length: Validation.minPwdLength)
            } else {
                isValidCurrentPwd = true
                textFieldCurrentPwd.errorMessage = nil
            }
        }
        
        if textFieldNewPwd.text!.isEmpty {
            textFieldNewPwd.errorMessage = Strings.emptyPasswordError
        } else if textFieldNewPwd.text!.count < Validation.minPwdLength {
            textFieldNewPwd.errorMessage = Strings.inValidPasswordError(length: Validation.minPwdLength)
        } else {
            isValidNewPwd = true
            textFieldNewPwd.errorMessage = nil
        }
        
        if textFieldConfirmPwd.text!.isEmpty {
            textFieldConfirmPwd.errorMessage = Strings.emptyPasswordError
        } else if textFieldConfirmPwd.text! != textFieldNewPwd.text! {
            textFieldConfirmPwd.errorMessage = Strings.inValidConfirmPasswordError
        } else {
            isValidConfPwd = true
            textFieldConfirmPwd.errorMessage = nil
        }
        
        if isValidNewPwd && isValidConfPwd {
            
            if screenType == .changePassword && !isValidCurrentPwd {
                return
            }
            // Call api
            
            if screenType == .resetPassword {
                resetPwd()
            } else {
                changePwd()
            }
            
            Log.m("Reset Called")
        }
        
    }
    
    private func navigateToLogin() {
        if screenType == .changePassword {
            btnBackPressed()
            return
        }
        let vc = navigationController!.viewControllers.filter { $0 is LoginVC }.first!
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
}

extension ResetPwdVC {
    
    func resetPwd() {
        
        let param = [
            Parameter.uuid: uuid,
            Parameter.password: textFieldNewPwd.text!
        ]
        
        Networking.request(
            url: Urls.resetPwd,
            method: .post,
            headers: nil,
            defaultHeader: false,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false) { response in
            
            switch response {
                
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let loginResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: LoginApiResponse.self)
                    
                    guard let lgResponse = loginResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if lgResponse.status == StatusCode.success.rawValue {
                        
                        guard let userData = lgResponse.data else { return }
                        
                        Parameter.allowedDeliveryType = userData.allowedDeliveryType!
                        
                        if Bool(userData.isPharmacyDetailComplete ?? "") ?? false  {
                            
                            if Bool(userData.isPharmacyApproved ?? "") ?? false {
                                
                                UserDefaultHelper.shared.saveUserData(data: userData)
                                
                                UserDefaultHelper.shared.setUserPassword(
                                    password: self.textFieldNewPwd.text!
                                )
                                
                                if userData.userType == UserType.seller.serverString {
                                    AppConfig.userType = .seller
                                } else if userData.userType == UserType.pharmacy.serverString {
                                    AppConfig.userType = .pharmacy
                                }
                                
                                UserDefaultHelper.shared.setAutoLogin()
                                
                                AlertHelper.shared.showToast(
                                    message: lgResponse.message!,
                                    duration: .normal
                                ) { self.navigateToDashboard() }
                                
                            } else {
                                // Pharmacy not approved
                                
                                AlertHelper.shared.showAlert(
                                    title: Strings.alertTitle,
                                    message: Strings.memberShipUnderReviewMessage
                                ) { action in
                                    self.popToLoginVC()
                                }
                            }
                            
                        } else {
                            // Pharmacy detail is remains
                            self.navigateToPharmacyDetail(responseData: userData)
                        }
                        
                    } else {
                        
                        AlertHelper.shared.showAlert(message: lgResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
                    
            }
        }
    }
    
    func changePwd() {
        
        let param = [
            Parameter.currentPassword: textFieldCurrentPwd.text!,
            Parameter.newPassword: textFieldNewPwd.text!,
        ]
        
        Networking.request(
            url: Urls.changePwd,
            method: .post,
            headers: nil,
            defaultHeader: true,
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
                    
                    let cpResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let rpResponse = cpResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    if rpResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: rpResponse.message!, duration: .normal) { [self] in
                            UserDefaultHelper.shared.setUserPassword(password: textFieldNewPwd.text!)
                            btnBackPressed()
                        }
                        
                    } else {
                        
                        AlertHelper.shared.showAlert(message: rpResponse.message!)
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
    
}

extension ResetPwdVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
}

