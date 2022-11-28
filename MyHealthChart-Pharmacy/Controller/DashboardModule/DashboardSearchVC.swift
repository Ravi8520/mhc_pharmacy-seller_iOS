//
//  DashboardSearchVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 06/10/21.
//

import UIKit

extension DashboardSearchVC {
    static func instantiate() -> DashboardSearchVC {
        StoryBoardConstants.dashboard.instantiateViewController(withIdentifier: String(describing: DashboardSearchVC.self)) as! DashboardSearchVC
    }
}

class DashboardSearchVC: UIViewController {

    @IBOutlet weak var tableViewOrder: UITableView!
    
    @IBOutlet weak var uiViewCard: UIView!
    @IBOutlet weak var uiViewCornerRadius: UIView!
    
    @IBOutlet var viewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var orderData:[DashBoardSearchDataApiReponse] = []
    
    private var isPaginating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        setupHeight()
        uiViewCard.setCornerRadius(radius: 14, isMaskedToBound: true)
        searchBar.delegate = self
    
        setupTableView()
    }
    
    private func setupHeight() {
        
        let height = CGFloat(orderData.count * 150) + 44
        
        if height > AppConfig.screenHight {
            viewHeight.constant = AppConfig.screenHight - 22
        } else {
            viewHeight.constant = height
        }
        
    }
    
    private func setupTableView() {
        tableViewOrder.register(
            OrderTblCell.loadNib(),
            forCellReuseIdentifier: OrderTblCell.idetifire()
        )
        tableViewOrder.register(
            CompleteOrderTblCell.loadNib(),
            forCellReuseIdentifier: CompleteOrderTblCell.idetifire()
        )
        tableViewOrder.setRefreshControll { [self] in
            refresh()
        }
        
    }
    
    @IBAction func btnDismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension DashboardSearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTblCell.idetifire()) as! OrderTblCell
        
        if orderData.indices.contains(indexPath.row) {
            
            if orderData[indexPath.row].orderStatus == OrderStatus.completed.serverString {
                
                let completeOrderCell = tableView.dequeueReusableCell(withIdentifier: CompleteOrderTblCell.idetifire()) as! CompleteOrderTblCell
                
                completeOrderCell.dashboardSearch = orderData[indexPath.row]
                
                return completeOrderCell
                
            } else {
       
                cell.dashboardSearch = orderData[indexPath.row]
                
                cell.btnViewHandler = { [self] in
                    
                    switch orderData[indexPath.row].orderStatus {
                            
                        case OrderStatus.accepted.serverString,
                            OrderStatus.readyforpickup.serverString:
                            
                            assignOrder(index: indexPath.row)
                            
                        case OrderStatus.returned.serverString:
                            confirmReturn(index: indexPath.row)
                        default:
                            navigateToDetail(index: indexPath.row)
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetail(index: indexPath.row)
    }
    
    private func navigateToDetail(index: Int) {
        let vc = OrderDetailVC.instantiate()
        vc.orderId = "\(orderData[index].orderId ?? 0)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func assignOrder(index: Int) {
        let vc = InvoiceUploadVC.instantiate()
        vc.delegate = self
        vc.orderId = "\(orderData[index].orderId ?? 0)"
        vc.screenType = orderData[index].isLogisticDelivery == "true" ? .reassignOrder : .assignOrder
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func confirmReturn(index: Int) {
        returnConfirmOrder(id: "\(orderData[index].orderId ?? 0)")
    }
   
}

extension DashboardSearchVC: UISearchBarDelegate, OrderUpdateDelegate {
    
    func orderUpdated(vc: UIViewController) {
        vc.navigationController?.popViewController(animated: false)
        getSearchedOrder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getSearchedOrder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        orderData.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
}

extension DashboardSearchVC {
    
    private func getSearchedOrder() {
        
        let param = [
            Parameter.searchText: searchBar.text ?? ""
        ]
        
        isPaginating = true
        
        Networking.request(
            url: Urls.dashboardSearch,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            self.isPaginating = false
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let orderResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: DashBoardSearchApiReponse.self)
                    
                    guard let oResponse = orderResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if oResponse.status == StatusCode.success.rawValue {
                        
                        if let data = oResponse.data {
                            resetData()
                            orderData = data
                        }
                        
                    } else {
                        resetData()
                        AlertHelper.shared.showAlert(message: oResponse.message!)
                    }
                    
                    setupHeight()
                    tableViewOrder.reloadData()
                    
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
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getSearchedOrder()
        }
    }
    
    private func resetData() {
        orderData.removeAll()
        tableViewOrder.reloadData()
    }
    
}
