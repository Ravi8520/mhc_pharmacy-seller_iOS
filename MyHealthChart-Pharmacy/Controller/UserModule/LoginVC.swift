//
//  ViewController.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 28/09/21.
//

import UIKit

extension LoginVC {
    static func instantiate() -> LoginVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as! LoginVC
    }
}

class LoginVC: UIViewController {

    @IBOutlet var uiViewLoginCardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldMobileNo: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    @IBOutlet weak var btnCreateNewAcc: UIButton!
    
    private var isPwdHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setUpViews() {
        setupDelegates()
        btnCreateAccount.titleLabel?.numberOfLines = 2
        uiViewLoginCardHeight.constant = AppConfig.screenHight / 1.9
    }
    
    private func setupDelegates() {
        textFieldMobileNo.delegate = self
        textFieldPassword.delegate = self
    }
    
    @IBAction func btnEyePressed(_ sender: UIButton) {
        Log.m("btn eye pressed")
        isPwdHidden.toggle()
        textFieldPassword.isSecureTextEntry = isPwdHidden
        btnEye.setImage(
            isPwdHidden ? #imageLiteral(resourceName: "ic_eye_grey") : #imageLiteral(resourceName: "ic_eye_blue") ,
            for: .normal
        )
    }
    
    @IBAction func btnForgotPwdPressed(_ sender: UIButton) {
        Log.m("Forgot pwd pressed")
        navigateToForgotPwd()
    }
    
    @IBAction func btnLoginPressed(_ sender: AppThemeButton) {
        Log.m("Login pressed")
        validateForm()
        //navigateToVerifyOtp()
    }

    @IBAction func btnCreateAccountPressed(_ sender: UIButton) {
        Log.m("Create Acc pressed")
        self.navigationController?.pushViewController(CreateAccountVC.instantiate(), animated: true)
    }
}

extension LoginVC: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        if textField == textFieldMobileNo {
            
            return Validation.shouldAllowTyping(
                textField,
                range: range,
                string: string,
                maxRange: Validation.maxMobileNoLength
            ) &&
            (
                string.rangeOfCharacter(
                    from: Validation.mobileNoInvalidChars
                ) == nil
            )
            
        } else if textField == textFieldPassword {
            
            return Validation.shouldAllowTyping(
                textField,
                range: range,
                string: string,
                maxRange: Validation.maxPwdLength
            )
        }
        
        return true
    }
    
}

private extension LoginVC {
    
    func validateForm() {
        
        var isValidMobile = false
        var isValidPwd = false
        
        if textFieldMobileNo.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            textFieldMobileNo.errorMessage = Strings.emptyPhoneError
        } else if textFieldMobileNo.text!.count < Validation.maxMobileNoLength {
            textFieldMobileNo.errorMessage = Strings.invalidMobileNoError
        } else {
            isValidMobile = true
            textFieldMobileNo.errorMessage = nil
        }
        
        if textFieldPassword.text!.isEmpty {
            textFieldPassword.errorMessage = Strings.emptyPasswordError
        } else if textFieldPassword.text!.count < Validation.minPwdLength {
            textFieldPassword.errorMessage = Strings.inValidPasswordError(length: Validation.minPwdLength)
        } else {
            isValidPwd = true
            textFieldPassword.errorMessage = nil
        }
        
        if isValidMobile && isValidPwd {
            Log.m("File: \(#file)\nMethod: \(#function)\nline: \(#line)-> Login Called")
            login()
            //checkForUpdate()
            //navigateToVerifyOtp()
        }
    }
    
    func getActiveModules(cityId:Int,rs:LoginOtpApiReponse) {
        
        let param = [
            Parameter.cityId: cityId
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
                    
                    AlertHelper.shared.showToast(message: rs.message!, duration: .normal) { [self] in
                                  
                        if Parameter.is_agreement {
                            if rs.data?.isAccept == 1 && rs.data?.isAgreementNew == 1 {
                                navigateToVerifyOtp(
                                    loginData: LoginOtpModel(
                                        mobileNo: textFieldMobileNo.text!,
                                        password: textFieldPassword.text!,
                                        uuid: rs.data?.Uuid ?? "",
                                        otp: rs.data?.otp ?? "",
                                        fcmToken: UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.fcmToken) as? String ?? ""
                                    )
                                )
                            } else {
                                
                                let vc = NewAgreementVC.instantiate()
                                vc.apiToken = rs.data?.apiToken ?? ""
                                vc.userId = rs.data?.userId
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        else {
                            navigateToVerifyOtp(
                                loginData: LoginOtpModel(
                                    mobileNo: textFieldMobileNo.text!,
                                    password: textFieldPassword.text!,
                                    uuid: rs.data?.Uuid ?? "",
                                    otp: rs.data?.otp ?? "",
                                    
                                    fcmToken: UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.fcmToken) as? String ?? ""
                                )
                            )
                        }
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
    
    func checkForUpdate() {
        
        let param = [
            Parameter.version: Bundle.main.releaseVersionNumber ?? "1.0",
            Parameter.appType: "2",
            Parameter.device_type: 1
        ] as [String : Any]
        
        Networking.request(
            url: Urls.checkVersion,
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
                    
                    let resetResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let rsResponse = resetResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    if rsResponse.status == StatusCode.success.rawValue {
                        
                        //present(UpdatePopup.instantiate(), animated: true, completion: nil)
                        login()
                        
                    } else if rsResponse.status == StatusCode.notFound.rawValue {
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
    
    private func login() {
        
        let param = [
            Parameter.mobileNo: textFieldMobileNo.text!,
            Parameter.password: textFieldPassword.text!,
            Parameter.fcmToken: UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.fcmToken) as? String ?? "",
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
        ) { response in
        
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
                        
                        UserDefaults.standard.set(loResponse.data!.apiToken, forKey:UserDefaultHelper.keys.apiToken)
                        
                        self.getActiveModules(cityId:loResponse.data!.cityId!,rs: loResponse)
                        
                    } else {
                        AlertHelper.shared.showAlert(message: loResponse.message!)
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
    
    private func navigateToVerifyOtp(loginData: LoginOtpModel) {
        let vc = LoginOtpVC.instantiate()
        vc.screenType = .login
        vc.loginOtpData = loginData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToForgotPwd() {
        self.navigationController?.pushViewController(ForgotPwdVC.instantiate(), animated: true)
    }
    
}
