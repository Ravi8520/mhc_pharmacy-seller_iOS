//
//  PharmacyDetailValidation.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 13/11/21.
//

import UIKit

var strhtmlForm = ""

extension PharmacyDetailsVC {
    
    
    func validateForm() {
        
        var isValidPharmacyName = false
        var isValidLatitude = false
        var isValidLongitude = false
        var isValidAddress = false
        var isValidCountry = false
        var isValidState = false
        var isValidCity = false
        var isValidPincode = false
        
        var isValidDeliveryRange = true
        
        var isValidShopOpenTime = false
        var isValidShopCloseTime = false
        
        var isValidLunchOpenTime = true
        var isValidLunchCloseTime = true
        var isValidSundayShopOpenTime = true
        var isValidSundayShopCloseTime = true
        var isValidSundayLunchOpenTime = true
        var isValidSundayLunchCloseTime = true
        
        if logoData == nil {
            AlertHelper.shared.showToast(message: Strings.emptyPharmacyLogo)
            return
        }
        
        if textfieldPharmacyName.text!.isEmpty {
            textfieldPharmacyName.errorMessage = Strings.emptyPharmacyName
        } else if textfieldPharmacyName.text!.count < Validation.minNameLength {
            textfieldPharmacyName.errorMessage = Strings.enterValidPharmacyName(length: Validation.minNameLength)
        } else {
            textfieldPharmacyName.errorMessage = nil
            isValidPharmacyName = true
        }
        
        if textfieldLatitude.text!.isEmpty {
            textfieldLatitude.errorMessage = Strings.emptyLatitude
        } else {
            textfieldLatitude.errorMessage = nil
            isValidLatitude = true
        }
        
        if textfieldLongitude.text!.isEmpty {
            textfieldLongitude.errorMessage = Strings.emptyLongitude
        } else {
            textfieldLongitude.errorMessage = nil
            isValidLongitude = true
        }
        
        if textfieldAddress.text!.isEmpty {
            textfieldAddress.errorMessage = Strings.emptyAddress
        } else {
            textfieldAddress.errorMessage = nil
            isValidAddress = true
        }
        
        if textfieldCountry.text!.isEmpty {
            textfieldCountry.errorMessage = Strings.emptyCountry
        } else {
            textfieldCountry.errorMessage = nil
            isValidCountry = true
        }
        
        if textfieldState.text!.isEmpty {
            textfieldState.errorMessage = Strings.emptyState
        } else {
            textfieldState.errorMessage = nil
            isValidState = true
        }
        
        if textfieldCity.text!.isEmpty {
            textfieldCity.errorMessage = Strings.emptyCity
        } else {
            textfieldCity.errorMessage = nil
            isValidCity = true
        }
        
        if textfieldPincode.text!.isEmpty {
            textfieldPincode.errorMessage = Strings.emptyPincode
        } else {
            textfieldPincode.errorMessage = nil
            isValidPincode = true
        }
        
        if !textfieldRangeOfDelivery.isHidden {
            if textfieldRangeOfDelivery.text!.isEmpty {
                textfieldRangeOfDelivery.errorMessage = Strings.emptyDeliveryRange
                isValidDeliveryRange = false
            } else if Double(textfieldRangeOfDelivery.text ?? "0") ?? 0 < 1 {
                textfieldRangeOfDelivery.errorMessage = Strings.inValidDeliveryRange
                isValidDeliveryRange = false
            } else {
                textfieldRangeOfDelivery.errorMessage = nil
                isValidDeliveryRange = true
            }
        }
        
//        if selectedProvideInternalDelivery == 0 {
//            if textfieldRangeOfDelivery.text!.isEmpty {
//                textfieldRangeOfDelivery.errorMessage = Strings.emptyDeliveryRange
//                isValidDeliveryRange = false
//            } else {
//                textfieldRangeOfDelivery.errorMessage = nil
//                isValidDeliveryRange = true
//            }
//        }
        
        if textfieldShopOpenTime.text!.isEmpty {
            textfieldShopOpenTime.errorMessage = Strings.emptyShopOpenTime
        } else {
            textfieldShopOpenTime.errorMessage = nil
            isValidShopOpenTime = true
        }
        
        if textfieldShopCloseTime.text!.isEmpty {
            textfieldShopCloseTime.errorMessage = Strings.emptyShopCloseTime
        } else {
            textfieldShopCloseTime.errorMessage = nil
            isValidShopCloseTime = true
        }
        
        if selectedTakingRegularLunch == 0 {
            
            if textfieldTakingRegularLunchOpenTime.text!.isEmpty {
                textfieldTakingRegularLunchOpenTime.errorMessage = Strings.emptyLunchOpenTime
                isValidLunchOpenTime = false
            } else {
                textfieldTakingRegularLunchOpenTime.errorMessage = nil
                isValidLunchOpenTime = true
            }
            
            if textfieldTakingRegularLunchCloseTime.text!.isEmpty {
                textfieldTakingRegularLunchCloseTime.errorMessage = Strings.emptyLunchCloseTime
                isValidLunchCloseTime = false
            } else {
                textfieldTakingRegularLunchCloseTime.errorMessage = nil
                isValidLunchCloseTime = true
            }
        }
        
        if selectedOpenOnSunday == 0 && selectedSundayTimingOption == 1 {
            
            if textfieldSundayShopOpenTime.text!.isEmpty {
                textfieldSundayShopOpenTime.errorMessage = Strings.emptyShopOpenTime
                isValidSundayShopOpenTime = false
            } else {
                textfieldSundayShopOpenTime.errorMessage = nil
                isValidSundayShopOpenTime = true
            }
            
            if textfieldSundayShopClosingTime.text!.isEmpty {
                textfieldSundayShopClosingTime.errorMessage = Strings.emptyShopCloseTime
                isValidSundayShopCloseTime = false
            } else {
                textfieldSundayShopClosingTime.errorMessage = nil
                isValidSundayShopCloseTime = true
            }
            
            if selectedSundayLunchTime == 0 {
                
                if textfieldSundayLunchOpenTime.text!.isEmpty {
                    textfieldSundayLunchOpenTime.errorMessage = Strings.emptyLunchOpenTime
                    isValidSundayLunchOpenTime = false
                } else {
                    textfieldSundayLunchOpenTime.errorMessage = nil
                    isValidSundayLunchOpenTime = true
                }
                
                if textfieldSundayLunchCloseTime.text!.isEmpty {
                    textfieldSundayLunchCloseTime.errorMessage = Strings.emptyLunchCloseTime
                    isValidSundayLunchCloseTime = false
                } else {
                    textfieldSundayLunchOpenTime.errorMessage = nil
                    isValidSundayLunchCloseTime = true
                }
                
            }
            
        }
        
        var sundayOpenTime = ""
        var sundayCloseTime = ""
        var sundayLunchOpenTime = ""
        var sundayLunchCloseTime = ""
        
        if selectedOpenOnSunday == 0 {
            
            sundayOpenTime = selectedSundayTimingOption == 0 ? textfieldShopOpenTime.text! :
            textfieldSundayShopOpenTime.text ?? ""
            sundayCloseTime = selectedSundayTimingOption == 0 ? textfieldShopCloseTime.text! :
            textfieldSundayShopClosingTime.text ?? ""
            
            if selectedSundayLunchTime == 0 || selectedSundayTimingOption == 0 {
                
                sundayLunchOpenTime = selectedSundayTimingOption == 0 ? textfieldTakingRegularLunchOpenTime.text ?? "" :
                textfieldSundayLunchOpenTime.text ?? ""
                sundayLunchCloseTime = selectedSundayTimingOption == 0 ? textfieldTakingRegularLunchCloseTime.text ?? "" :  textfieldSundayLunchCloseTime.text ?? ""
                
            }
            
        }
        
        if isValidPharmacyName &&
            isValidLatitude &&
            isValidLongitude &&
            isValidAddress &&
            isValidCountry &&
            isValidState &&
            isValidCity &&
            isValidPincode &&
            isValidDeliveryRange &&
            isValidShopOpenTime &&
            isValidShopCloseTime &&
            isValidLunchOpenTime &&
            isValidLunchCloseTime &&
            isValidSundayShopOpenTime &&
            isValidSundayShopCloseTime &&
            isValidSundayLunchOpenTime &&
            isValidSundayLunchCloseTime {
            
            let pharmacyDetailData = PharmacyDetail(
                logoData: logoData!,
                apiToken: loginResponse?.apiToken ?? "",
                userId: loginResponse?.userId ?? 0,
                pharmacyName: textfieldPharmacyName.text!,
                latitude: textfieldLatitude.text!,
                longitude: textfieldLongitude.text!,
                address: textfieldAddress.text!,
                country: "\(selectedCountryId)",
                state: "\(selectedStateId)",
                city: "\(selectedCityId)",
                pincode: "\(selectedPincodeId)",
                internalDeliveryRange: textfieldRangeOfDelivery.text ?? "",
                minDiscount: textfieldMinimumDiscount.text ?? "",
                maxDiscount: textfieldMaximumDiscount.text ?? "",
                discountTermsAndCond: textfieldTermsAndCondition.text ?? "",
                shopOpenTime: DateHelper.shared.get24HourTime(
                    fromTime: textfieldShopOpenTime.text!
                ),
                shopCloseTime: DateHelper.shared.get24HourTime(
                    fromTime: textfieldShopCloseTime.text!
                ),
                lunchOpenTime: DateHelper.shared.get24HourTime(
                    fromTime: selectedTakingRegularLunch == 0 ? textfieldTakingRegularLunchOpenTime.text ?? "" : ""
                ),
                lunchCloseTime: DateHelper.shared.get24HourTime(
                    fromTime: selectedTakingRegularLunch == 0 ? textfieldTakingRegularLunchCloseTime.text ?? "" : ""
                ),
                sundayOpenTime: DateHelper.shared.get24HourTime(
                    fromTime: sundayOpenTime
                ),
                sundayCloseTime: DateHelper.shared.get24HourTime(
                    fromTime: sundayCloseTime
                ),
                sundayLunchOpenTime: DateHelper.shared.get24HourTime(
                    fromTime: sundayLunchOpenTime
                ),
                sundayLunchCloseTime: DateHelper.shared.get24HourTime(
                    fromTime: sundayLunchCloseTime
                )
            )
        
            submitPharmacyDetail()
         
        }
        
    }
    
     func submitPharmacyDetail() {
         var sundayOpenTime = ""
         var sundayCloseTime = ""
         var sundayLunchOpenTime = ""
         var sundayLunchCloseTime = ""
         
         if selectedOpenOnSunday == 0 {
             
             sundayOpenTime = selectedSundayTimingOption == 0 ? textfieldShopOpenTime.text! :
             textfieldSundayShopOpenTime.text ?? ""
             sundayCloseTime = selectedSundayTimingOption == 0 ? textfieldShopCloseTime.text! :
             textfieldSundayShopClosingTime.text ?? ""
             
             if selectedSundayLunchTime == 0 || selectedSundayTimingOption == 0 {
                 
                 sundayLunchOpenTime = selectedSundayTimingOption == 0 ? textfieldTakingRegularLunchOpenTime.text ?? "" :
                 textfieldSundayLunchOpenTime.text ?? ""
                 sundayLunchCloseTime = selectedSundayTimingOption == 0 ? textfieldTakingRegularLunchCloseTime.text ?? "" :  textfieldSundayLunchCloseTime.text ?? ""
                 
             }
             
         }
            let param = [
            Parameter.apiToken: loginResponse?.apiToken ?? "",
            Parameter.id: "\(loginResponse?.userId ?? 0)",
            Parameter.pharmacyName: textfieldPharmacyName.text!,
            Parameter.latitude: textfieldLatitude.text!,
            Parameter.longitude: textfieldLongitude.text!,
            Parameter.address: textfieldAddress.text!,
            Parameter.country: "\(selectedCountryId)",
            Parameter.state: "\(selectedStateId)",
            Parameter.city: "\(selectedCityId)",
            Parameter.pincode: "\(selectedPincodeId)",
            Parameter.internalDeliveryRange: textfieldRangeOfDelivery.text ?? "",
            Parameter.minDiscount: textfieldMinimumDiscount.text ?? "",
            Parameter.maxDiscount: textfieldMaximumDiscount.text ?? "",
            Parameter.discountTermsAndCond: textfieldTermsAndCondition.text ?? "",
            Parameter.provide_delivery_choice: "\(selectedProvideInternalDelivery)",
            Parameter.shopOpenTime: DateHelper.shared.get24HourTime(
                fromTime: textfieldShopOpenTime.text!
            ),
            Parameter.shopCloseTime: DateHelper.shared.get24HourTime(
                fromTime: textfieldShopCloseTime.text!
            ),
            Parameter.lunchOpenTime: DateHelper.shared.get24HourTime(
                fromTime: selectedTakingRegularLunch == 0 ? textfieldTakingRegularLunchOpenTime.text ?? "" : ""
            ),
            Parameter.lunchCloseTime: DateHelper.shared.get24HourTime(
                fromTime: selectedTakingRegularLunch == 0 ? textfieldTakingRegularLunchCloseTime.text ?? "" : ""
            ),
            Parameter.sundayOpenTime: sundayOpenTime,
            Parameter.sundayCloseTime: sundayCloseTime,
            Parameter.sundayLunchOpenTime: sundayLunchOpenTime,
            Parameter.sundayLunchCloseTime: sundayLunchCloseTime
        ]
        
        let logo = FileData(
            data: logoData!.image!.jpegData(compressionQuality: 0.7)!,
            mimeType: .jpeg,
            key: Parameter.pharmacyLogo
        )
        
        Networking.request(
            url: Urls.addPharmacyDetail,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: [logo],
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
        
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let pharmacyDetailResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: AgreementApiResponse.self)
                    
                    guard let pdResponse = pharmacyDetailResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if pdResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(
                            message: pdResponse.message!,
                            duration: .normal
                        ) { [self] in
                            
                            strhtmlForm = pdResponse.data?.agreement ?? ""
                            
                            if Parameter.is_agreement {
                                navigateToAgreement()
                            }
                            else {
                                self.navigationController?.pushViewController(
                                    ThankyouVC.instantiate(),
                                    animated: false
                                )
                            }
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: pdResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    func navigateToAgreement() {
        let vc = AgreementVC.instantiate()
        vc.apiToken = loginResponse?.apiToken ?? ""
        vc.userId = loginResponse?.userId ?? 0
        vc.webView = strhtmlForm
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
