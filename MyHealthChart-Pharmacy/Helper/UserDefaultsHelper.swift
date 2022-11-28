//
//  UserDefaultsHelper.swift
//  My Pharmacy
//
//  Created by Jat42 on 18/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

class UserDefaultHelper: NSObject {
    
    static let shared = UserDefaultHelper()
    
    private let userDefault = UserDefaults.standard
    
    private override init () {}
    
    struct keys {
        static let isLogin = "isLogin"
        static let userId = "userId"
        static let userType = "userType"
        static let fullName = "fullName"
        static let pharmacyLogo = "pharmacyLogo"
        static let profilePicture = "profilePicture"
        static let email = "email"
        static let mobileNo = "mobileNo"
        static let isPharmacyDetailComplete = "isPharmacyDetailComplete"
        static let isPharmacyApproved = "isPharmacyApproved"
        static let pharmacyOpenCloseStatus = "pharmacyOpenCloseStatus"
        static let pharmacyName = "pharmacyName"
        static let referralCode = "referralCode"
        static let userAvailibiltyStatus = "userAvailibiltyStatus"
        static let allowedDeliveryType = "allowedDeliveryType"
        static let apiToken = "apiToken"
        static let fcmToken = "fcmToken"
        static let userPassword = "userPassword"
    }
    
    func saveUserData(data: LoginDataApiResponse) {
            
        userDefault.set(data.userId, forKey: keys.userId)
        userDefault.set(data.userType, forKey: keys.userType)
        userDefault.set(data.fullName, forKey: keys.fullName)
        userDefault.set(data.pharmacyLogo, forKey: keys.pharmacyLogo)
        userDefault.set(data.profilePicture, forKey: keys.profilePicture)
        userDefault.set(data.email, forKey: keys.email)
        userDefault.set(data.mobileNo, forKey: keys.mobileNo)
        userDefault.set(data.apiToken, forKey: keys.apiToken)
        userDefault.set(data.isPharmacyDetailComplete, forKey: keys.isPharmacyDetailComplete)
        userDefault.set(data.isPharmacyApproved, forKey: keys.isPharmacyApproved)
        userDefault.set(data.pharmacyOpenCloseStatus, forKey: keys.pharmacyOpenCloseStatus)
        userDefault.set(data.pharmacyName, forKey: keys.pharmacyName)
        userDefault.set(data.referralCode, forKey: keys.referralCode)
        userDefault.set(data.userAvailibiltyStatus, forKey: keys.userAvailibiltyStatus)
        userDefault.set(data.allowedDeliveryType, forKey: keys.allowedDeliveryType)
        
        //userDefault.set(data.fcm_token, forKey: UserDefaultKeys.fcmToken)
    }
    
    func getUserData(key: String) -> Any? {
        userDefault.value(forKey: key)
    }
    
    func setData(key: String, data: Any?) {
        userDefault.set(data, forKey: key)
    }
    
    func setUserPassword(password: String) {
        userDefault.set(password, forKey: keys.userPassword)
    }
    
    func getUserPassword() -> String {
        userDefault.string(forKey: keys.userPassword) ?? ""
    }
    
    func setAutoLogin() {
        userDefault.set(true, forKey: keys.isLogin)
    }
    
    func getAutoLoginStatus() -> Bool {
        userDefault.bool(forKey: keys.isLogin)
    }
    
    func removeAllUserData() {
        userDefault.removeObject(forKey: keys.userId)
        userDefault.removeObject(forKey: keys.userType)
        userDefault.removeObject(forKey: keys.fullName)
        userDefault.removeObject(forKey: keys.pharmacyLogo)
        userDefault.removeObject(forKey: keys.profilePicture)
        userDefault.removeObject(forKey: keys.email)
        userDefault.removeObject(forKey: keys.mobileNo)
        userDefault.removeObject(forKey: keys.apiToken)
        userDefault.removeObject(forKey: keys.isPharmacyDetailComplete)
        userDefault.removeObject(forKey: keys.isPharmacyApproved)
        userDefault.removeObject(forKey: keys.pharmacyOpenCloseStatus)
        userDefault.removeObject(forKey: keys.pharmacyName)
        userDefault.removeObject(forKey: keys.referralCode)
        userDefault.removeObject(forKey: keys.userAvailibiltyStatus)
        userDefault.removeObject(forKey: keys.allowedDeliveryType)
        
        
//        userDefault.removeObject(forKey: UserDefaultKeys.fcmToken)
        userDefault.set(false, forKey: keys.isLogin)
        userDefault.removeObject(forKey: keys.userPassword)
    }
    
}
