//
//  EditProfileVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 01/10/21.
//

import UIKit

protocol ProfileUpdateDelegate {
    func profileUpdated()
}

extension EditProfileVC {
    static func instantiate() -> EditProfileVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: EditProfileVC.self)) as! EditProfileVC
    }
}

class EditProfileVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var imageViewPharmacyLogo: UIImageView!
    
    @IBOutlet weak var textfieldMinimumDiscount: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldMaximumDiscount: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldDeliveryRange: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldTermsAndCondition: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldShopOpenTime: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldShopCloseTime: SkyFloatingLabelTextField!
    
    @IBOutlet var btnRegularLunchYesNo: [UIButton]!
    @IBOutlet weak var stackViewTakingRegularLunch: UIStackView!
    
    @IBOutlet var btnOpenOnSundayYesNo: [UIButton]!
    @IBOutlet weak var stackViewSundayOpenCloseTimeOption: UIStackView!
    @IBOutlet var btnSundayTimingOption: [UIButton]!
    @IBOutlet weak var stackViewSundayTiming: UIStackView!
    @IBOutlet weak var textfieldSundayShopOpenTime: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldSundayShopClosingTime: SkyFloatingLabelTextField!
    
    @IBOutlet var btnSundayLunchYesNo: [UIButton]!
    @IBOutlet weak var stackViewSundayLunchTime: UIStackView!
    @IBOutlet weak var textfieldSundayLunchOpenTime: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldSundayLunchCloseTime: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldLunchOpenTime: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldLunchCloseTime: SkyFloatingLabelTextField!
    
    var userData: GetProfileDataApiResponse?
    var delegate: ProfileUpdateDelegate?
    
    var selectedTakingRegularLunch = 1
    var selectedOpenOnSunday = 1
    var selectedSundayTimingOption = 0
    var selectedSundayLunchTime = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        imageViewPharmacyLogo.setCornerRadius(isMaskedToBound: true)
        uiViewToolBar.labelTitle.text = "Edit Profile"
        uiViewToolBar.btnSearch.isHidden = true
        setUpDelegates()
        setupEditMode()
    
    }
    
    private func setUpDelegates() {
        uiViewToolBar.delegate = self
    }
    
    private func setupRangeTextfield() {
        
    }

    @IBAction func btnProfileUploadPressed(_ sender: UIButton) {
        MediaPicker.shared.chooseOptionForMediaType(delegate: self)
    }
    
    @IBAction func btnFullScreenPressed(_ sender: UIButton) {
        if let img = imageViewPharmacyLogo.image {
            let vc = FullScreenVC.instantiate()
            vc.image = img
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSelectShopOpenTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            YesActionTitle: Strings.doneButtonTitle,
            NoActionTitle: Strings.cancelOption,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { timeString in
                //textfield
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnRegularLunchYesNoPressed(_ sender: UIButton) {
        
        selectedTakingRegularLunch = sender.tag
        
        for btns in btnRegularLunchYesNo {
            if btns.tag == selectedTakingRegularLunch {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        
        if selectedTakingRegularLunch == 1 {
            stackViewTakingRegularLunch.isHidden = true
            textfieldLunchOpenTime.text = nil
            textfieldLunchCloseTime.text = nil
        } else {
            stackViewTakingRegularLunch.isHidden = false
        }
        
    }
    
    @IBAction func btnOpenOnSundayYesNoPressed(_ sender: UIButton) {
        
        selectedOpenOnSunday = sender.tag
        
        for btns in btnOpenOnSundayYesNo {
            if btns.tag == selectedOpenOnSunday {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        
        if selectedOpenOnSunday == 1 {
            stackViewSundayOpenCloseTimeOption.isHidden = true
            textfieldSundayShopOpenTime.text = nil
            textfieldSundayShopClosingTime.text = nil
            textfieldSundayLunchOpenTime.text = nil
            textfieldSundayLunchCloseTime.text = nil
        } else {
            stackViewSundayOpenCloseTimeOption.isHidden = false
            btnSundayTimingOptionPressed(btnSundayTimingOption[0])
        }
        
    }
    
    @IBAction func btnSundayTimingOptionPressed(_ sender: UIButton) {
        
        selectedSundayTimingOption = sender.tag
        
        for btns in btnSundayTimingOption {
            if btns.tag == selectedSundayTimingOption {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        
        if selectedSundayTimingOption == 0 {
            stackViewSundayTiming.isHidden = true
            textfieldSundayShopOpenTime.text = nil
            textfieldSundayShopClosingTime.text = nil
            textfieldSundayLunchOpenTime.text = nil
            textfieldSundayLunchCloseTime.text = nil
        } else {
            stackViewSundayTiming.isHidden = false
        }
        
    }
    
    @IBAction func btnSundayLunchYesNoPressed(_ sender: UIButton) {
        
        selectedSundayLunchTime = sender.tag
        
        for btns in btnSundayLunchYesNo {
            if btns.tag == selectedSundayLunchTime {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        
        if selectedSundayLunchTime == 1 {
            stackViewSundayLunchTime.isHidden = true
        } else {
            stackViewSundayLunchTime.isHidden = false
            textfieldSundayLunchOpenTime.text = nil
            textfieldSundayLunchCloseTime.text = nil
        }
        
    }
    
    @IBAction func btnRegularShopOpenTime(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldShopOpenTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnShopCloseTime(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldShopCloseTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnRegularLunchOpenTime(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldLunchOpenTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnRegularLunchCloseTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldLunchCloseTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnSundayShopOpenTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldSundayShopOpenTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnSundayShopCloseTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldSundayShopClosingTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnSundayLunchOpenTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldSundayLunchOpenTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnSundayLunchCloseTimePressed(_ sender: UIButton) {
        
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            minimumDate: nil,
            maximumDate: nil,
            YesAction: { [self] timeString in
                textfieldSundayLunchCloseTime.text = timeString
            },
            NoAction: nil
        )
        
    }
    
    @IBAction func btnUpdatePressed(_ sender: HalfCornerButton) {
        validateForm()
    }
    
}

extension EditProfileVC {
    
    private func validateForm() {
        
        var isValidDeliveryRange = true
        
        var isValidShopOpenTime = false
        var isValidShopCloseTime = false
        
        var isValidLunchOpenTime = true
        var isValidLunchCloseTime = true
        var isValidSundayShopOpenTime = true
        var isValidSundayShopCloseTime = true
        var isValidSundayLunchOpenTime = true
        var isValidSundayLunchCloseTime = true

        
//        if textfieldDeliveryRange.text!.isEmpty {
//            textfieldDeliveryRange.errorMessage = Strings.emptyDeliveryRange
//            isValidDeliveryRange = false
//        } else {
//            textfieldDeliveryRange.errorMessage = nil
//            isValidDeliveryRange = true
//        }
        
        if !textfieldDeliveryRange.isHidden {
            if textfieldDeliveryRange.text!.isEmpty {
                textfieldDeliveryRange.errorMessage = Strings.emptyDeliveryRange
                isValidDeliveryRange = false
            } else if Double(textfieldDeliveryRange.text ?? "0") ?? 0 < 1 {
                textfieldDeliveryRange.errorMessage = Strings.inValidDeliveryRange
                isValidDeliveryRange = false
            } else {
                textfieldDeliveryRange.errorMessage = nil
                isValidDeliveryRange = true
            }
        }
        
        
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
            
            if textfieldLunchOpenTime.text!.isEmpty {
                textfieldLunchOpenTime.errorMessage = Strings.emptyLunchOpenTime
                isValidLunchOpenTime = false
            } else {
                textfieldLunchOpenTime.errorMessage = nil
                isValidLunchOpenTime = true
            }
            
            if textfieldLunchCloseTime.text!.isEmpty {
                textfieldLunchCloseTime.errorMessage = Strings.emptyLunchCloseTime
                isValidLunchCloseTime = false
            } else {
                textfieldLunchCloseTime.errorMessage = nil
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
        
        if isValidShopOpenTime &&
            isValidShopCloseTime &&
            isValidLunchOpenTime &&
            isValidLunchCloseTime &&
            isValidSundayShopOpenTime &&
            isValidSundayShopCloseTime &&
            isValidSundayLunchOpenTime &&
            isValidSundayLunchCloseTime &&
            isValidDeliveryRange {
            
            editProfile()
            
        }
        
    }
    
    private func setupEditMode() {
        
        guard let data = userData else { return }
        
        imageViewPharmacyLogo.loadImageFromUrl(
            urlString: data.phamacyLogo ?? "",
            placeHolder: nil
        )
        
        if let minDiscount = data.discountMin {
            
            if minDiscount == "0" {
                textfieldMinimumDiscount.text = nil
            } else {
                textfieldMinimumDiscount.text = minDiscount
            }
        }
        
        if let maxDiscount = data.discountMax {
            if maxDiscount == "0" {
                textfieldMaximumDiscount.text = nil
            } else {
                textfieldMaximumDiscount.text = maxDiscount
            }
        }
        
        let allowedDeliveryType = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.allowedDeliveryType) as? String
        
        if let allowedDeliveryType = allowedDeliveryType {
            
            if allowedDeliveryType == DeliveryType.internald.serverString ||
                allowedDeliveryType == DeliveryType.both.serverString {
                
                if let deliveryRange = data.deliveryRange {
                    if deliveryRange.isEmpty {
                        textfieldDeliveryRange.isHidden = true
                    } else {
                        textfieldDeliveryRange.isHidden = false
                        textfieldDeliveryRange.text = deliveryRange
                    }
                    
                } else {
                    textfieldDeliveryRange.isHidden = true
                }
                
            } else {
                textfieldDeliveryRange.isHidden = true
            }
            
        } else {
            textfieldDeliveryRange.isHidden = true
        }
        
        textfieldTermsAndCondition.text = nil
        
        textfieldShopOpenTime.text = DateHelper.shared.convertAppTime(
            serverTime: data.pharmacyOpenTime
        )
        textfieldShopCloseTime.text = DateHelper.shared.convertAppTime(
            serverTime: data.pharmacyCloseTime
        )
        
        if let lunchOpenTime = data.lunchOpenTime,
           let lunchCloseTime = data.lunchCloseTime {
            
            if lunchOpenTime.isEmpty {
                btnRegularLunchYesNoPressed(btnRegularLunchYesNo[1])
            } else {
                btnRegularLunchYesNoPressed(btnRegularLunchYesNo[0])
                textfieldLunchOpenTime.text = DateHelper.shared.convertAppTime(serverTime: lunchOpenTime)
                textfieldLunchCloseTime.text = DateHelper.shared.convertAppTime(serverTime: lunchCloseTime)
            }
            
        } else {
            btnRegularLunchYesNoPressed(btnRegularLunchYesNo[1])
        }
    
        if let sundayOpenTime = data.sundayOpenTime,
           let sundayCloseTime = data.sundayCloseTime {

            
            if sundayOpenTime.isEmpty {
                //labelOpenOnSundayYesNo.text = "No"
                btnOpenOnSundayYesNoPressed(btnOpenOnSundayYesNo[1])
                
            } else {
                //labelOpenOnSundayYesNo.text = "Yes"
                btnOpenOnSundayYesNoPressed(btnOpenOnSundayYesNo[0])
                
                if let sundayLunchOpenTime = data.sundayLunchOpenTime,
                   let sundayLunchCloseTime = data.sundayLunchCloseTime {

                    if sundayOpenTime == data.pharmacyOpenTime &&
                        sundayCloseTime == data.pharmacyCloseTime &&
                        sundayLunchOpenTime == data.sundayLunchOpenTime &&
                        sundayLunchCloseTime == data.sundayLunchCloseTime {

                        //labelAsperMondayToSaturday.text = "As per Monday to Saturday"

                        btnSundayTimingOptionPressed(btnSundayTimingOption[0])
                        
                    } else {

                        btnSundayTimingOptionPressed(btnSundayTimingOption[1])
                        
                        textfieldSundayShopOpenTime.text = DateHelper.shared.convertAppTime(serverTime: sundayOpenTime)
                        textfieldSundayShopClosingTime.text = DateHelper.shared.convertAppTime(serverTime: sundayCloseTime)
                        
                        if sundayLunchOpenTime.isEmpty {
                            btnSundayLunchYesNoPressed(btnSundayLunchYesNo[1])
                        } else {
                            btnSundayLunchYesNoPressed(btnSundayLunchYesNo[0])
                            textfieldSundayLunchOpenTime.text = DateHelper.shared.convertAppTime(serverTime: sundayLunchOpenTime)
                            textfieldSundayLunchCloseTime.text = DateHelper.shared.convertAppTime(serverTime: sundayLunchCloseTime)
                        }
          
                    }
                }
            }
        }
        
    }
    
    private func editProfile() {

//        Parameter.pharmacyLogo
        
        var sundayOpenTime = ""
        var sundayCloseTime = ""
        var sundayLunchOpenTime = ""
        var sundayLunchCloseTime = ""
        
        if selectedOpenOnSunday == 0 {
            
            sundayOpenTime = selectedSundayTimingOption == 0 ? textfieldShopOpenTime.text ?? "" :
            textfieldSundayShopOpenTime.text ?? ""
            sundayCloseTime = selectedSundayTimingOption == 0 ? textfieldShopCloseTime.text ?? "" :
            textfieldSundayShopClosingTime.text ?? ""
            
            if selectedSundayLunchTime == 0 || selectedSundayTimingOption == 0 {
                sundayLunchOpenTime = selectedSundayTimingOption == 0 ? textfieldLunchOpenTime.text ?? "" :
                textfieldSundayLunchOpenTime.text ?? ""
                sundayLunchCloseTime = selectedSundayTimingOption == 0 ? textfieldLunchCloseTime.text ?? "" :  textfieldSundayLunchCloseTime.text ?? ""
            }
            
        }
        
        let param = [
            Parameter.pharmacyName: "",
            Parameter.internalDeliveryRange: textfieldDeliveryRange.text ?? "",
            Parameter.minDiscount: textfieldMinimumDiscount.text ?? "",
            Parameter.maxDiscount: textfieldMaximumDiscount.text ?? "",
            Parameter.discountTermsAndCond: textfieldTermsAndCondition.text ?? "",
            Parameter.shopOpenTime: DateHelper.shared.get24HourTime(
                fromTime: textfieldShopOpenTime.text ?? ""
            ),
            Parameter.shopCloseTime: DateHelper.shared.get24HourTime(
                fromTime:textfieldShopCloseTime.text ?? ""
            ),
            Parameter.lunchOpenTime: selectedTakingRegularLunch == 0 ?
            DateHelper.shared.get24HourTime(
                fromTime:textfieldLunchOpenTime.text ?? ""
            ) : "",
            Parameter.lunchCloseTime: selectedTakingRegularLunch == 0 ? DateHelper.shared.get24HourTime(
                fromTime: textfieldLunchCloseTime.text ?? ""
            ) : "",
            Parameter.sundayOpenTime: DateHelper.shared.get24HourTime(
                fromTime: sundayOpenTime
            ),
            Parameter.sundayCloseTime: DateHelper.shared.get24HourTime(
                fromTime: sundayCloseTime
            ),
            Parameter.sundayLunchOpenTime: DateHelper.shared.get24HourTime(
                fromTime: sundayLunchOpenTime
            ),
            Parameter.sundayLunchCloseTime: DateHelper.shared.get24HourTime(
                fromTime: sundayLunchCloseTime
            )
        ]
        
        var pharmacyLogo: FileData?
        
        if let image = imageViewPharmacyLogo.image {
            pharmacyLogo = FileData(
                data: image.jpegData(compressionQuality: 0.7)!,
                mimeType: .jpeg,
                key: Parameter.pharmacyLogo
            )
        }
        
        
        
        Networking.request(
            url: Urls.editPharmacyProfile,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: pharmacyLogo == nil ? nil : [pharmacyLogo!],
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
        
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let commonResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let cmResponse = commonResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if cmResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(
                            message: cmResponse.message!,
                            duration: .normal
                        ) { [self] in
                            
                            delegate?.profileUpdated()
                            btnBackPressed()
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: cmResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
}

extension EditProfileVC: ToolBarDelegate, MediaPickerDelegate {
    
    func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func mediaPicked(media: MediaData) {
        imageViewPharmacyLogo.image = media.image
    }
    
}
