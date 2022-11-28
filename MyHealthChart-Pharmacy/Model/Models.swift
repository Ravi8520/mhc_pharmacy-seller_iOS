//
//  OrderModels.swift
//  My Pharmacy
//
//  Created by Jat42 on 21/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit



struct FilterApplied {
    let fromDate: String
    let endDate: String
    let selectedId: String
}

struct RegisterationModel {
    let firmType: String
    let fullName: String
    let partnerName: [String]
    let email: String
    let pharmacyOwnerMobileNumber: String?
    let pharmacyServiceMobileNumber: String?
    let pharmacyManagerMobileNumber: String?
    let drugLicenceNumber: String
    let validUpToYear: String
    let password: String
    let partnerShipDeed: [MediaData]?
    let drugLicence: [MediaData]
    let adharCardFrontSide: MediaData
    let adharCardBackSide: MediaData?
    let panCard: MediaData
    let ownerPhoto: MediaData
    let uuid: String
    let emailOtp: String?
    let mobileOtp: String?
}

struct PharmacyDetail {
    let logoData: MediaData
    let apiToken: String
    let userId: Int
    let pharmacyName: String
    let latitude: String
    let longitude: String
    let address: String
    let country: String
    let state: String
    let city: String
    let pincode: String
    let internalDeliveryRange: String
    let minDiscount: String
    let maxDiscount: String
    let discountTermsAndCond: String
    let shopOpenTime: String
    let shopCloseTime: String
    let lunchOpenTime: String
    let lunchCloseTime: String
    let sundayOpenTime: String
    let sundayCloseTime: String
    let sundayLunchOpenTime: String
    let sundayLunchCloseTime: String
}

struct LoginOtpModel {
    let mobileNo: String
    let password: String
    var uuid: String
    var otp: String
    let fcmToken: String
}

struct FilterUserModel {
    var id: Int
    var name: String
    var isSelected: Bool
}

@objc protocol OrderUpdateDelegate {
    @objc optional func orderUpdated(vc: UIViewController)
}
