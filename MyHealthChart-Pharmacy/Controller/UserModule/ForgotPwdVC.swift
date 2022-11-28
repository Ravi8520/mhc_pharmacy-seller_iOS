//
//  ForgotPwdVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 01/10/21.
//

import UIKit

extension ForgotPwdVC {
    static func instantiate() -> ForgotPwdVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: ForgotPwdVC.self)) as! ForgotPwdVC
    }
}

class ForgotPwdVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var textFieldMobileNo: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setUpView()
    }
    
    private func setUpView() {
        uiViewToolBar.labelTitle.text = "Forgot Password"
        uiViewToolBar.btnSearch.isHidden = true
        
        setUpDelegates()
    }
    
    private func setUpDelegates() {
        uiViewToolBar.delegate = self
        textFieldMobileNo.delegate = self
    }
    
    @IBAction func btnSendPressed(_ sender: HalfCornerButton) {
        validateForm()
    }
    
}

extension ForgotPwdVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
                ) == nil)
            
        }
        
        return true
    }
    
}

private extension ForgotPwdVC {
    
    func validateForm() {
        
        var isValidMobile = false
        
        if textFieldMobileNo.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            textFieldMobileNo.errorMessage = Strings.emptyPhoneError
        } else if textFieldMobileNo.text!.count < Validation.maxMobileNoLength {
            textFieldMobileNo.errorMessage = Strings.invalidMobileNoError
        } else {
            isValidMobile = true
            textFieldMobileNo.errorMessage = nil
        }
        
        if isValidMobile {
            // Call api
            forgotPassword()
            //navigateToOpt()
            Log.m("Forgot pwd called")
        }
        
    }
    
    private func forgotPassword() {
        
        let param = [
            Parameter.mobileNo: textFieldMobileNo.text!
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
                        
                        AlertHelper.shared.showToast(message: fpResponse.message!, duration: .normal) { [self] in
                            navigateToOpt(forgotPwdData: fpResponse.data)
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
    
    private func navigateToOpt(forgotPwdData: ForgotPasswordDataApiResponse? = nil) {
        let vc = LoginOtpVC.instantiate()
        vc.screenType = .resetPassword
        vc.forgotPwdData = forgotPwdData
        vc.mobileNumber = textFieldMobileNo.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ForgotPwdVC: ToolBarDelegate {
    
    func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
