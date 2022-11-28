//
//  ResumeShopPopupVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 04/10/21.
//

import UIKit

extension ResumeShopPopupVC {
    static func instantiate() -> ResumeShopPopupVC {
        StoryBoardConstants.popup.instantiateViewController(withIdentifier: String(describing: ResumeShopPopupVC.self)) as! ResumeShopPopupVC
    }
}

class ResumeShopPopupVC: UIViewController {

    @IBOutlet weak var uiViewPopup: UIView!
    
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelTime: UILabel!
    
    var resumeShopHandler: ((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        uiViewPopup.setCornerRadius(radius: 16)
    }
    
    @IBAction func btnDatePressed(_ sender: UIButton) {
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseDateTitle,
            Format: DateHelper.DateStrings.appDateFormat,
            Mode: .date,
            YesActionTitle: Strings.doneButtonTitle,
            NoActionTitle: Strings.cancelOption,
            minimumDate: Date(),
            maximumDate: nil) { [self] dateString in
            labelDate.text = dateString
        } NoAction: { noAction in }
    }
    
    @IBAction func btnTimePressed(_ sender: UIButton) {
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseTimeTitle,
            Format: DateHelper.DateStrings.appTimeFormat,
            Mode: .time,
            YesActionTitle: Strings.doneButtonTitle,
            NoActionTitle: Strings.cancelOption,
            minimumDate: nil,
            maximumDate: nil) { [self] dateString in
            labelTime.text = dateString
        } NoAction: { noAction in }
    }
    

    @IBAction func btnApplyPressed(_ sender: AppThemeButton) {
        
        if labelDate.text == "Date" {
            AlertHelper.shared.showAlert(message: Strings.setDate)
        } else if labelTime.text == "Time" {
            AlertHelper.shared.showAlert(message: Strings.setTime)
        } else {
            resumeShopApi()
        }
        
        
    }
    
    @IBAction func btnCanclePressed(_ sender: BorderButton) {
        setShop(isOpen: false)
    }
    
    

}

extension ResumeShopPopupVC {
    
    private func resumeShopApi() {

        let date = DateHelper.shared.convertServerDate(oldDate: labelDate.text)
        let time = DateHelper.shared.convertServerTime(appTime: labelTime.text)
        
        let param = [
            Parameter.pharmacyStatus: false,
            Parameter.date: "\(date ?? "") \(time ?? "")"
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
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let cpResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let rpResponse = cpResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if rpResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: rpResponse.message!, duration: .normal) { [self] in
                            
                            setShop(isOpen: true)
                            
                        }
                        
                    } else {
                        
                        AlertHelper.shared.showAlert(message: rpResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e("Change pharmacy status error:- \(error.localizedDescription)")
                    
            }
            
            
        }
        
    }
    
    private func setShop(isOpen: Bool) {
        resumeShopHandler?(isOpen)
        self.navigationController?.popViewController(animated: false)
    }
    
}
