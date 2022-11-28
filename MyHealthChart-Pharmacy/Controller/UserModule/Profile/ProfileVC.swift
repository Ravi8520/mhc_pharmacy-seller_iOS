//
//  ProfileVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 01/10/21.
//

import UIKit

extension ProfileVC {
    static func instantiate() -> ProfileVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: ProfileVC.self)) as! ProfileVC
    }
}

class ProfileVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var scrollViewContent: UIScrollView!
    
    @IBOutlet weak var labelPharmacyName: UILabel!
    @IBOutlet weak var labelPharmacyOpenTime: UILabel!
    @IBOutlet weak var labelPharmacyCloseTime: UILabel!
    
    @IBOutlet weak var labelPharmacyLunchOpenTime: UILabel!
    @IBOutlet weak var labelPharmacyLunchCloseTime: UILabel!
    
    @IBOutlet weak var labelDiscount: UILabel!
    @IBOutlet weak var labelFreeDeliveryRange: UILabel!
    @IBOutlet weak var labelInternalDeliveryYesNo: UILabel!
    
    @IBOutlet weak var labelOpenOnSundayYesNo: UILabel!
    
    @IBOutlet weak var labelAsperMondayToSaturday: UILabel!
    
    @IBOutlet weak var labelPharmacySundayOpenTime: UILabel!
    @IBOutlet weak var labelPharmacySundayCloseTime: UILabel!
    
    @IBOutlet weak var labelPharmacySundayLunchOpenTime: UILabel!
    @IBOutlet weak var labelPharmacySundayLunchCloseTime: UILabel!
    
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var labelOwnerName: UILabel!
    @IBOutlet weak var labelBusinessType: UILabel!
    
    @IBOutlet weak var labelPartnerName: UILabel!
    
    @IBOutlet weak var labelRegistrationNo: UILabel!
    
    @IBOutlet weak var labelValidUpto: UILabel!
    
    @IBOutlet weak var labelAccountRequestDate: UILabel!
    @IBOutlet weak var labelAccountApprovedDate: UILabel!
    
    @IBOutlet weak var stackViewSundayTimings: UIStackView!
    
    @IBOutlet weak var collectionViewAdharCard: UICollectionView!
    @IBOutlet weak var collectionViewDrugLicence: UICollectionView!
    @IBOutlet weak var collectionViewPartnerShipDeed: UICollectionView!
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var imageViewPanCard: UIImageView!
    @IBOutlet weak var imageViewOwnerPhoto: UIImageView!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    
    var profileData: GetProfileDataApiResponse?
    
    var adharCardDataSource = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewContent.isHidden = true
        btnEdit.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
    }
    
    private func setUpView() {
        imageViewProfile.setCornerRadius(isMaskedToBound: true)
        uiViewToolBar.labelTitle.text = "Profile"
        uiViewToolBar.btnSearch.isHidden = true
        setUpCollectionView()
        setUpDelegates()
        getProfile()
    }
    
    private func setUpDelegates() {
        uiViewToolBar.delegate = self
    }
    
    private func setUpCollectionView() {
        collectionViewAdharCard.register(
            MediaCollectionCell.loadNib(),
            forCellWithReuseIdentifier: MediaCollectionCell.idetifire()
        )
        collectionViewDrugLicence.register(
            MediaCollectionCell.loadNib(),
            forCellWithReuseIdentifier: MediaCollectionCell.idetifire()
        )
        collectionViewPartnerShipDeed.register(
            MediaCollectionCell.loadNib(),
            forCellWithReuseIdentifier: MediaCollectionCell.idetifire()
        )
        setFlowLayout()
    }
    
    private func setFlowLayout() {
        let adharLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        adharLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        adharLayout.minimumInteritemSpacing = 0
        adharLayout.minimumLineSpacing = 16
        adharLayout.scrollDirection = .horizontal
        
        let drugLicenceLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        drugLicenceLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        drugLicenceLayout.minimumInteritemSpacing = 0
        drugLicenceLayout.minimumLineSpacing = 16
        drugLicenceLayout.scrollDirection = .horizontal
        
        let deedLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        deedLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        deedLayout.minimumInteritemSpacing = 0
        deedLayout.minimumLineSpacing = 16
        deedLayout.scrollDirection = .horizontal
        
        
        collectionViewAdharCard.collectionViewLayout = adharLayout
        collectionViewDrugLicence.collectionViewLayout = drugLicenceLayout
        collectionViewPartnerShipDeed.collectionViewLayout = deedLayout
    }
    
    @IBAction func btnEditProfilePressed(_ sender: UIButton) {
        let vc = EditProfileVC.instantiate()
        vc.userData = profileData
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPanCardFullScreenView(_ sender: UIButton) {
        
        guard let data = profileData else { return }
        
        Networking.remoteResource(
            at: data.pancard ?? "",
            isOneOf: [.pdf]) { isPdf in
                
                if isPdf {
                    
                    let vc = PDFViewerVC.instantiate()
                    vc.remoteUrl = data.pancard ?? ""
                    self.present(vc, animated: true, completion: nil)
                    
                } else {
                    
                    let vc = FullScreenVC.instantiate()
                    vc.remoteUrl = data.pancard ?? ""
                    self.present(vc, animated: true, completion: nil)
                    
                }
                
            }
    
    }
    
    @IBAction func btnOwnerFullScreenPressed(_ sender: UIButton) {
        if let img = imageViewOwnerPhoto.image {
            let vc = FullScreenVC.instantiate()
            vc.image = img
            present(vc, animated: true, completion: nil)
        }
    }
    
    

}

extension ProfileVC {
    
    private func getProfile() {
        
        Networking.request(
            url: Urls.getPharmacyProfile ,
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
                    
                    let profileResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: GetProfileApiResponse.self)
                    
                    guard let pfResponse = profileResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if pfResponse.status == StatusCode.success.rawValue {
                        
//                        AlertHelper.shared.showToast(message: pfResponse.message!, duration: .normal) { [self] in
                            
                            if let data = pfResponse.data {
                                self.profileData = data
                                self.setupData()
                            }
                            
//                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: pfResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func setupData() {
        
        guard let data = profileData else { return }
        
        scrollViewContent.isHidden = false
        btnEdit.isHidden = false
        
        collectionViewDrugLicence.reloadData()
        collectionViewAdharCard.reloadData()
        collectionViewPartnerShipDeed.reloadData()
        
        setupImages()
        
        labelPharmacyName.text = data.pharmacyName
        labelPharmacyOpenTime.text = DateHelper.shared.convertAppTime(serverTime: data.pharmacyOpenTime)
        labelPharmacyCloseTime.text = DateHelper.shared.convertAppTime(serverTime: data.pharmacyCloseTime)
        
        if let lunchOpenTime = data.lunchOpenTime,
           let lunchCloseTime = data.lunchCloseTime {
            
            labelPharmacyLunchOpenTime.text = DateHelper.shared.convertAppTime(serverTime: lunchOpenTime)
            labelPharmacyLunchCloseTime.text = DateHelper.shared.convertAppTime(serverTime: lunchCloseTime)
            
        } else {
            // Make Decision for show hide regular lunch section
        }
        
        if let minDiscount = data.discountMin, let maxDiscount = data.discountMax {
            if !(minDiscount == "0") && !(maxDiscount == "0") {
                labelDiscount.text = "\(minDiscount)-\(maxDiscount)%"
            } else if (minDiscount == "0") && (maxDiscount == "0") {
                labelDiscount.text = " - "
            } else if (minDiscount == "0") {
                labelDiscount.text = "0-\(maxDiscount)%"
            } else if (maxDiscount == "0") {
                labelDiscount.text = "\(minDiscount)-0%"
            } else {
                labelDiscount.text = " - "
            }
        }
        
        if let deliveryRange = data.deliveryRange {
            if deliveryRange == "0" {
                labelInternalDeliveryYesNo.text = "No"
                labelFreeDeliveryRange.text = " - "
            } else {
                labelInternalDeliveryYesNo.text = "Yes"
                labelFreeDeliveryRange.text = "\(deliveryRange) km"
            }
        }
        
        if let sundayOpenTime = data.sundayOpenTime,
           let sundayCloseTime = data.sundayCloseTime {
            
            if sundayOpenTime.isEmpty {
                labelOpenOnSundayYesNo.text = "No"
                stackViewSundayTimings.isHidden = true
            } else {
                labelOpenOnSundayYesNo.text = "Yes"
                stackViewSundayTimings.isHidden = false
                
                if let sundayLunchOpenTime = data.sundayLunchOpenTime,
                   let sundayLunchCloseTime = data.sundayLunchCloseTime {
                    
                    if sundayOpenTime == data.pharmacyOpenTime &&
                        sundayCloseTime == data.pharmacyCloseTime &&
                        sundayLunchOpenTime == data.sundayLunchOpenTime &&
                        sundayLunchCloseTime == data.sundayLunchCloseTime {
                        
                        labelPharmacySundayOpenTime.text = DateHelper.shared.convertAppTime(serverTime: sundayOpenTime)
                        labelPharmacySundayCloseTime.text = DateHelper.shared.convertAppTime(serverTime: sundayCloseTime)
                        labelPharmacySundayLunchOpenTime.text = labelPharmacyLunchOpenTime.text
                        labelPharmacySundayLunchCloseTime.text = labelPharmacyLunchCloseTime.text
                        
                        labelAsperMondayToSaturday.text = "As per Monday to Saturday"
                        
                    } else {
                        
                        labelAsperMondayToSaturday.isHidden = true
                        
                        labelPharmacySundayOpenTime.text = DateHelper.shared.convertAppTime(serverTime: sundayOpenTime)
                        labelPharmacySundayCloseTime.text = DateHelper.shared.convertAppTime(serverTime: sundayCloseTime)
                        labelPharmacySundayLunchOpenTime.text = DateHelper.shared.convertAppTime(serverTime: sundayLunchOpenTime)
                        labelPharmacySundayLunchCloseTime.text = DateHelper.shared.convertAppTime(serverTime: sundayLunchCloseTime)
                        
                    }
                    
                }
            }
        }
        
        labelAddress.text = data.address
        
        labelOwnerName.text = data.pharmacyOwnerName
        labelBusinessType.text = data.businessType
        
        if let partnerName = data.partnerName {
            if partnerName.isEmpty {
                labelPartnerName.text = " - "
            } else {
                labelPartnerName.text = partnerName
            }
        }
        
        labelRegistrationNo.text = data.registrationNumber
        labelValidUpto.text = data.licenceValidUpto
        
        labelAccountRequestDate.text = DateHelper.shared.convertAppLongDate(serverDate24: data.accountRequestDate)
        labelAccountApprovedDate.text = DateHelper.shared.convertAppLongDate(serverDate24: data.accountApproveDate)
        
    }
    
    private func setupImages() {
        
        guard let data = profileData else { return }
        
        imageViewProfile.loadImageFromUrl(
            urlString: data.phamacyLogo ?? "",
            placeHolder: UIImage(named: "ic_profile_placeholder")
        )
        self.imageViewProfile.contentMode = .scaleAspectFill
        self.imageViewProfile.setCornerRadius(radius: 4, isMaskedToBound: true)
        
        UserDefaultHelper.shared.setData(key: UserDefaultHelper.keys.pharmacyLogo, data: data.phamacyLogo)
        
        Networking.remoteResource(
            at: data.pancard ?? "",
            isOneOf: [.pdf]) { isPdf in
                
                if isPdf {
                    self.imageViewPanCard.image = #imageLiteral(resourceName: "ic_pdf")
                    self.imageViewPanCard.contentMode = .scaleAspectFit
                } else {
                    self.imageViewPanCard.loadImageFromUrl(
                        urlString: data.pancard ?? "",
                        placeHolder: nil
                    )
                    self.imageViewPanCard.contentMode = .scaleAspectFill
                }
                
            }
        
        self.imageViewOwnerPhoto.loadImageFromUrl(
            urlString: data.ownerPhoto ?? "",
            placeHolder: UIImage(named: "ic_profile_placeholder")
        )
        self.imageViewOwnerPhoto.contentMode = .scaleAspectFill
        self.imageViewOwnerPhoto.setCornerRadius(radius: 4, isMaskedToBound: true)
        
    }
    
}

extension ProfileVC: ToolBarDelegate, ProfileUpdateDelegate {
    
    func profileUpdated() {
        scrollViewContent.isHidden = true
        getProfile()
    }
    
    func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
