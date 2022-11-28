//
//  AgreementVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 01/10/21.
//

import UIKit
import WebKit

extension AgreementVC {
    static func instantiate() -> AgreementVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: AgreementVC.self)) as! AgreementVC
    }
}

class AgreementVC: UIViewController {
    
    @IBOutlet weak var webViewAgreement: WKWebView!
    
    @IBOutlet weak var imageViewCheckBox: UIImageView!
    
    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    var apiToken = ""
    var userId : Int?
    
    var webView = ""
    
    private var isAgreementSelected = false
    
    //    private var localData: Data?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpView()
    }
    
    private func setUpView() {
        uiViewToolBar.labelTitle.text = "Agreement"
        uiViewToolBar.btnSearch.isHidden = true
        
        setData()
        setUpDelegates()
    }
    
    private func setUpDelegates() {
        uiViewToolBar.delegate = self
    }
    
    func setData(){
        
        webViewAgreement.load(NSURLRequest(url: NSURL(string: webView)! as URL) as URLRequest)
    }
    
    
    @IBAction func btnAgreementAgreePressed(_ sender: UIButton) { // square
        //
        isAgreementSelected.toggle()
        imageViewCheckBox.image = isAgreementSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        imageViewCheckBox.tintColor = isAgreementSelected ? .appColor.appThemeColor : .systemGray
    }
    
    
    @IBAction func btnSubmitPressed(_ sender: HalfCornerButton) {
        
        if isAgreementSelected {
            getAgreement()
        } else {
            AlertHelper.shared.showAlert(message: Strings.agreeTermsAndConditionMesssage)
        }
        
    }
    
    
    

}

extension AgreementVC: ToolBarDelegate {
    
    func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getAgreement() {
        
        let param = [
            Parameter.apiToken: apiToken,
            Parameter.id: userId ?? 0,
            Parameter.isAccept : isAgreementSelected
        ] as [String : Any]
        print("params==>>", param)
        
        Networking.request(
            url: Urls.getAgreement,
            method: .post,
            headers: nil,
            defaultHeader: false,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let agreementResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let agResponse = agreementResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if agResponse.status == StatusCode.success.rawValue {
                        
                        navigateToThankYouPopup()

                    } else {
                        AlertHelper.shared.showAlert(message: agResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    
    private func navigateToThankYouPopup() {
        self.navigationController?.pushViewController(
            ThankyouVC.instantiate(),
            animated: false
        )
    }
}
