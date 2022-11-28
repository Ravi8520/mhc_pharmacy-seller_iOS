//
//  ApiModel.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import Foundation

struct ModuleApiResponse: Decodable {
    
    let status: Int?
    let message: String?
    let data: CityModule?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(CityModule.self, forKey: .data)
    }
}

struct CityModule: Codable {
    
    let id :Int?
    let name : String?
    let city_id :Int?
    let state_id :Int?
    let country_id :Int?
    let deliveryType : String?
    let is_fitness_allow :Int?
    let is_lab_allow :Int?
    let is_doctor_allow :Int?
    let is_pill_reminder_allow :Int?
    let is_health_summary_allow :Int?
    let is_my_report_allow :Int?
    let is_weight_tracker_allow :Int?
    let is_step_tracker_allow :Int?
    let is_wallet_allow :Int?
    let is_my_voucher_allow :Int?
    let is_refer_and_earn_allow :Int?
    let is_payment_mode_allow : String?
    let is_pharmacy_manual_order_allow :Int?
    let is_whatsApp_order_allow :Int?
    let is_my_fav_pharmacy_allow :Int?
    let is_corporate_allow :Int?
    let is_agreement_allow :Int?
    let is_ledger_statement_allow :Int?
    let is_order_medicine_allow :Int?
    let created_at : String?
    let updated_at : String?
    let is_delete :Int?
}

struct CommonApiResponse: Decodable {
    
    let status : Int?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

// ======= User Module ======== //

struct RegisterWithOtpResponse : Codable {
    let status : Int?
    let message : String?
    let data : RegisterWithOtpResponseData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(RegisterWithOtpResponseData.self, forKey: .data)
    }
    
}
struct RegisterWithOtpResponseData : Codable {
    let uuid : String?
    let mobileOtp : String?
    let emailOtp : String?
    
    enum CodingKeys: String, CodingKey {
        
        case uuid = "Uuid"
        case mobileOtp = "MobileOtp"
        case emailOtp = "EmailOtp"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        mobileOtp = try values.decodeIfPresent(String.self, forKey: .mobileOtp)
        emailOtp = try values.decodeIfPresent(String.self, forKey: .emailOtp)
    }
    
}

struct VerifyRegisterationOtpReponse : Codable {
    let status : Int?
    let message : String?
    let data : VerifyRegisterationOtpReponseData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(VerifyRegisterationOtpReponseData.self, forKey: .data)
    }
    
}
struct VerifyRegisterationOtpReponseData : Codable {
    let userId : Int?
    let fullName : String?
    let profilePicture : String?
    let email : String?
    let mobileNo : String?
    let apiToken : String?
    
    enum CodingKeys: String, CodingKey {
        
        case userId = "userId"
        case fullName = "fullName"
        case profilePicture = "profilePicture"
        case email = "email"
        case mobileNo = "mobileNo"
        case apiToken = "apiToken"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        profilePicture = try values.decodeIfPresent(String.self, forKey: .profilePicture)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        mobileNo = try values.decodeIfPresent(String.self, forKey: .mobileNo)
        apiToken = try values.decodeIfPresent(String.self, forKey: .apiToken)
    }
    
}

struct CountryListApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : [CountryListDataApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([CountryListDataApiResponse].self, forKey: .data)
    }
    
}
struct CountryListDataApiResponse : Codable {
    let id : Int?
    let countryName : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case countryName = "countryName"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        countryName = try values.decodeIfPresent(String.self, forKey: .countryName)
    }
    
}

struct StateListApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : [StateListDataApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([StateListDataApiResponse].self, forKey: .data)
    }
    
}
struct StateListDataApiResponse : Codable {
    let id : Int?
    let stateName : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case stateName = "stateName"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
    }
    
}

struct CityListApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : [CityListDataApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([CityListDataApiResponse].self, forKey: .data)
    }
    
}
struct CityListDataApiResponse : Codable {
    let id : Int?
    let cityname : String?
    let deliveryType : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case cityname = "cityname"
        case deliveryType = "deliveryType"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        cityname = try values.decodeIfPresent(String.self, forKey: .cityname)
        deliveryType = try values.decodeIfPresent(String.self, forKey: .deliveryType)
    }
    
}

struct PincodeListApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : [PincodeListDataApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([PincodeListDataApiResponse].self, forKey: .data)
    }
    
}
struct PincodeListDataApiResponse : Codable {
    let id : Int?
    let pinCode : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case pinCode = "pinCode"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        pinCode = try values.decodeIfPresent(Int.self, forKey: .pinCode)
    }
    
}

struct AgreementApiResponse: Codable {
    let status: Int?
    let message: String?
    let data: AgreementDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(AgreementDataApiResponse.self, forKey: .data)
    }
    
}
struct AgreementDataApiResponse: Codable {
    let agreement: String?
    
    enum CodingKeys: String, CodingKey {
        
        case agreement = "html_filename"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        agreement = try values.decodeIfPresent(String.self, forKey: .agreement)
    }
}

struct ForgotPasswordApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : ForgotPasswordDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ForgotPasswordDataApiResponse.self, forKey: .data)
    }
    
}
struct ForgotPasswordDataApiResponse : Codable {
    let uuid : String?
    let userId : Int?
    let otp : String?
    
    enum CodingKeys: String, CodingKey {
        
        case uuid = "Uuid"
        case userId = "userId"
        case otp = "otp"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        otp = try values.decodeIfPresent(String.self, forKey: .otp)
    }
    
}


struct LoginOtpApiReponse: Codable {
    let status : Int?
    let message : String?
    let data : LoginOtpDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(LoginOtpDataApiResponse.self, forKey: .data)
    }
}
struct LoginOtpDataApiResponse: Codable {
    let Uuid: String?
    let otp: String?
    let userId: Int?
    let isAgreementNew : Int?
    let isAccept : Int?
    let apiToken : String?
    let cityId: Int?

    enum CodingKeys: String, CodingKey {
        
        case Uuid = "Uuid"
        case otp = "otp"
        case userId = "userId"
        case isAgreementNew = "is_agreement_new"
        case isAccept = "is_accept"
        case apiToken = "apiToken"
        case cityId = "city"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        Uuid = try values.decodeIfPresent(String.self, forKey: .Uuid)
        otp = try values.decodeIfPresent(String.self, forKey: .otp)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        isAgreementNew = try values.decodeIfPresent(Int.self, forKey: .isAgreementNew)
        isAccept = try values.decodeIfPresent(Int.self, forKey: .isAccept)
        apiToken = try values.decodeIfPresent(String.self, forKey: .apiToken)
        cityId = try values.decodeIfPresent(Int.self, forKey: .cityId)

    }
    
}

struct LoginApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : LoginDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(LoginDataApiResponse.self, forKey: .data)
    }
    
}
struct LoginDataApiResponse : Codable {
    let userId : Int?
    let userType : String?
    let fullName : String?
    let pharmacyLogo : String?
    let profilePicture : String?
    let email : String?
    let mobileNo : String?
    let apiToken : String?
    let isPharmacyDetailComplete : String?
    let isPharmacyApproved : String?
    let pharmacyOpenCloseStatus : String?
    let pharmacyName : String?
    let referralCode : String?
    let userAvailibiltyStatus : String?
    let allowedDeliveryType : String?
    let cityId : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case userId = "userId"
        case userType = "userType"
        case fullName = "fullName"
        case pharmacyLogo = "pharmacyLogo"
        case profilePicture = "profilePicture"
        case email = "email"
        case mobileNo = "mobileNo"
        case apiToken = "apiToken"
        case isPharmacyDetailComplete = "isPharmacyDetailComplete"
        case isPharmacyApproved = "isPharmacyApproved"
        case pharmacyOpenCloseStatus = "pharmacyOpenCloseStatus"
        case pharmacyName = "pharmacyName"
        case referralCode = "referralCode"
        case userAvailibiltyStatus = "userAvailibiltyStatus"
        case allowedDeliveryType = "allowedDeliveryType"
        case cityId = "city"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        pharmacyLogo = try values.decodeIfPresent(String.self, forKey: .pharmacyLogo)
        profilePicture = try values.decodeIfPresent(String.self, forKey: .profilePicture)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        mobileNo = try values.decodeIfPresent(String.self, forKey: .mobileNo)
        apiToken = try values.decodeIfPresent(String.self, forKey: .apiToken)
        isPharmacyDetailComplete = try values.decodeIfPresent(String.self, forKey: .isPharmacyDetailComplete)
        isPharmacyApproved = try values.decodeIfPresent(String.self, forKey: .isPharmacyApproved)
        pharmacyOpenCloseStatus = try values.decodeIfPresent(String.self, forKey: .pharmacyOpenCloseStatus)
        pharmacyName = try values.decodeIfPresent(String.self, forKey: .pharmacyName)
        referralCode = try values.decodeIfPresent(String.self, forKey: .referralCode)
        userAvailibiltyStatus = try values.decodeIfPresent(String.self, forKey: .userAvailibiltyStatus)
        allowedDeliveryType = try values.decodeIfPresent(String.self, forKey: .allowedDeliveryType)
        cityId = try values.decodeIfPresent(Int.self, forKey: .cityId)
    }
}

struct GetProfileApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : GetProfileDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(GetProfileDataApiResponse.self, forKey: .data)
    }
    
}
struct GetProfileDataApiResponse : Codable {
    let pharmacyName : String?
    let phamacyLogo : String?
    let pharmacyOpenTime : String?
    let pharmacyCloseTime : String?
    let lunchOpenTime : String?
    let lunchCloseTime : String?
    let discountMin : String?
    let discountMax : String?
    let deliveryRange : String?
    let isInternalDelivery : String?
    let isSundayOpen : String?
    let sundayOpenTime : String?
    let sundayCloseTime : String?
    let sundayLunchOpenTime : String?
    let sundayLunchCloseTime : String?
    let pharmacyOwnerName : String?
    let businessType : String?
    let partnerName : String?
    let registrationNumber : String?
    let licenceValidUpto : String?
    let address : String?
    let latitude : String?
    let longitude : String?
    let city : String?
    let state : String?
    let country : String?
    let pincode : String?
    let adharcard : [MultiImageApiResponse]?
    let pancard : String?
    let ownerPhoto : String?
    let drugLicence : [MultiImageApiResponse]?
    let partnershipDeed : [MultiImageApiResponse]?
    let accountRequestDate : String?
    let accountApproveDate : String?
    
    enum CodingKeys: String, CodingKey {
        
        case pharmacyName = "pharmacyName"
        case phamacyLogo = "phamacyLogo"
        case pharmacyOpenTime = "pharmacyOpenTime"
        case pharmacyCloseTime = "pharmacyCloseTime"
        case lunchOpenTime = "lunchOpenTime"
        case lunchCloseTime = "lunchCloseTime"
        case discountMin = "discountMin"
        case discountMax = "discountMax"
        case deliveryRange = "deliveryRange"
        case isInternalDelivery = "isInternalDelivery"
        case isSundayOpen = "isSundayOpen"
        case sundayOpenTime = "sundayOpenTime"
        case sundayCloseTime = "sundayCloseTime"
        case sundayLunchOpenTime = "sundayLunchOpenTime"
        case sundayLunchCloseTime = "sundayLunchCloseTime"
        case pharmacyOwnerName = "pharmacyOwnerName"
        case businessType = "businessType"
        case partnerName = "partnerName"
        case registrationNumber = "registrationNumber"
        case licenceValidUpto = "licenceValidUpto"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case city = "city"
        case state = "state"
        case country = "country"
        case pincode = "pincode"
        case adharcard = "adharcard"
        case pancard = "pancard"
        case ownerPhoto = "ownerPhoto"
        case drugLicence = "drugLicence"
        case partnershipDeed = "partnershipDeed"
        case accountRequestDate = "accountRequestDate"
        case accountApproveDate = "accountApproveDate"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pharmacyName = try values.decodeIfPresent(String.self, forKey: .pharmacyName)
        phamacyLogo = try values.decodeIfPresent(String.self, forKey: .phamacyLogo)
        pharmacyOpenTime = try values.decodeIfPresent(String.self, forKey: .pharmacyOpenTime)
        pharmacyCloseTime = try values.decodeIfPresent(String.self, forKey: .pharmacyCloseTime)
        lunchOpenTime = try values.decodeIfPresent(String.self, forKey: .lunchOpenTime)
        lunchCloseTime = try values.decodeIfPresent(String.self, forKey: .lunchCloseTime)
        discountMin = try values.decodeIfPresent(String.self, forKey: .discountMin)
        discountMax = try values.decodeIfPresent(String.self, forKey: .discountMax)
        deliveryRange = try values.decodeIfPresent(String.self, forKey: .deliveryRange)
        isInternalDelivery = try values.decodeIfPresent(String.self, forKey: .isInternalDelivery)
        isSundayOpen = try values.decodeIfPresent(String.self, forKey: .isSundayOpen)
        sundayOpenTime = try values.decodeIfPresent(String.self, forKey: .sundayOpenTime)
        sundayCloseTime = try values.decodeIfPresent(String.self, forKey: .sundayCloseTime)
        sundayLunchOpenTime = try values.decodeIfPresent(String.self, forKey: .sundayLunchOpenTime)
        sundayLunchCloseTime = try values.decodeIfPresent(String.self, forKey: .sundayLunchCloseTime)
        pharmacyOwnerName = try values.decodeIfPresent(String.self, forKey: .pharmacyOwnerName)
        businessType = try values.decodeIfPresent(String.self, forKey: .businessType)
        partnerName = try values.decodeIfPresent(String.self, forKey: .partnerName)
        registrationNumber = try values.decodeIfPresent(String.self, forKey: .registrationNumber)
        licenceValidUpto = try values.decodeIfPresent(String.self, forKey: .licenceValidUpto)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        pincode = try values.decodeIfPresent(String.self, forKey: .pincode)
        adharcard = try values.decodeIfPresent([MultiImageApiResponse].self, forKey: .adharcard)
        pancard = try values.decodeIfPresent(String.self, forKey: .pancard)
        ownerPhoto = try values.decodeIfPresent(String.self, forKey: .ownerPhoto)
        drugLicence = try values.decodeIfPresent([MultiImageApiResponse].self, forKey: .drugLicence)
        partnershipDeed = try values.decodeIfPresent([MultiImageApiResponse].self, forKey: .partnershipDeed)
        accountRequestDate = try values.decodeIfPresent(String.self, forKey: .accountRequestDate)
        accountApproveDate = try values.decodeIfPresent(String.self, forKey: .accountApproveDate)
    }
    
}
struct MultiImageApiResponse : Codable {
    let id : Int?
    let image : String?
    let mimeTtype: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case image = "image"
        case mimeTtype = "mimeTtype"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        mimeTtype = try values.decodeIfPresent(String.self, forKey: .mimeTtype)
    }
    
}


