//
//  CreateAccountVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 28/09/21.
//

import UIKit

extension CreateAccountVC {
    static func instantiate() -> CreateAccountVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: CreateAccountVC.self)) as! CreateAccountVC
    }
}

class CreateAccountVC: UIViewController {
    
    enum DocumentType {
        case partnerShipDeed
        case drugLicence
        case adharCard
        case panCard
        case ownerPhoto
    }

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet var btnFirmType: [UIButton]!
    
    @IBOutlet weak var textfieldFullName: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldPartnerName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var stackViewPartnerShipDeed: UIStackView!
    
    @IBOutlet weak var uiViewUploadPartnerShipDeedBorder: UIView!
    
    @IBOutlet weak var collectionViewPartnershipDeed: UICollectionView!
    
    @IBOutlet weak var textfieldEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldOwnerMobileNo: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldServiceMobileNo: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldManagerMobileNo: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldLicenceNo: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldValidUptoYear: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var textfieldConfPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnEyePassword: UIButton!
    @IBOutlet weak var btnEyeConfPassword: UIButton!
    
    @IBOutlet weak var uiViewUploadDrugLicenceBorder: UIView!
    @IBOutlet weak var uiViewUploadFrontAdharCardBorder: UIView!
    @IBOutlet weak var uiViewUploadBackAdharCardBorder: UIView!
    @IBOutlet weak var uiViewUploadPanCardBorder: UIView!
    @IBOutlet weak var uiViewOwnerProfileBorder: UIView!
    
    @IBOutlet weak var collectionViewDrugLicence: UICollectionView!
    
    @IBOutlet weak var uiViewAdharFrontContainer: UIView!
    @IBOutlet weak var uiViewFrontAdharImageContainer: UIView!
    @IBOutlet weak var imageViewAdharFront: UIImageView!
    
    @IBOutlet weak var uiViewAdharBackContainer: UIView!
    @IBOutlet weak var uiViewBackAdharImageContainer: UIView!
    @IBOutlet weak var imageViewAdharBack: UIImageView!
    
    @IBOutlet weak var uiViewPanCardImageContainer: UIView!
    @IBOutlet weak var imageViewPanCard: UIImageView!
    
    @IBOutlet weak var uiViewOwnerImageContainer: UIView!
    @IBOutlet weak var imageViewOwner: UIImageView!
    
    @IBOutlet weak var btnAddPartner: UIButton!
    
    
    var partnersNameTextfields: [SkyFloatingLabelTextField] = []
    
    var selectedAdharButton = 0
    
    var adharFrontData: MediaData?
    var adharBackData: MediaData?
    var panCardData: MediaData?
    var ownerData: MediaData?
    
    private var isNewPwdHidden = true
    private var isConfPwdHidden = true
    
    var docTypeChoose: DocumentType = .drugLicence
    
    var partnershipDeedDataSource:[MediaData] = []
    var drugLicenceDataSource:[MediaData] = []
    
    var selectedFirmType = 1
    
    private let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupDelegates()
        setUpDropDown()
        uiViewToolBar.labelTitle.text = "Create an account"
        uiViewToolBar.btnSearch.isHidden = true
        
        uiViewUploadPartnerShipDeedBorder.addLineDashedStroke(pattern: [2,2], radius: 8, color: .appColor.fontColor)
        uiViewUploadDrugLicenceBorder.addLineDashedStroke(pattern: [2,2], radius: 8, color: .appColor.fontColor)
        uiViewUploadFrontAdharCardBorder.addLineDashedStroke(pattern: [2,2], radius: 8, color: .appColor.fontColor)
        uiViewUploadBackAdharCardBorder.addLineDashedStroke(pattern: [2,2], radius: 8, color: .appColor.fontColor)
        uiViewUploadPanCardBorder.addLineDashedStroke(pattern: [2,2], radius: 8, color: .appColor.fontColor)
        uiViewOwnerProfileBorder.addLineDashedStroke(pattern: [2,2], radius: 8, color: .appColor.fontColor)
        
        registerCollectioViewCell()
        
        btnAddPartner.setCornerRadius(radius: 4)
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        textfieldFullName.delegate = self
        textfieldPartnerName.delegate = self
        textfieldEmail.delegate = self
        textfieldOwnerMobileNo.delegate = self
        textfieldServiceMobileNo.delegate = self
        textfieldManagerMobileNo.delegate = self
        textfieldLicenceNo.delegate = self
        textfieldValidUptoYear.delegate = self
        textfieldPassword.delegate = self
        textfieldConfPassword.delegate = self
    }
    
    private func registerCollectioViewCell() {
        collectionViewPartnershipDeed.register(
            MediaCollectionCell.loadNib(),
            forCellWithReuseIdentifier: MediaCollectionCell.idetifire()
        )
        collectionViewDrugLicence.register(
            MediaCollectionCell.loadNib(),
            forCellWithReuseIdentifier: MediaCollectionCell.idetifire()
        )
        setFlowLayout()
    }
    
    private func setFlowLayout() {
        let partnerShipDeedLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        partnerShipDeedLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        partnerShipDeedLayout.minimumInteritemSpacing = 0
        partnerShipDeedLayout.minimumLineSpacing = 16
        partnerShipDeedLayout.scrollDirection = .horizontal
        
        collectionViewPartnershipDeed.collectionViewLayout = partnerShipDeedLayout
        
        let drugLicenceLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        drugLicenceLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        drugLicenceLayout.minimumInteritemSpacing = 0
        drugLicenceLayout.minimumLineSpacing = 16
        drugLicenceLayout.scrollDirection = .horizontal

        collectionViewDrugLicence.collectionViewLayout = drugLicenceLayout
    }
    
    private func setUpDropDown() {
        dropDown.anchorView = textfieldValidUptoYear
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 4
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = { [self] (index, title) in
            textfieldValidUptoYear.text = title
        }
    }
    
    @IBAction func btnFirmTypePressed(_ sender: UIButton) {
        
        selectedFirmType = sender.tag
        
        for btns in btnFirmType {
            if btns.tag == selectedFirmType {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_blue"), for: .normal)
            } else {
                btns.setImage(#imageLiteral(resourceName: "ic_radio_grey"), for: .normal)
            }
        }
        
        if selectedFirmType == 0 {
            stackViewPartnerShipDeed.isHidden = false
        } else {
            stackViewPartnerShipDeed.isHidden = true
        }
    }
    
    @IBAction func btnUploadPartnerShipDeedPressed(_ sender: UIButton) {
        docTypeChoose = .partnerShipDeed
        
        var isAllowedPDF = true
        
        for mediaData in partnershipDeedDataSource {
            if mediaData.fileType == .jpeg || mediaData.fileType == .jpg || mediaData.fileType == .png {
                isAllowedPDF = false
                break
            }
        }
        
        MediaPicker.shared.chooseOptionForMediaType(delegate: self, isAllowedPdf: isAllowedPDF)
    }
    
    @IBAction func btnValidUptoYearPressed(_ sender: UIButton) {
        dropDown.dataSource = DateHelper.shared.getNextValidUptoYears()
        dropDown.show()
    }
    
    @IBAction func btnEyePressed(_ sender: UIButton) {
        if sender == btnEyePassword {
            isNewPwdHidden.toggle()
            textfieldPassword.isSecureTextEntry = isNewPwdHidden
            sender.setImage(
                isNewPwdHidden ? #imageLiteral(resourceName: "ic_eye_grey") : #imageLiteral(resourceName: "ic_eye_blue") ,
                for: .normal
            )
        } else {
            isConfPwdHidden.toggle()
            textfieldConfPassword.isSecureTextEntry = isConfPwdHidden
            sender.setImage(
                isNewPwdHidden ? #imageLiteral(resourceName: "ic_eye_grey") : #imageLiteral(resourceName: "ic_eye_blue") ,
                for: .normal
            )
        }
    }
    
    @IBAction func btnUploadDrugLicencePressed(_ sender: UIButton) {
        
        docTypeChoose = .drugLicence
        
        var isAllowedPDF = true
        
        for mediaData in drugLicenceDataSource {
            if mediaData.fileType == .jpeg || mediaData.fileType == .jpg || mediaData.fileType == .png {
                isAllowedPDF = false
                break
            }
        }
        
        MediaPicker.shared.chooseOptionForMediaType(delegate: self, isAllowedPdf: isAllowedPDF)
        
    }
    
    @IBAction func btnUploadAdharPressed(_ sender: UIButton) {
        docTypeChoose = .adharCard
        selectedAdharButton = sender.tag
        
        if selectedAdharButton == 0 {
            
            var isPdfAllow = false
            
            if adharBackData == nil {
                isPdfAllow = true
            }
        
            MediaPicker.shared.chooseOptionForMediaType(delegate: self, isAllowedPdf: isPdfAllow)
        } else {
            
            var isPdfAllow = false
            
            if adharFrontData == nil {
                isPdfAllow = true
            }
            
            MediaPicker.shared.chooseOptionForMediaType(delegate: self, isAllowedPdf: isPdfAllow)
        }
    }
    
    @IBAction func btnAdharFullScreenViewPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            openMediaInFullScreen(media: adharFrontData)
        } else {
            openMediaInFullScreen(media: adharBackData)
        }
    }
    
    @IBAction func btnAdharCancelPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            adharFrontData = nil
            imageViewAdharFront.image = nil
            uiViewFrontAdharImageContainer.isHidden = true
            uiViewUploadFrontAdharCardBorder.isHidden = false
            uiViewAdharBackContainer.isHidden = false
            
        } else {
            adharBackData = nil
            imageViewAdharBack.image = nil
            uiViewBackAdharImageContainer.isHidden = true
            uiViewUploadBackAdharCardBorder.isHidden = false
            uiViewAdharFrontContainer.isHidden = false
        }
        
    }
    
    @IBAction func btnUploadPanCardPressed(_ sender: UIButton) {
        docTypeChoose = .panCard
        MediaPicker.shared.chooseOptionForMediaType(delegate: self, isAllowedPdf: true)
    }
    
    @IBAction func btnPanCardFullScreenPressed(_ sender: UIButton) {
        openMediaInFullScreen(media: panCardData)
    }
    
    @IBAction func btnPanCardCancelPressed(_ sender: UIButton) {
        panCardData = nil
        imageViewPanCard.image = nil
        uiViewPanCardImageContainer.isHidden = true
        uiViewUploadPanCardBorder.isHidden = false
    }
    
    @IBAction func btnUploadOwnerImagePressed(_ sender: UIButton) {
        docTypeChoose = .ownerPhoto
        MediaPicker.shared.chooseOptionForMediaType(delegate: self, isAllowedPdf: false)
    }
    
    @IBAction func btnOwnerImageFullScreenPressed(_ sender: UIButton) {
        openMediaInFullScreen(media: ownerData)
    }
    
    @IBAction func btnOwnerImageCancelPressed(_ sender: UIButton) {
        ownerData = nil
        imageViewOwner.image = nil
        uiViewOwnerImageContainer.isHidden = true
        uiViewOwnerProfileBorder.isHidden = false
    }
    
    @IBAction func btnNextPressed(_ sender: HalfCornerButton) {
        validateForm()
        //navigateToOtpVerification()
    }
    
    @IBAction func btnAddPartnerPressed(_ sender: UIButton) {
        
        if textfieldPartnerName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            textfieldPartnerName.errorMessage = Strings.emptyPartnerNameError
            return
        } else if textfieldPartnerName.text!.count < Validation.minNameLength {
            textfieldPartnerName.errorMessage = Strings.invalidPartnerNameError(length: Validation.minNameLength)
            return
        } else {
            textfieldPartnerName.errorMessage = nil
        }
        
        if partnersNameTextfields.isEmpty {
            let textfield = getSkyTextField()
            partnersNameTextfields.append(textfield)
            stackViewPartnerShipDeed.insertArrangedSubview(textfield, at: 1)
        } else {
            if partnersNameTextfields.last!.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                partnersNameTextfields.last?.errorMessage = Strings.emptyPartnerNameError
            } else if partnersNameTextfields.last!.text!.count < Validation.minNameLength {
                partnersNameTextfields.last!.errorMessage = Strings.invalidPartnerNameError(length: Validation.minNameLength)
            } else {
                partnersNameTextfields.last!.errorMessage = nil
                let textfield = getSkyTextField()
                partnersNameTextfields.append(textfield)
                stackViewPartnerShipDeed.insertArrangedSubview(textfield, at: partnersNameTextfields.count)
            }
        }
    }
    
    private func getSkyTextField() -> SkyFloatingLabelTextField {
        
        let textfield = SkyFloatingLabelTextField()
        
        textfield.placeholder = "Partner Name"
        textfield.selectedTitleColor = UIColor(named: "AppPlaceHolderColor")!
        textfield.selectedLineColor = UIColor(named: "AppFocusedTextFieldColor")!
        textfield.textColor = UIColor(named: "AppFontColor")!
        textfield.font = UIFont(name: "Metropolis-SemiBold", size: 14)!
        
        textfield.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(systemName: "minus.circle.fill")
        imageView.tintColor = .red
        textfield.rightView = imageView
        
        imageView.tag = partnersNameTextfields.count
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteTextField(imageView:)))
        imageView.addGestureRecognizer(tap)
        
        return textfield
    }
    
    @objc private func deleteTextField(imageView: UITapGestureRecognizer) {
        let img = imageView.view as! UIImageView
        
        for tf in partnersNameTextfields {
            if tf.rightView === img {
                tf.rightView = nil
                tf.text = nil
                tf.removeFromSuperview()
                let index = partnersNameTextfields.firstIndex(of: tf)!
                partnersNameTextfields.remove(at: index)
                self.view.layoutSubviews()
            }
        }
    }
    
    func openMediaInFullScreen(media: MediaData?) {
        
        guard media != nil else { return }
        
        if media!.fileType == .pdf && media!.pdfData != nil {
            let vc = PDFViewerVC.instantiate()
            vc.localData = media!.pdfData
            present(vc, animated: true, completion: nil)
        } else if media!.image != nil {
            let vc = FullScreenVC.instantiate()
            vc.image = media!.image!
            present(vc, animated: true, completion: nil)
        }
        
    }

}



