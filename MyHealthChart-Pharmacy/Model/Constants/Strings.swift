//
//  Strings.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import Foundation

struct Strings {
    
    /* Validation regex */
    
    static let emailRegex = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+"
    static let phoneRegex = "[0-9]+"
    
    /* Validation errors */
    
    static let emptyFullNameError = NSLocalizedString("Please enter full name", comment: "Empty name error")
    static func invalidNameError(length: Int) -> String {
        NSLocalizedString("Name should contains atleast \(length) characters", comment: "Invalid first name length error")
    }
    
    static let emptyPartnerNameError = NSLocalizedString("Please enter partner name", comment: "Empty partner name error")
    static func invalidPartnerNameError(length: Int) -> String {
        NSLocalizedString("Partner name should contains atleast \(length) characters", comment: "Invalid partner name length error")
    }
    
    static let emptyEmailError = NSLocalizedString("Please enter email", comment: "Empty email error")
    static let invalidEmailError = NSLocalizedString("Please enter valid email", comment: "Invalid email error")
    
    static let emptyOwnerPhoneError = NSLocalizedString("Please enter pharmacy owner mobile number", comment: "Invalid phone error")
    static func invalidOwnerPhoneLengthError(length: Int) -> String {
        NSLocalizedString("Pharmacy owner mobile number should contains atleast \(length) characters", comment: "Invalid phone length error")
    }
    
    static let emptyServicePhoneError = NSLocalizedString("Please enter pharmacy service mobile number", comment: "Invalid phone error")
    static func invalidServicePhoneLengthError(length: Int) -> String {
        NSLocalizedString("Pharmacy service mobile number should contains atleast \(length) characters", comment: "Invalid phone length error")
    }
    
    static let emptyManagerPhoneError = NSLocalizedString("Please enter pharmacy manager mobile number", comment: "Invalid phone error")
    static func invalidManagerPhoneLengthError(length: Int) -> String {
        NSLocalizedString("Pharmacy manager mobile number should contains atleast \(length) characters", comment: "Invalid phone length error")
    }
    
    static let emptyDrugLicenceNo = NSLocalizedString("Please enter drug licence number", comment: "Invalid phone error")
    static func invalidDrugLicenceNoError(length: Int) -> String {
        NSLocalizedString("Drug licence number should contains atleast \(length) characters", comment: "Invalid phone length error")
    }
    
    static let emptyValidUpToYear = NSLocalizedString("Please select valid up to year", comment: "Invalid phone error")
    
    static let emptyPasswordError = NSLocalizedString( "Please enter password", comment: "Empty password error")
    static func inValidPasswordError(length: Int) -> String {
        NSLocalizedString("Password should contains atleast \(length) characters", comment: "Invalid password length error")
    }
    
    static let emptyConfPasswordError = NSLocalizedString( "Please enter confirm password", comment: "Empty password error")
    
    static let inValidConfirmPasswordError = NSLocalizedString( "New password and confirm password must be same", comment: "Empty password error")
    
    static let emptyPhoneError = NSLocalizedString("Please enter mobile number", comment: "Invalid phone error")
    static func invalidPhoneLengthError(length: Int) -> String {
        NSLocalizedString("Mobile number should contains atleast \(length) characters", comment: "Invalid phone length error")
    }
    static let invalidMobileNoError = NSLocalizedString("Please enter valid mobile number", comment: "Invalid phone length error")
    
    static let emptyFlatBlockError = "Please enter flat/ block number"
    static let emptyStreetName = "Please enter street/ society name"
    static let emptyLandMark = "Please enter landmark"
//    static let emptyPincode = "Please enter pincode"
    
    static let emptyProfile = "Please select profile picture."
    
    static let uploadPartnerShipDeed = "Please upload partner ship deed"
    static let uploadDrugLicence = "Please upload drug licence"
    static let uploadAdharCard = "Please upload adhar card"
    static let uploadFrontAdharCard = "Please upload front side of adhar card"
    static let uploadBackAdharCard = "Please upload back side of adhar card"
    static let uploadPanCard = "Please upload pan card"
    static let uploadOwnerPhoto = "Please upload owner photo"
    
    static let enterOtp = NSLocalizedString("Please enter otp", comment: "Empty otp error")
    static let enterEmailOtp = "Please enter email otp"
    static let enterMobileOtp = "Please enter mobile otp"
    
    static let emptyUserAvtarImageError = NSLocalizedString("Please select user image", comment: "Empty user image error")
    static let cameraNotAvailableError = NSLocalizedString("No camera available", comment: "No camera available")
    
    static let setDate = "Please set date."
    static let setTime = "Please set time."
    
    static let cancelOrderReasonEmptyError = "Please enter reason"
    static func invalidCancelOrderReason(length: Int) -> String {
        "Reason should contains atleast \(length) characters"
    }
    
    static let noNetworkError = NSLocalizedString("Internet connection is not available, please check your connection.", comment: "No network alert message")
    
    static let networkLoadingMessage = NSLocalizedString("Loading Library..", comment: "Announcement loading alert message")
    static let dataLoadingMessage = NSLocalizedString("Loading your data", comment: "Data loading alert message")
    static let waitingForNetworkMessage = NSLocalizedString("You are offline. Waiting for Network", comment: "Data loading alert message")
    
    static let pleaseWaitMesage = NSLocalizedString("Please wait", comment: "More loading alert message")
    
    static let agreeTermsAndConditionMesssage = "Please agree to terms and condition."
    static let memberShipUnderReviewMessage = "Your membership is under review We will get back in 24 hours."
    
    static let logoutConfirmationMessage = NSLocalizedString("Are you sure you want to logout?", comment: "Logout!")
    static let clearNotificationConfirmationMessage = "Are you sure you want to clear all notifications?"
    
    static let emptyPharmacyLogo = "Please upload pharmacy logo"
    static let emptyPharmacyName = "Please enter pharmacy name"
    static func enterValidPharmacyName(length: Int) -> String {
        "Pharmacy name should contains atleast \(length) characters"
    }
    static let emptyLatitude = "Enter latitude"
    static let emptyLongitude = "Enter longitude"
    static let emptyAddress = "Please enter address"
    static let emptyCountry = "Enter country"
    static let emptyState = "Enter state"
    static let emptyCity = "Enter city"
    static let emptyPincode = "Enter pincode"
    static let emptyShopOpenTime = "Enter shop open time"
    static let emptyShopCloseTime = "Enter shop close time"
    static let emptyLunchOpenTime = "Enter lunch open time"
    static let emptyLunchCloseTime = "Enter lunch close time"
    static let emptyDeliveryRange = "Please enter internal delivery range"
    static let inValidDeliveryRange = "Delivery range should be euqal to or more than 1 Km"
    
    static let hi = NSLocalizedString("Hi", comment: "Say hi to user in dashboard view")
    
    static let sourceTypeNotAvailabel = "Source type not available in this devise."
    
    static let clearOption = "Clear"
    
    ///Defined view title
    static let homeTitle = NSLocalizedString("Home", comment: "Home view title")
    
    static let myProfileTitle = NSLocalizedString("My Profile", comment: "My profile view title")
    static let otherUserProfileTitle = NSLocalizedString("Profile", comment: "Other user profile view title")
    
    static let doneButtonTitle = NSLocalizedString("Done", comment: "Done button title")
    
    static let resumeSurvey = NSLocalizedString("Resume", comment: "Resume survey")
    static let videoContent = NSLocalizedString("Video", comment: "Video content")
    static let photoContent = NSLocalizedString("Photo", comment: "Photo content")
    
    static let editProfileButtonTitle = NSLocalizedString("Edit", comment: "Edit profile button title")
    static let cameraOptionTitle = NSLocalizedString("Choose an option", comment: "Camera option title")
    static let cameraOption = NSLocalizedString("Camera", comment: "Capture image from camera")
    static let galleryOption = NSLocalizedString("Photos", comment: "Choose image from gallery")
    static let pdfOption = NSLocalizedString("Pdf Document", comment: "Choose pdf from document picker")
    static let cancelOption = NSLocalizedString("Cancel", comment: "Cancel option")
    static let saveOption = NSLocalizedString("Save", comment: "Save option")
    static let okConfirmation = NSLocalizedString("Ok", comment: "Ok confirmation")
    static let yesConfirmation = NSLocalizedString("Yes", comment: "Yes confirmation")
    static let noConfirmation = NSLocalizedString("No", comment: "No confirmation")
    static let allContents = NSLocalizedString("All Contents", comment: "All type of content")
    static let docContents = NSLocalizedString("Documents", comment: "Document type of content")
    static let imageContents = NSLocalizedString("Images", comment: "Image type of content")
    static let linkContents = NSLocalizedString("Links", comment: "Link type of content")
    static let selectOption = NSLocalizedString("Select Option", comment: "Select option title")
    static func appVersion(version: String?) -> String {
        return NSLocalizedString("App v\(version ?? "")", comment: "App version to be displayed")
    }
    
    static let noDataFound = "No data found"
    
    static func shareText() -> String {
        var msg = "Download the My Health Chart App from here:- "
        msg += "\n\nhttps://myhealthchart.in/apps/download.php"
        //msg += "https://apps.apple.com/us/app/my-health-chart/id1557872134"
        msg += "\n\n"
        msg += "- Use my referral code:- "
        msg += UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.referralCode) as! String
        return msg
    }
    
    /// dd MMM, yyyy  =  17 Jun, 2020
    static let appDateFormat = "dd MMM, yyyy"
    /// yyyy-MM-dd HH:mm:ss = 2020-06-17 20:05:45
    static let serverDateFormat = "yyyy-MM-dd HH:mm:ss"
    static let dateOnlyFormat = "yyyy-MM-dd"
    static let timeOnlyFormat = "hh:mma"
    
    static let chooseDateTitle = "Choose Date"
    static let chooseTimeTitle = "Choose Time"
    
    static let alertTitle = NSLocalizedString("Alert", comment: "Alert Title")
    
    static let autoLoginKey = "isLogin"
    
    static let cameraPermission = "My Pharmacy wants camera permission to capure and upload invoice and your profile photos."
    
    static let appStoreLink = "https://apps.apple.com/us/app/my-health-chart/id1557872134"
    
    // Order Module constants
    static let freeOrder = "free"
    static let standardOrder = "standard"
    static let expressOrder = "express"
    
    /* Assets constants */
    static let loaderGif = "loader"
    
    static let comingSoon = "This feature will soon be available for your city, stay tuned for latest updates"
}
