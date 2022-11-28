//
//  FCMTokenManager.swift
//  Pharma
//
//  Created by Jatan Ambasana on 09/08/21.
//  Copyright © 2021 TFB. All rights reserved.
//

import UIKit
import FirebaseMessaging

class TokenManager: NSObject {

    static let shared = TokenManager()

    func retriveToken() {

        let token = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.fcmToken) as? String

        if token == nil || token!.isEmpty {
            Messaging.messaging().token { string, error in
                UserDefaults.standard.setValue(string, forKey: UserDefaultHelper.keys.fcmToken)
            }
        }

    }

    func getToken() -> String {
        UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.fcmToken) as? String ?? ""
    }

}
