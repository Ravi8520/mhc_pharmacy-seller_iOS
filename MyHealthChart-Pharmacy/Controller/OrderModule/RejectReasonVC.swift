//
//  RejectReasonVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 06/10/21.
//

import UIKit

protocol RejectReasonDelegate {
    func rejectReasonSelected(id: Int, msg: String)
}

extension RejectReasonVC {
    static func instantiate() -> RejectReasonVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: RejectReasonVC.self)) as! RejectReasonVC
    }
}

class RejectReasonVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var tableViewReason: UITableView!
    
    private var reasoanDataSource: [RejectReasonDataApiResponse] = []
    
    var delegate: RejectReasonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Select Reason"
        uiViewToolBar.btnSearch.isHidden = true
        
        tableViewReason.rowHeight = UITableView.automaticDimension
        tableViewReason.estimatedRowHeight = 10
        getRejectReason()
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        tableViewReason.setRefreshControll { [self] in
            refresh()
        }
    }

}

extension RejectReasonVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reasoanDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RejectReasonTblCell") as! RejectReasonTblCell
        
        if reasoanDataSource.indices.contains(indexPath.row) {
            cell.labelReason.text = reasoanDataSource[indexPath.row].reason
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.dismiss(animated: true) { [self] in
            let rejectReason = reasoanDataSource[indexPath.row]
            delegate?.rejectReasonSelected(
                id: rejectReason.id!,
                msg: rejectReason.reason ?? ""
            )
        }
    }
    
    
}

extension RejectReasonVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("\(#file)Back pressed")
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func refresh() {
        resetData()
        getRejectReason()
    }
    
    private func resetData() {
        reasoanDataSource.removeAll()
        tableViewReason.reloadData()
    }
    
}

extension RejectReasonVC {
    
    private func getRejectReason() {
        
        Networking.request(
            url: Urls.rejectReason,
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
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let reasonResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: RejectReasonApiResponse.self)
                    
                    guard let rrResponse = reasonResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if rrResponse.status == StatusCode.success.rawValue {
                        
                        if let reasons = rrResponse.data {
                            reasoanDataSource.removeAll()
                            reasoanDataSource = reasons
                        }
                        
                        tableViewReason.reloadData()
                        
                    } else {
                        AlertHelper.shared.showAlert(message: rrResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
}

class RejectReasonTblCell: UITableViewCell {
    
    @IBOutlet weak var labelReason: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //selectionStyle = .none
    }
}
