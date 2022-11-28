//
//  ApiConstants.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//
// http://139.59.44.157:3800 // Out side dev server
// http://167.172.146.209:3800 // TFB dev server
// http://myhealthchart.in/pharma_v2/user/
import Foundation

struct Urls {
    
    // MARK:- Api Constants -
    
    // Base Url //
    
    private static var baseUrl : String {
        get {
            switch AppConfig.appMode {
                    // "http://167.172.146.209:3800/api/"
                case .development:
                    return "http://128.199.26.177:3801/api/"
                       //"http://myhealthchart.in:3800/api/"
                       // "http://128.199.26.177:3800/api/"
                       
                case .production:
                    //return "http://128.199.26.177:3800/api/"
                      return "http://myhealthchart.in:3801/api/"
                        //"http://128.199.26.177:3800/api/"
                        //"http://167.172.146.209:3800/api/"
                case .productionAndLogs:
                    return "http://myhealthchart.in:3801/api/"
            }
        }
    }
        
    static var socketBaseUrl : String {
        get {
            switch AppConfig.appMode {
                case .development:
                    return "http://139.59.44.157:3800/api/"
                case .production:
                    return "http://64.225.84.162:6001/"
                case .productionAndLogs:
                    return "http://64.225.84.162:6001/"
            }
        }
    }
    
    // Api End Points //
    
    //=== User Module ===//

    static var checkVersion: String {
        baseUrl + "checkversion"
    }
    
    static var getActiveModules: String {
        baseUrl + "allow_module"
    }
    
    static var registerOtp: String {
        baseUrl + "client/registerotp"
    }
    
    static var verifyRegister: String {
        baseUrl + "client/register"
    }
    
    static var countryList: String {
        baseUrl + "countrylist"
    }
    
    static var stateList: String {
        baseUrl + "statelist"
    }
    
    static var cityList: String {
        baseUrl + "citylist"
    }
    
    static var pincodeList: String {
        baseUrl + "pincodelist"
    }
    
    static var getAgreement: String {
        baseUrl + "client/getagreement_new"
    }
    static var checkNewAgreement: String {
        baseUrl + "client/check_new_agreement"
    }
    
    static var addPharmacyDetail: String {
        baseUrl + "client/pharmacydetail"
    }
    
    static var forgotPwd: String {
        baseUrl + "client/forgotpassword"
    }
    
    static var verifyForgotPwdOtp: String {
        baseUrl + "client/verifyforgototp"
    }
    
    static var resetPwd: String {
        baseUrl + "client/resetpassword"
    }
    
    static var autoLogin: String {
        baseUrl + "client/autologin"
    }
    
    static var loginWithOtp: String {
        baseUrl + "client/loginwithotp"
    }
    
    static var verifyAndLogin: String {
        baseUrl + "client/verifyloginotp"
    }
    
    static var getPharmacyProfile: String {
        baseUrl + "getprofile"
    }
    
    static var editPharmacyProfile: String {
        baseUrl + "editprofile"
    }
    
    static var changePwd: String {
        baseUrl + "client/changepassword"
    }
    
    static var logout: String {
        baseUrl + "client/logout"
    }
    
    static var changePharmacyStatus: String {
        baseUrl + "changepharmacystatus"
    }
    
    // ==== Dashboard ==== //
    
    static var getEarningData: String {
        baseUrl + "getearningdata"
    }
    
    static var todayPendingDelivery: String {
        baseUrl + "todaypendingdelivery"
    }
    
    static var todayCompleteDelivery: String {
        baseUrl + "todaycompletedelivery"
    }
    
    static var internalDeliveryList: String {
        baseUrl + "internaldelivery"
    }
    
    static var externalDeliveryList: String {
        baseUrl + "externaldelivery"
    }
    
    static var notificationList: String {
        baseUrl + "notificationlist"
    }
    
    static var clearNotification: String {
        baseUrl + "clearnotification"
    }
    
    // ==== My Team ==== //
    
    static var myTeamList: String {
        baseUrl + "myteam"
    }
    
    static var addTeamMember: String {
        baseUrl + "addteammember"
    }
    
    static var teammemberDetail: String {
        baseUrl + "myteamdetail"
    }
    
    static var teammemberStatusChanged: String {
        baseUrl + "userstatuschange"
    }
    
    static var editTeamMember: String {
        baseUrl + "editteammember"
    }
    
    // ==== Seller ==== //
    
    static var setSellerStatus: String {
        baseUrl + "setsellerstatus"
    }
    
    static var getSellerProfile: String {
        baseUrl + "getsellerprofile"
    }
    
    static var editSellerProfile: String {
        baseUrl + "editsellerprofile"
    }
    
    // ==== Order ==== //
    
    static var dashboardCount: String {
        baseUrl + "dashboard"
    }
    
    static var upcomingOrderList: String {
        baseUrl + "upcommingorder"
    }
    
    static var acceptOrder: String {
        baseUrl + "orderaccept"
    }
    
    static var orderDetail: String {
        baseUrl + "orderdetail"
    }
    
    static var dashboardSearch: String {
        baseUrl + "dashboardsearch"
    }
    
    // ==== //
    
    static var accepteOrderList: String {
        baseUrl + "acceptedorder"
    }
    
    static var activeDeliveryBoyList: String {
        baseUrl + "activedeliveryboy"
    }
    
    static var assignOrder: String {
        baseUrl + "assignorder"
    }
    
    static var rejectReason: String {
        baseUrl + "rejectreasonlist"
    }
    
    static var rejectOrder: String {
        baseUrl + "orderreject"
    }
    
    static var confirmReturnOrder: String {
        baseUrl + "returnconfirm"
    }
    
    // ==== //

    static var readyForPickupOrderList: String {
        baseUrl + "readyforpickup"
    }
    
    static var reassignOrder: String {
        baseUrl + "reassignorder"
    }
    
    // ==== //
    
    static var outForDeliveryOrderList: String {
        baseUrl + "outfordelivery"
    }
    
    static var completeOrderList: String {
        baseUrl + "completeorder"
    }
    
    // ==== //
    
    static var rejectedOrderList: String {
        baseUrl + "rejectedorder"
    }
    
    static var cancelledOrderList: String {
        baseUrl + "cancelorder"
    }
    
    static var returnOrderList: String {
        baseUrl + "returnorder"
    }
    
    // ==== Report ==== //
    
    static var orderReport: String {
        baseUrl + "orderreport"
    }
    
    static var incomeReport: String {
        baseUrl + "incomereport"
    }
    
    // ==== Package ==== //
    
    static var packageList: String {
        baseUrl + "packagelist"
    }
    
    static var packageHistory: String {
        baseUrl + "packagehistory"
    }
    
    // ==== Referral Users ==== //
    
    static var referralUsers: String {
        baseUrl + "refreluser"
    }
    
    // ==== Feedback ==== //
    
    static var getFeedbackList: String {
        baseUrl + "feedback"
    }
    
    // ==== manualDeliveryOrderCreate ==== //

    static var manualDeliveryOrderCreate: String {
        baseUrl + "manualDeliveryOrderCreate"
    }
    
    // ==== manualDeliveryOrderCreateList ==== //

    static var manualDeliveryOrderCreateList: String {
        baseUrl + "manualDeliveryOrderCreate_list"
    }
    
    // ==== manualDeliveryOrderPickup_list ==== //

    static var manualDeliveryOrderPickupList: String {
        baseUrl + "manualDeliveryOrderPickup_list"
    }
    
    // ==== manualDeliveryOrderIncomplete_list ==== //

    static var manualDeliveryOrderIncompleteList: String {
        baseUrl + "manualDeliveryOrderIncomplete_list"
    }
    
    // ==== manualDeliveryOrderComplete_list ==== //

    static var manualDeliveryOrderCompleteList: String {
        baseUrl + "manualDeliveryOrderComplete_list"
    }
    
    // ==== manualDeliveryOrderCanceList ==== //

    static var manualDeliveryOrderCanceList: String {
        baseUrl + "manualDeliveryOrderCancel_list"
    }
    
    // ==== manualDeliveryOrderDetails ==== //

    static var manualDeliveryOrderDetails: String {
        baseUrl + "manualDeliveryOrderDetails"
    }
    
    // ==== manualDeliveryOrderDetails ==== //

    static var manualDeliveryOrderCancel: String {
        baseUrl + "manualDeliveryOrderCancel"
    }
    
    static var ledgersheetlist: String {
        baseUrl + "ledgersheetlist"
    }
    
}

struct Parameter {
    static let email = "email"
    static let mobileNo = "mobileNo"
    static let mobileNumber = "mobile_number"
    static let orderAmount = "order_amount"
    static let parcelImages = "parcelImages"
    static let currentPassword = "currentPassword"
    static let newPassword = "newPassword"
    static let fcmToken = "fcmToken"
    static let deviceType = "deviceType"
    static let uuid = "Uuid"
    static let emailOtp = "emailOtp"
    static let mobileNoOtp = "mobileNoOtp"
    static let otp = "otp"
    static let firmType = "firmType"
    static let fullName = "fullName"
    static let serviceMobileNo = "serviceMobileNo"
    static let managerMobileNo = "managerMobileNo"
    static let drugLicenceNo = "drugLicenceNo"
    static let validUptoyear = "validUptoyear"
    static let password = "password"
    static let partnerShipDeed = "partnerShipDeed"
    static let drugLicence = "drugLicence"
    static let adharCardfront = "adharCardfront"
    static let adharCardback = "adharCardback"
    static let panCard = "panCard"
    static let ownerPhoto = "ownerPhoto"
    static let countryId = "countryId"
    static let stateId = "stateId"
    static let cityId = "city_id"
    static let apiToken = "apiToken"
    static let id = "id"
    static let pharmacyName = "pharmacyName"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let address = "address"
    static let country = "country"
    static let state = "state"
    static let city = "city"
    static let pincode = "pincode"
    static let internalDeliveryRange = "internalDeliveryRange"
    static let minDiscount = "minDiscount"
    static let maxDiscount = "maxDiscount"
    static let discountTermsAndCond = "discountTermsAndCond"
    static let shopOpenTime = "shopOpenTime"
    static let shopCloseTime = "shopCloseTime"
    static let lunchOpenTime = "lunchOpenTime"
    static let lunchCloseTime = "lunchCloseTime"
    static let sundayOpenTime = "sundayOpenTime"
    static let sundayCloseTime = "sundayCloseTime"
    static let sundayLunchOpenTime = "sundayLunchOpenTime"
    static let sundayLunchCloseTime = "sundayLunchCloseTime"
    static let pharmacyLogo = "pharmacyLogo"
    static let pharmacyStatus = "pharmacyStatus"
    static let date = "date"
    static let searchText = "searchText"
    static let userType = "userType"
    static let name = "name"
    static let blockNo = "blockNo"
    static let streetName = "streetName"
    static let landmark = "landmark"
    static let profile = "profile"
    static let userId = "userId"
    static let status = "status"
    static let partnerName = "partnerName"
    static let pageNo = "pageNo"
    static let orderId = "orderId"
    static let deliveryBoyId = "deliveryBoyId"
    static let amount = "amount"
    static let invoice = "invoice"
    static let reasonId = "reasonId"
    static let dataType = "dataType"
    static let fromDate = "fromDate"
    static let toDate = "toDate"
    static let seller = "seller"
    static let deliveryBoy = "deliveryBoy"
    static let rating = "rating"
    static let device_type = "device_type"
    static let version = "version"
    static let appType = "app_type"
    static let ordersId = "order_id"
    static let CancelReason = "cancel_reason"
    static let isAccept = "is_accept"
    static let paymentStatus = "payment_status"
    static let provide_delivery_choice = "provide_delivery"
    
    static var deliveryTypeboth = ""
    static var is_pharmacy_manual_order_allow = Bool()
    static var is_ledger_statement_allow = Bool()
    static var is_agreement = Bool()
    static var module_city_id = Int()
    static var allowedDeliveryType = ""
    
}

struct SocketEvent {
//    static let channelName = "CreateNewOrder"
}
