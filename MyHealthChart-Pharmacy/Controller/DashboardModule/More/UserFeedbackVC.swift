//
//  UserFeedbackVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

extension UserFeedbackVC {
    static func instantiate() -> UserFeedbackVC {
        StoryBoardConstants.dashboard.instantiateViewController(withIdentifier: String(describing: UserFeedbackVC.self)) as! UserFeedbackVC
    }
}

class UserFeedbackVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var tableViewOrder: UITableView!
    
    private var orderData: [OrderFeedBackContentApiResponse] = []
    
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    
    private var selectedSeller : [FilterUserModel] = []
    private var fromDate = ""
    private var toDate = ""
    private var rating : Double? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Feedback"
        uiViewToolBar.btnSetting.isHidden = false
        setupTableView()
        getOrderFeedback(isLoading: true)
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        
    }
    
    private func setupTableView() {
        tableViewOrder.register(
            CompleteOrderTblCell.loadNib(),
            forCellReuseIdentifier: CompleteOrderTblCell.idetifire()
        )
        tableViewOrder.setRefreshControll { [self] in
            refresh()
        }
    }
    
}

extension UserFeedbackVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CompleteOrderTblCell.idetifire()) as! CompleteOrderTblCell
        
        if orderData.indices.contains(indexPath.row) {
            cell.orderFeedbackData = orderData[indexPath.row]
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrderDetailVC.instantiate()
        vc.orderId = orderData[indexPath.row].orderId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if pageNo <= totalPage && !isPaginating {
            executePagination(scrollView: scrollView)
        }
    }
    
    func executePagination(scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        // (tableViewMyCart.contentSize.height-10-scrollView.frame.size.height)
        let comparePosition = (tableViewOrder.contentSize.height-(-30)-scrollView.frame.size.height)
        
        if position > comparePosition {
            self.tableViewOrder.tableFooterView = Helper.shared.createSpinnerFooterView(view: self.view)
            getOrderFeedback()
        }
        
    }
    
}

extension UserFeedbackVC {
    
    private func getOrderFeedback(isLoading: Bool = false) {
        
        var selectedSellerIds : [String] = []
        
        for seller in selectedSeller {
            if seller.id == -1 {
                selectedSellerIds.removeAll()
                selectedSellerIds.append(seller.name)
                break
            }
            selectedSellerIds.append(
                seller.id < 0 ? seller.name : "\(seller.id)"
            )
        }
        
        var param = [
            Parameter.searchText: uiViewToolBar.searchBar.text ?? "",
            Parameter.pageNo: "\(pageNo)",
            Parameter.fromDate: DateHelper.shared.convertServerDate(oldDate: fromDate) ?? "",
            Parameter.toDate: DateHelper.shared.convertServerDate(oldDate: toDate) ?? "",
            Parameter.seller: selectedSellerIds.isEmpty ? ["all".lowercased()] : selectedSellerIds,
            Parameter.rating: rating == nil ? "" : rating! == 0 ? "" : "\(rating!)"
        ] as [String : Any]
        
        
        isPaginating = true
        
        
        if let seller = param[Parameter.seller]  as? [String] {
            
            let isContains = seller.contains { str in
                if str.lowercased() == "all" {
                    return true
                } else {
                    return false
                }
            }
            
            if isContains {
                param[Parameter.seller] = ["all"]
            }
        }
        
        
        Networking.request(
            url: Urls.getFeedbackList,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: isLoading,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            self.tableViewOrder.tableFooterView = nil
            self.isPaginating = false
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let orderFeedbackResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: OrderFeedBackApiResponse.self)
                    
                    guard let ofResponse = orderFeedbackResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if ofResponse.status == StatusCode.success.rawValue {
                        
                        self.totalPage = ofResponse.data?.totalPage ?? 0
                        
                        guard let content = ofResponse.data?.content else { return }
                        
                        if content.isEmpty {
                            self.orderData.removeAll()
                        } else {
                            self.orderData.append(contentsOf: content)
                            self.pageNo += 1
                        }
                        
                        self.tableViewOrder.reloadData()
                        
                    } else if ofResponse.status == StatusCode.notFound.rawValue {
                        
                        if self.orderData.isEmpty {
                            AlertHelper.shared.showAlert(message: ofResponse.message!)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: ofResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
    }
    
    
}


extension UserFeedbackVC: ToolBarDelegate, FilterDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getOrderFeedback()
        }
    }
    
    private func resetData() {
        pageNo = 1
        orderData.removeAll()
        tableViewOrder.reloadData()
    }
    
    func searchModePressed() {
        uiViewToolBar.setSearchMode(with: true)
        uiViewToolBar.btnSetting.isHidden = true
    }
    
    func searchPressed() {
        if uiViewToolBar.searchBar.isHidden {
            uiViewToolBar.btnSetting.isHidden = false
        }
        resetData()
        getOrderFeedback(isLoading: true)
    }
    
    func filterApplied(fromDate: String, toDate: String, selectedDeliveryBoy: [FilterUserModel], selectedSeller: [FilterUserModel], rating: Double?) {
        
        self.fromDate = fromDate
        self.toDate = toDate
        self.selectedSeller = selectedSeller
        self.rating = rating
        
        resetData()
        
        getOrderFeedback(isLoading: true)
    }
    
    func settingsPressed() {
        let vc = FilterVC.instantiate()
        vc.delegate = self
        vc.fromDate = fromDate
        vc.toDate = toDate
        vc.selectedSellerList = selectedSeller
        vc.rate = rating
        vc.isDeliveryBoyFilter = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
