//
//  ReturnOrderVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 30/09/21.
//

import UIKit

extension ReturnOrderVC {
    static func instantiate() -> ReturnOrderVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: ReturnOrderVC.self)) as! ReturnOrderVC
    }
}

class ReturnOrderVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var tableViewOrder: UITableView!
    
    private var orderData: [ReturnOrderContentApiResponse] = []
    
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    private var searchText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Incomplete Orders"
        uiViewToolBar.btnBack.isHidden = true
        setupTableView()
        getReturnOrderList(isLoading: true)
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        
    }
    
    private func setupTableView() {
        tableViewOrder.register(
            OrderTblCell.loadNib(),
            forCellReuseIdentifier: OrderTblCell.idetifire()
        )
        tableViewOrder.setRefreshControll { [self] in
            refresh()
        }
    }
    
}

extension ReturnOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTblCell.idetifire()) as! OrderTblCell
        
        if orderData.indices.contains(indexPath.row) {
            cell.returnOrderData = orderData[indexPath.row]
        }
        
        cell.btnViewHandler = {
            self.returnConfirmOrder(id: self.orderData[indexPath.row].orderId ?? "")
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
            getReturnOrderList()
        }
        
    }
    
}

extension ReturnOrderVC {
    
    private func getReturnOrderList(isLoading: Bool = false) {
        
        isPaginating = true
        
        let param = [
            Parameter.searchText: searchText,
            Parameter.pageNo: "\(pageNo)"
        ]
        
        Networking.request(
            url: Urls.returnOrderList,
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
                    
                    let returnOrderResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: ReturnOrderApiResponse.self)
                    
                    guard let roResponse = returnOrderResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if roResponse.status == StatusCode.success.rawValue {
                        
                        self.totalPage = roResponse.data?.totalPage ?? 0
                        
                        guard let content = roResponse.data?.content else { return }
                        
                        if content.isEmpty {
                            self.orderData.removeAll()
                        } else {
                            self.orderData.append(contentsOf: content)
                            self.pageNo += 1
                        }
                        
                        self.tableViewOrder.reloadData()
                        
                    } else if roResponse.status == StatusCode.notFound.rawValue {
                        
                        if self.orderData.isEmpty {
                            AlertHelper.shared.showAlert(message: roResponse.message!)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: roResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
        
    }
    
    private func returnConfirmOrder(id: String) {
        
        let param = [
            Parameter.orderId: id
        ]
        
        Networking.request(
            url: Urls.confirmReturnOrder,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
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
                    
                    let returnOrderResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let roResponse = returnOrderResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if roResponse.status == StatusCode.success.rawValue {
                      
                        AlertHelper.shared.showToast(message: roResponse.message!, duration: .normal) {
                            self.refresh()
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: roResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
        
    }
    
}

extension ReturnOrderVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getReturnOrderList()
        }
    }
    
    private func resetData() {
        pageNo = 1
        orderData.removeAll()
        tableViewOrder.reloadData()
    }
    
    func searchModePressed() {
        uiViewToolBar.setSearchMode(with: true)
    }
    
    func searchPressed() {
        searchText = uiViewToolBar.searchBar.text ?? ""
        resetData()
        getReturnOrderList(isLoading: true)
    }
    
}
