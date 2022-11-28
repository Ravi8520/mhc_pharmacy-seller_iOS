//
//  NewAgreementVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Mac Mini on 14/04/22.
//

import UIKit
import WebKit

extension NewAgreementVC {
    static func instantiate() -> NewAgreementVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: NewAgreementVC.self)) as! NewAgreementVC
    }
}

class NewAgreementVC: UIViewController {

    @IBOutlet weak var webViewAgreement: WKWebView!
    
    @IBOutlet weak var imageViewCheckBox: UIImageView!
    
    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    var apiToken = ""
    var userId: Int?
    
    var webView = ""
    
    private var isAgreementSelected = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAgreementNewLogin()

    }
    
    private func setUpView() {
        uiViewToolBar.labelTitle.text = "Agreement"
        uiViewToolBar.btnSearch.isHidden = true
        
        setUpDelegates()
    }
    
    private func setUpDelegates() {
        uiViewToolBar.delegate = self
    }
    
//
    func setData(){


    }

    
    @IBAction func btnAgreementAgreePressed(_ sender: UIButton) { // square
        //
        isAgreementSelected.toggle()
        imageViewCheckBox.image = isAgreementSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        imageViewCheckBox.tintColor = isAgreementSelected ? .appColor.appThemeColor : .systemGray
    }
    
    
    @IBAction func btnSubmitPressed(_ sender: HalfCornerButton) {
        
        if isAgreementSelected {
            navigateToLogin()
        } else {
            AlertHelper.shared.showAlert(message: Strings.agreeTermsAndConditionMesssage)
        }
        
    }


}


extension NewAgreementVC: ToolBarDelegate {
    
    func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }

    
    private func getAgreementNewLogin() {
        
        let param = [
            Parameter.apiToken: apiToken,
            Parameter.id: userId ?? 0
        ] as [String : Any]
        print("params==>>", param)
        
        Networking.request(
            url: Urls.checkNewAgreement,
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
                
                let agreementResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: AgreementApiResponse.self)
                
                guard let agResponse = agreementResponse else {
                    AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                    return
                }
                
                if agResponse.status == StatusCode.success.rawValue {
                    
                    self.webViewAgreement.load(NSURLRequest(url: NSURL(string: agResponse.data?.agreement ?? "")! as URL) as URLRequest)
//                        navigateToLogin()
                    
                } else {
                    AlertHelper.shared.showAlert(message: agResponse.message!)
                }
                
            case .failure(let error):
                AlertHelper.shared.showAlert(message: error.localizedDescription)
                Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func navigateToLogin() {
        let vc = LoginVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
}
