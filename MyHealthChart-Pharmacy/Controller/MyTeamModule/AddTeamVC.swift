//
//  AddTeamVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jatan Ambasana on 06/10/21.
//

import UIKit

@objc protocol AddTeamDelegate {
    @objc optional func memberUpdated(view: UIViewController)
    @objc optional func memberAdded(view: UIViewController)
}

extension AddTeamVC {
    static func instantiate() -> AddTeamVC {
        StoryBoardConstants.myTeam.instantiateViewController(withIdentifier: String(describing: AddTeamVC.self)) as! AddTeamVC
    }
}

class AddTeamVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet var btnUserType: [UIButton]!
    
    @IBOutlet weak var stackViewUserType: UIStackView!
    
    @IBOutlet weak var textfieldName: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldMobileNo: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldConfPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldBlockNo: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldSocietyName: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldLandmark: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldPincode: SkyFloatingLabelTextField!
    
    @IBOutlet weak var uiViewPassword: UIView!
    @IBOutlet weak var uiViewConfPassword: UIView!
    
    
    @IBOutlet weak var btnEyePassword: UIButton!
    
    @IBOutlet weak var btnAddTeam: HalfCornerButton!
    
    var delegate: AddTeamDelegate?
    
    private var selectedUserType = 0
    
    private var profileData: MediaData?
    
    private var isNewPwdHidden = true
    private var isConfPwdHidden = true
    
    var editMode = false
    var teamDetailData: MyTeamDetailDataApiResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        
        imageViewProfile.setCornerRadius(isMaskedToBound: true)
        setupDelegates()
        
        if editMode {
            setupEditMode()
        } else {
            uiViewToolBar.labelTitle.text = "Add Person"
            btnAddTeam.setTitle("Add", for: .normal)
        }
        
        uiViewToolBar.btnSearch.isHidden = true
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        textfieldPincode.delegate = self
        textfieldMobileNo.delegate = self
    }
    
    @IBAction func btnFullScreenImagePressed(_ sender: UIButton) {
        if let img = imageViewProfile.image {
            let vc = FullScreenVC.instantiate()
            vc.image = img
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnUploadProfile(_ sender: UIButton) {
        MediaPicker.shared.chooseOptionForMediaType(delegate: self)
    }
    
    @IBAction func btnUserTypePressed(_ sender: UIButton) {
        selectedUserType = sender.tag
        
        for btns in btnUserType {
            if btns.tag == selectedUserType {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
    }
    
    @IBAction func btnEyePressed(_ sender: UIButton) {
        if sender == btnEyePassword {
            isNewPwdHidden = !isNewPwdHidden
            textfieldPassword.isSecureTextEntry = isNewPwdHidden
            sender.setImage(
                isNewPwdHidden ? #imageLiteral(resourceName: "ic_eye_grey") : #imageLiteral(resourceName: "ic_eye_blue") ,
                for: .normal
            )
        } else {
            isConfPwdHidden = !isConfPwdHidden
            textfieldConfPassword.isSecureTextEntry = isConfPwdHidden
            sender.setImage(
                isNewPwdHidden ?
                #imageLiteral(resourceName: "ic_eye_grey") :
                    #imageLiteral(resourceName: "ic_eye_blue") ,
                for: .normal
            )
        }
    }
    
    @IBAction func btnAddTeamMemberPressed(_ sender: HalfCornerButton) {
        validateForm()
    }
    
    private func setupEditMode() {
        uiViewToolBar.labelTitle.text = "Edit"
        btnAddTeam.setTitle("Update", for: .normal)
        stackViewUserType.isHidden = true
        
        guard let data = teamDetailData else { return }
        
        imageViewProfile.loadImageFromUrl(
            urlString: data.profile ?? "",
            placeHolder: UIImage(named: "ic_profile_placeholder")
        )
        
        textfieldName.text = data.name
        textfieldEmail.text = data.email
        textfieldMobileNo.text = data.mobileNo
        textfieldBlockNo.text = data.blockNo
        textfieldSocietyName.text = data.streetName
        textfieldLandmark.text = data.landmark
        textfieldPincode.text = data.pincode
        
        if AppConfig.userType == .seller {
            uiViewPassword.isHidden = true
            uiViewConfPassword.isHidden = true
            textfieldMobileNo.isUserInteractionEnabled = false
        }
        
    }
    
 
}

extension AddTeamVC {
    
    func validateForm() {
        
        var isValidName = false
        var isValidEmail = false
        var isValidMobileNo = false
        var isValidPwd = false
        var isValidConfPwd = false
        var isValidBlockNo = false
        var isValidStreetName = false
        var isValidLandmark = false
        var isValidPincode = false
        
        
        if textfieldName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            textfieldName.errorMessage = Strings.emptyFullNameError
        } else if textfieldName.text!.count < Validation.minNameLength {
            textfieldName.errorMessage = Strings.invalidNameError(length: Validation.minNameLength)
        } else {
            textfieldName.errorMessage = nil
            isValidName = true
        }
         
        if textfieldEmail.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            textfieldEmail.errorMessage = Strings.emptyEmailError
        } else if !Validation().isValidEmail(testStr: textfieldEmail.text!) {
            textfieldEmail.errorMessage = Strings.invalidEmailError
        } else {
            textfieldEmail.errorMessage = nil
            isValidEmail = true
        }
        
        if textfieldMobileNo.text!.isEmpty {
            textfieldMobileNo.errorMessage = Strings.emptyPhoneError
        } else if textfieldMobileNo.text!.count < Validation.maxMobileNoLength {
            textfieldMobileNo.errorMessage = Strings.invalidPhoneLengthError(
                length: Validation.maxMobileNoLength
            )
        } else {
            textfieldMobileNo.errorMessage = nil
            isValidMobileNo = true
        }
        
        if !editMode {
            
            if textfieldPassword.text!.isEmpty {
                textfieldPassword.errorMessage = Strings.emptyPasswordError
            } else if textfieldPassword.text!.count < Validation.minPwdLength {
                textfieldPassword.errorMessage = Strings.inValidPasswordError(length: Validation.minPwdLength)
            } else {
                textfieldPassword.errorMessage = nil
                isValidPwd = true
            }
            
            if textfieldConfPassword.text!.isEmpty {
                textfieldConfPassword.errorMessage = Strings.emptyConfPasswordError
            } else if textfieldPassword.text != textfieldConfPassword.text {
                textfieldConfPassword.errorMessage = Strings.inValidConfirmPasswordError
            } else {
                textfieldConfPassword.errorMessage = nil
                isValidConfPwd = true
            }
            
        } else {
            isValidPwd = true
            isValidConfPwd = true
        }
        
        if textfieldBlockNo.text!.isEmpty {
            textfieldBlockNo.errorMessage = Strings.emptyFlatBlockError
        } else {
            textfieldBlockNo.errorMessage = nil
            isValidBlockNo = true
        }
        
        if textfieldSocietyName.text!.isEmpty {
            textfieldSocietyName.errorMessage = Strings.emptyStreetName
        } else {
            textfieldSocietyName.errorMessage = nil
            isValidStreetName = true
        }
        
        if textfieldLandmark.text!.isEmpty {
            textfieldLandmark.errorMessage = Strings.emptyLandMark
        } else {
            textfieldLandmark.errorMessage = nil
            isValidLandmark = true
        }
        
        if textfieldPincode.text!.isEmpty {
            textfieldPincode.errorMessage = "Please \(Strings.emptyPincode.lowercased())"
        } else {
            textfieldPincode.errorMessage = nil
            isValidPincode = true
        }
        
        guard let _ = imageViewProfile.image else {
            AlertHelper.shared.showAlert(message: Strings.emptyProfile)
            return
        }
        
        if isValidName &&
        isValidEmail &&
        isValidMobileNo &&
        isValidPwd &&
        isValidConfPwd &&
        isValidBlockNo &&
        isValidStreetName &&
        isValidLandmark &&
        isValidPincode {
        
            if editMode {
                if AppConfig.userType == .seller {
                    editSeller()
                } else {
                    editMember()
                }
            } else {
                addMember()
            }
            
        }
        
        
    }
    
    private func editMember() {
        
        let param = [
            Parameter.userId: "\(teamDetailData!.id!)",
            Parameter.userType: teamDetailData!.userType!,
            Parameter.name: textfieldName.text!,
            Parameter.email: textfieldEmail.text!,
            Parameter.mobileNo: textfieldMobileNo.text!,
            Parameter.password: textfieldPassword.text!,
            Parameter.blockNo: textfieldBlockNo.text!,
            Parameter.streetName: textfieldSocietyName.text!,
            Parameter.landmark: textfieldLandmark.text!,
            Parameter.pincode: textfieldPincode.text!
        ]
        
        var imageData: FileData?
        
        if let image = imageViewProfile.image {
            imageData = FileData(
            data: image.jpegData(compressionQuality: 0.7)!,
            mimeType: .jpeg,
            key: Parameter.profile
            )
        }
        
        Networking.request(
            url: Urls.editTeamMember,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: imageData == nil ? nil : [imageData!],
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let commonResponse = NetworkHelper.decodeJsonData(
                        data: jsonData, decodeWith: CommonApiResponse.self
                    )
                    
                    guard let cmResponse = commonResponse else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if cmResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(
                            message: cmResponse.message!,
                            duration: .normal
                        ) { [self] in
                            
                            delegate?.memberUpdated?(view: self)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: cmResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(
                        message: error.localizedDescription
                    )
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func addMember() {
            
        let param = [
            Parameter.userType: selectedUserType == 0 ?
            UserType.seller.serverString :
                UserType.deliveryBoy.serverString,
            Parameter.name: textfieldName.text!,
            Parameter.email: textfieldEmail.text!,
            Parameter.mobileNo: textfieldMobileNo.text!,
            Parameter.password: textfieldPassword.text!,
            Parameter.blockNo: textfieldBlockNo.text!,
            Parameter.streetName: textfieldSocietyName.text!,
            Parameter.landmark: textfieldLandmark.text!,
            Parameter.pincode: textfieldPincode.text!
        ]
        
        var imageData: FileData?
        
        if let image = imageViewProfile.image {
            imageData = FileData(
                data: image.jpegData(compressionQuality: 0.7)!,
                mimeType: .jpeg,
                key: Parameter.profile
            )
        }
        
        Networking.request(
            url: Urls.addTeamMember,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: imageData == nil ? nil : [imageData!],
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
        
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let commonResponse = NetworkHelper.decodeJsonData(
                        data: jsonData,
                        decodeWith: CommonApiResponse.self
                    )
                    
                    guard let cmResponse = commonResponse else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if cmResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(
                            message: cmResponse.message!,
                            duration: .normal
                        ) { [self] in
                        
                            delegate?.memberAdded?(view: self)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: cmResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(
                        message: error.localizedDescription
                    )
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func editSeller() {
                
        let param = [
            Parameter.userId: "\(teamDetailData?.id ?? 0)",
            Parameter.name: textfieldName.text!,
            Parameter.email: textfieldEmail.text!,
            Parameter.mobileNo: textfieldMobileNo.text!,
            Parameter.blockNo: textfieldBlockNo.text!,
            Parameter.streetName: textfieldSocietyName.text!,
            Parameter.landmark: textfieldLandmark.text!,
            Parameter.pincode: textfieldPincode.text!
        ]
        
        var imageData: FileData?
        
        if let image = imageViewProfile.image {
            imageData = FileData(
                data: image.jpegData(compressionQuality: 0.7)!,
                mimeType: .jpeg,
                key: Parameter.profile
            )
        }
        
        Networking.request(
            url: Urls.editSellerProfile,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: imageData == nil ? nil : [imageData!],
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let commonResponse = NetworkHelper.decodeJsonData(
                        data: jsonData, decodeWith: CommonApiResponse.self
                    )
                    
                    guard let cmResponse = commonResponse else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if cmResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(
                            message: cmResponse.message!,
                            duration: .normal
                        ) { [self] in
                            
                            delegate?.memberUpdated?(view: self)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: cmResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(
                        message: error.localizedDescription
                    )
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
}

extension AddTeamVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == textfieldPincode {
            return Validation.shouldAllowTyping(textField, range: range, string: string, maxRange: Validation.reqPincodeChares)
        } else if textField == textfieldMobileNo {
            return Validation.shouldAllowTyping(textField, range: range, string: string, maxRange: Validation.maxMobileNoLength)
        } else {
            return true
        }
        
        
    }
    
}

extension AddTeamVC: ToolBarDelegate, MediaPickerDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    func mediaPicked(media: MediaData) {
        profileData = media
        imageViewProfile.image = media.image
    }
    
}
