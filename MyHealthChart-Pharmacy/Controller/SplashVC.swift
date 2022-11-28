//
//  SplashVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 28/09/21.
//

import UIKit

extension SplashVC {
    static func instantiate() -> SplashVC {
        StoryBoardConstants.splash.instantiateViewController(withIdentifier: String(describing: SplashVC.self)) as! SplashVC
    }
}

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let isAutoLogin = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.isLogin) as? Bool
        
        if let autoLogin = isAutoLogin, autoLogin {
//            checkForUpdate()
            autoLoginApi()
        } else {
            showLoginScreen()
        }
        
    }
    
    func showLoginScreen() {
        self.navigationController?.pushViewController(LoginVC.instantiate(), animated: true)
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
                            autoLoginApi()
                            
                        } else if rsResponse.status == StatusCode.notFound.rawValue {
                            present(UpdatePopup.instantiate(), animated: true, completion: nil)
                            
                        } else {
                            present(UpdatePopup.instantiate(), animated: true, completion: nil)
                            //                        AlertHelper.shared.showAlert(message: rsResponse.message!)
                        }
                        
                    case .failure(let error):
                        Log.e(error.localizedDescription)
                        AlertHelper.shared.showAlert(message: error.localizedDescription) { action in
                            Helper.shared.setLogout()
                        }
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
                            
                            self.setUserData(userData: userData)
                        
                        } else {
                            // Pharmacy not approved
                            
                            if userData.userType?.lowercased() == UserType.seller.serverString {
                                
                                self.setUserData(userData: userData)
                
                            } else {
                                
                                AlertHelper.shared.showAlert(
                                    title: Strings.alertTitle,
                                    message: Strings.memberShipUnderReviewMessage
                                ) { action in
                                        self.showLoginScreen()
                                }
                            }
                        }
                        
                    } else {
                        // Pharmacy detail is remains, navigate to pharmacy detail
                        self.navigateToPharmacyDetail(responseData: userData)
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
    
    private func autoLoginApi() {
      
        if let mobileNo = UserDefaultHelper.shared.getUserData(
            key: UserDefaultHelper.keys.mobileNo
        ) as? String,
           let pwd = UserDefaultHelper.shared.getUserData(
            key: UserDefaultHelper.keys.userPassword
           ) as? String {
            
            let param = [
                Parameter.mobileNo: mobileNo,
                Parameter.password: pwd,
                Parameter.fcmToken: UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.fcmToken) as? String ?? "",
                Parameter.deviceType: "ios"
            ]
            
            Networking.request(
                url: Urls.autoLogin,
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
                        
                        let loginResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: LoginApiResponse.self)
                        
                        guard let lgResponse = loginResponse else {
                            AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                            return
                        }
                        
                        if lgResponse.status == StatusCode.success.rawValue {
                            
                            guard let userData = lgResponse.data else { return }
                            
                            UserDefaults.standard.set(lgResponse.data!.apiToken, forKey:UserDefaultHelper.keys.apiToken)
                            
                            Parameter.allowedDeliveryType = userData.allowedDeliveryType!
                        
                            self.getActiveModules(rs:lgResponse)
                            
                        } else {
                            
                            AlertHelper.shared.showAlert(
                                title: Strings.alertTitle,
                                message: lgResponse.message!
                            ) { action in
                                self.showLoginScreen()
                            }
                            
                        }
                        
                    case .failure(let error):
                        AlertHelper.shared.showAlert(message: error.localizedDescription)
                        Log.e(error.localizedDescription)
                }
                
            }

        } else {
            showLoginScreen()
        }
        
    }
    
    private func setUserData(userData: LoginDataApiResponse) {
        
        UserDefaultHelper.shared.saveUserData(data: userData)
    
        if userData.userType?.lowercased() == UserType.seller.serverString {
            AppConfig.userType = .seller
        } else if userData.userType?.lowercased() == UserType.pharmacy.serverString {
            AppConfig.userType = .pharmacy
        }
        
        self.showDashboard()
        
    }
    
    func showDashboard() {
        self.navigationController?.pushViewController(BottomTabbarVC.instantiate(), animated: true)
    }
    
    func navigateToPharmacyDetail(responseData: LoginDataApiResponse) {
        let vc = PharmacyDetailsVC.instantiate()
        vc.loginResponse = responseData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
