//
//  MoreVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 30/09/21.
//

import UIKit

extension MoreVC {
    static func instantiate() -> MoreVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: MoreVC.self)) as! MoreVC
    }
}

class MoreVC: UIViewController {

    @IBOutlet weak var labelPharmacyName: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelReferralCode: UILabel!
    
    @IBOutlet var switchPharmacyStatus: UISwitch!
    @IBOutlet weak var switchSellerStatus: UISwitch!
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var uiViewProfileCard: UIView!
    @IBOutlet var cardView: [UIView]!
    
    @IBOutlet weak var uiViewAvailibility: UIView!
    @IBOutlet weak var uiViewDeliveryBoy: UIView!
    
    @IBOutlet weak var uiViewReports: UIView!
    @IBOutlet weak var uiViewMyTeam: UIView!
    @IBOutlet weak var uiViewPackage: UIView!
    @IBOutlet weak var uiViewReferralUsers: UIView!
    @IBOutlet weak var uiViewFeedback: UIView!
    
    @IBOutlet weak var uiViewLedgerStatement: UIView!
    
    @IBOutlet weak var labelVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserData()
        setUpViews()
    }
    
    private func setUpViews() {
        
        for view in cardView {
            view.setCardView()
        }
        
        if AppConfig.userType == .pharmacy {
            uiViewAvailibility.isHidden = true
            uiViewDeliveryBoy.isHidden = true
        } else {
            uiViewReports.isHidden = true
            uiViewMyTeam.isHidden = true
            uiViewPackage.isHidden = true
            uiViewReferralUsers.isHidden = true
            uiViewFeedback.isHidden = true
        }
        
        uiViewProfileCard.setCardView()
        imageViewProfile.setCornerRadius(isMaskedToBound: true)
        
    }
    
    private func setUserData() {
        
        let pharmaName = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.pharmacyName) as? String
        let userName = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.fullName) as? String
        let referrenceCode = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.referralCode) as? String
        let pharmcyStatus = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.pharmacyOpenCloseStatus) as? String
        
        if AppConfig.userType == .seller {
            
            switchPharmacyStatus.isHidden = true
            
            let userAvailibility = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.userAvailibiltyStatus) as? String
            
            labelPharmacyName.text = userName
            labelUserName.text = "Sales Person"
            switchSellerStatus.isOn = userAvailibility == "true" ? true : false
        } else {
            labelPharmacyName.text = pharmaName
            labelUserName.text = userName
        }
    
        labelReferralCode.text = "Referral code \(referrenceCode ?? "")"
        
        if let status = pharmcyStatus {
            if let isOpen = Bool(status) {
                switchPharmacyStatus.isOn = isOpen
            }
        }
        
        let logoUrl = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.pharmacyLogo) as? String
        
        imageViewProfile.loadImageFromUrl(
            urlString: logoUrl ?? "",
            placeHolder: UIImage(named: "ic_profile_placeholder")
        )
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnProfilePressed(_ sender: UIButton) {
        if AppConfig.userType == .seller {
            self.navigationController?.pushViewController(TeamDetailVC.instantiate(), animated: true)
        } else {
            self.navigationController?.pushViewController(ProfileVC.instantiate(), animated: true)
        }
    }
    
    @IBAction func togglePharmacySwitch(_ sender: UISwitch) {
        if !switchPharmacyStatus.isOn {
            let vc = ResumeShopPopupVC.instantiate()
            vc.resumeShopHandler = { [self] isOn in
                switchPharmacyStatus.isOn = !isOn
                UserDefaultHelper.shared.setData(
                    key: UserDefaultHelper.keys.pharmacyOpenCloseStatus,
                    data: "\(!isOn)"
                )
            }
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            resumeShopApi()
        }
    }
    
    @IBAction func switchSellerAvailibility(_ sender: UISwitch) {
        changeSellerStatus()
    }
    
    @IBAction func btnDeliveryBoyPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(DeliveryBoyListVC.instantiate(), animated: true)
    }
    
    @IBAction func btnSharePressed(_ sender: UIButton) {
        Helper.shared.shareApp(msg: Strings.shareText())
    }
    
    @IBAction func btnReportPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(ReportTabbarVC.instantiate(), animated: true)
    }
    
    @IBAction func btnLedgerStatementPressed(_ sender: Any) {
        
        if Parameter.is_ledger_statement_allow {
            self.navigationController?.pushViewController(LedgerStatementVC.instantiate(), animated: true)
        }
        else {
            let popUp = ComingSoonVC.instanciate()
            present(popUp, animated: true, completion: nil)
        }
    }
    @IBAction func btnMyTeamPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(MyTeamTabbarVC.instantiate(), animated: true)
    }
    
    @IBAction func btnPackages(_ sender: UIButton) {
        self.navigationController?.pushViewController(PackagesVC.instantiate(), animated: true)
    }
    
    @IBAction func btnReferralPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(ReferralUsersVC.instantiate(), animated: true)
    }
    
    @IBAction func btnFeedBackPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(UserFeedbackVC.instantiate(), animated: true)
    }
    
    @IBAction func btnChangePwdPressed(_ sender: UIButton) {
        let vc = ResetPwdVC.instantiate()
        vc.screenType = .changePassword
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogoutPressed(_ sender: BorderButton) {
        
        AlertHelper.shared.showConfirmAlert(
            title: Strings.alertTitle,
            message: Strings.logoutConfirmationMessage,
            yesActionTitle: Strings.yesConfirmation,
            noActionTitle: Strings.noConfirmation,
            yesActionStyle: .destructive,
            noActionStyle: .cancel,
            YesAction: { action in
                self.logout()
            },
            NoAction: nil
        )
        
    }
    

}

extension MoreVC {
    
    private func logout() {
        
        Networking.request(
            url: Urls.logout,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: nil,
            fileData: nil,
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
                            message: cmResponse.message ?? "Logout successfully",
                            duration: .normal
                        ) {
                                Helper.shared.setLogout()
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
    
    private func resumeShopApi() {
        
        let param = [
            Parameter.pharmacyStatus: true,
            Parameter.date: ""
        ] as [String : Any]
        
        Networking.request(
            url: Urls.changePharmacyStatus,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: true
        ) { response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        self.switchPharmacyStatus.isOn = !self.switchPharmacyStatus.isOn
                        
                        AlertHelper.shared.showAlert(
                            message: CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let cpResponse = NetworkHelper.decodeJsonData(
                        data: jsonData, decodeWith: CommonApiResponse.self
                    )
                    
                    guard let rpResponse = cpResponse else {
                        
                        self.switchPharmacyStatus.isOn = !self.switchPharmacyStatus.isOn
                        
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if rpResponse.status == StatusCode.success.rawValue {
                        
                        UserDefaultHelper.shared.setData(
                            key: UserDefaultHelper.keys.pharmacyOpenCloseStatus,
                            data: "true"
                        )
                    
                    } else {
                        self.switchPharmacyStatus.isOn = !self.switchPharmacyStatus.isOn
                        
                        AlertHelper.shared.showAlert(
                            message: rpResponse.message!
                        )
                    }
                    
                case .failure(let error):
                    
                    self.switchPharmacyStatus.isOn = !self.switchPharmacyStatus.isOn
                    
                    AlertHelper.shared.showAlert(
                        message: error.localizedDescription
                    )
                    
                    Log.e(error.localizedDescription)
                    
            }
        }
    }
    
    private func changeSellerStatus() {
        
        let param = [
            Parameter.status: switchSellerStatus.isOn
        ]
        
        Networking.request(
            url: Urls.setSellerStatus,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: true
        ) { response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        
                        self.switchSellerStatus.isOn = !self.switchSellerStatus.isOn
                        
                        AlertHelper.shared.showAlert(
                            message: CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let cpResponse = NetworkHelper.decodeJsonData(
                        data: jsonData, decodeWith: CommonApiResponse.self
                    )
                    
                    guard let rpResponse = cpResponse else {
                        
                        self.switchSellerStatus.isOn = !self.switchSellerStatus.isOn
                        
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if rpResponse.status == StatusCode.success.rawValue {
                        
                        UserDefaultHelper.shared.setData(
                            key: UserDefaultHelper.keys.userAvailibiltyStatus,
                            data: "\(self.switchSellerStatus.isOn)"
                        )
                        
                    } else {
                        
                        self.switchSellerStatus.isOn = !self.switchSellerStatus.isOn
                        
                        AlertHelper.shared.showAlert(
                            message: rpResponse.message!
                        )
                    }
                    
                case .failure(let error):
                    
                    self.switchSellerStatus.isOn = !self.switchSellerStatus.isOn
                    
                    AlertHelper.shared.showAlert(
                        message: error.localizedDescription
                    )
                    Log.e(error.localizedDescription)
                    
            }
        }
    }
    
}
