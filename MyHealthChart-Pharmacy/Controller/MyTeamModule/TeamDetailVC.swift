//
//  TeamDetailVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 06/10/21.
//

import UIKit

extension TeamDetailVC {
    static func instantiate() -> TeamDetailVC {
        StoryBoardConstants.myTeam.instantiateViewController(withIdentifier: String(describing: TeamDetailVC.self)) as! TeamDetailVC
    }
}

class TeamDetailVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    
    @IBOutlet weak var labelUserName: UILabel!
    
    @IBOutlet weak var switchActiveInActiveUser: UISwitch!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var labelPharmacyName: UILabel!
    @IBOutlet weak var labelDesignation: UILabel!
    
    @IBOutlet weak var labelAddress: UILabel!
    
    var userId = ""
    var userType = ""
    
    private var teamDetailData: MyTeamDetailDataApiResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        imageViewProfile.setCornerRadius(isMaskedToBound: true)
        setupDelegates()
        uiViewToolBar.labelTitle.text = ""
        uiViewToolBar.btnSearch.isHidden = true
        if AppConfig.userType == .seller {
            switchActiveInActiveUser.isHidden = true
            getSellerProfile()
        } else {
            getMemberDetail()
        }
        
        btnEdit.isHidden = true
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
    }
    
    @IBAction func btnFullScreenImagePressed(_ sender: UIButton) {
        if let img = imageViewProfile.image {
            let vc = FullScreenVC.instantiate()
            vc.image = img
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnEditPressed(_ sender: UIButton) {
        let vc = AddTeamVC.instantiate()
        vc.editMode = true
        vc.delegate = self
        vc.teamDetailData = teamDetailData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func switchUserStatusChanged(_ sender: UISwitch) {
        changeUserStatus(to: sender.isOn)
    }
    
    @IBAction func btnCallMemberPressed(_ sender: UIButton) {
        if let number = teamDetailData?.mobileNo {
            Helper.shared.sendNumberForCall(num: number)
        }
    }
    

}

extension TeamDetailVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getSellerProfile() {
    
        Networking.request(
            url: Urls.getSellerProfile,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: nil,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let sellerProfileResponse = NetworkHelper.decodeJsonData(
                        data: jsonData,
                        decodeWith: SellerProfileApiResponse.self
                    )
                    
                    guard let spResponse = sellerProfileResponse else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if spResponse.status == StatusCode.success.rawValue {
                        
                        if let teamData = spResponse.data {
                            teamDetailData = teamData
                            setupTeamData()
                        }
                        
                    } else {
                        
                        AlertHelper.shared.showAlert(message: spResponse.message!)
                    }
                    
                case .failure(let error):
                    
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    
    
    private func getMemberDetail() {

        let param = [
            Parameter.userId: userId,
            Parameter.userType: userType
        ]
        
        Networking.request(
            url: Urls.teammemberDetail,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let myTeamDetailResponse = NetworkHelper.decodeJsonData(
                        data: jsonData,
                        decodeWith: MyTeamDetailApiResponse.self
                    )
                    
                    guard let mtdResponse = myTeamDetailResponse else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if mtdResponse.status == StatusCode.success.rawValue {
                        
                        if let teamData = mtdResponse.data?.first {
                            teamDetailData = teamData
                            setupTeamData()
                        }
                        
                    } else {
                        
                        AlertHelper.shared.showAlert(message: mtdResponse.message!)
                    }
                    
                case .failure(let error):
                    
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func changeUserStatus(to: Bool) {
        
        Log.d("User status change to:- \(to)")
        
        let param = [
            Parameter.userId: userId,
            Parameter.userType: userType,
            Parameter.status: to
        ] as [String : Any]
        
        Networking.request(
            url: Urls.teammemberStatusChanged,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
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
                        
                        AlertHelper.shared.showToast(message: cmResponse.message ?? "")
                        
                    } else {
                        
                        switchActiveInActiveUser.isOn = !switchActiveInActiveUser.isOn
                        
                        AlertHelper.shared.showAlert(message: cmResponse.message!)
                    }
                    
                case .failure(let error):
                    
                    switchActiveInActiveUser.isOn = !switchActiveInActiveUser.isOn
                    
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func setupTeamData() {
        
        guard let data = teamDetailData else { return }
        
        btnEdit.isHidden = false
        
        imageViewProfile.loadImageFromUrl(
            urlString: data.profile ?? "",
            placeHolder: UIImage(named: "ic_profile_placeholder")
        )
        
        labelUserName.text = data.name
        
        if AppConfig.userType == .pharmacy {
            switchActiveInActiveUser.isOn = data.isActive == "true" ? true : false
        }
        
        labelEmail.text = data.email
        labelMobile.text = data.mobileNo
        
        labelDesignation.text = data.userType == "seller" ? "Sales Person" : "Delivery Boy"
        
        var address = data.blockNo ?? ""
        
        address += ", \(data.streetName ?? ""),\n"
        address += "\(data.landmark ?? ""),\n"
        address += data.pincode ?? ""
        
        labelAddress.text = address
        
        let pharmacyName = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.pharmacyName) as? String
        
        labelPharmacyName.text = pharmacyName
        
    }
    
}

extension TeamDetailVC: AddTeamDelegate {
    
    func memberUpdated(view: UIViewController) {
        
        view.navigationController?.popViewController(animated: true)
        
        if AppConfig.userType == .seller {
            getSellerProfile()
        } else {
            getMemberDetail()
        }
    }
    
}
