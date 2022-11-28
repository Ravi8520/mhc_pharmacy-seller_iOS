//
//  ValidationHelper.swift
//  My Pharmacy
//
//  Created by Jat42 on 18/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

class Validation: NSObject {
    
    static let maxMobileNoLength = 10
    static let minPwdLength = 6
    static let maxPwdLength = 60
    static let maxEmailLength = 60
    static let minNameLength = 3
    static let maxNameLength = 120
    static let minPrescriptionName = 3
    static let maxPrescriptionName = 120
    static let minReminderName = 3
    static let maxReminderNameLength = 160
    static let minMedicineNameLength = 3
    static let maxMedicineNameLength = 220
    static let minAllergyNameLength = 3
    static let maxAllergyNameLength = 220
    static let maxHospitalNameLength = 120
    static let minHospitalnameLength = 3
    static let maxDoctorNameLength = 120
    static let minDoctorNameLength = 3
    static let minReportNameLength = 3
    static let maxReportNameLength = 120
    static let minRemarkLength = 10
    static let maxRemarkLength = 500
    static let minBlockLength = 3
    static let maxBlockLength = 260
    static let minStreetNameLength = 3
    static let maxStreetNameLength = 260
    static let minCityNameLength = 3
    static let maxCityNameLength = 120
    static let minDescriptionLength = 10
    static let maxDescriptionLength = 360
    static let minReasonLength = 10
    static let maxReasonLength = 500
    static let maxReferralCodeLength = 20
    static let minCancelReasonLength = 10
    static let maxCancelReasonLength = 200
    static let maxAllowedChares = 50
    static let minReqChares = 3
    static let reqPincodeChares = 6
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
            "\\@" +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
            "(" +
            "\\." +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
            ")+"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidMobileNumber(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{8,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    static let mobileNoInvalidChars = CharacterSet(charactersIn: "0123456789").inverted
    static let nameInvalidChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ").inverted
    static let invalidAmountValue = CharacterSet(charactersIn: "0123456789.").inverted
    static let invalidAlphaNumeric = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789").inverted
    
    static func shouldAllowTyping(_ textField: UITextField, range: NSRange, string: String, maxRange: Int) -> Bool {
        ((textField.text?.count)! + (string.count - range.length)) > maxRange ? false : true
    }
    
}
