//
//  InternalDeliveryVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 04/10/21.
//

import UIKit

extension InternalDeliveryVC {
    static func instantiate() -> InternalDeliveryVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: InternalDeliveryVC.self)) as! InternalDeliveryVC
    }
}

class InternalDeliveryVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var tableViewOrder: UITableView!
    
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    
    private var orderData: [DeliveryContentApiResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
       
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Internal Delivery"
        setupTableView()
        getInternalDelivery(isLoading: true)
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        
    }
    
    private func setupTableView() {
        tableViewOrder.register(
            TodayOrderTblCell.loadNib(),
            forCellReuseIdentifier: TodayOrderTblCell.idetifire()
        )
        tableViewOrder.setRefreshControll { [self] in
            refresh()
        }
    }
    

}

extension InternalDeliveryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayOrderTblCell.idetifire()) as! TodayOrderTblCell
        
        if orderData.indices.contains(indexPath.row) {
            cell.deliveryData = orderData[indexPath.row]
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
            getInternalDelivery()
        }
        
    }
    
}

extension InternalDeliveryVC {
    
    private func getInternalDelivery(isLoading: Bool = false) {
        
        isPaginating = true
        
        let param = [
            Parameter.searchText: uiViewToolBar.searchBar.text ?? "",
            Parameter.pageNo: "\(pageNo)",
        ]
        
        Networking.request(
            url: Urls.internalDeliveryList,
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
                    
                    let deliveryResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: DeliveryApiResponse.self)
                    
                    guard let dResponse = deliveryResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if dResponse.status == StatusCode.success.rawValue {
                        
                        self.totalPage = dResponse.data?.totalPage ?? 0
                        
                        guard let content = dResponse.data?.content else { return }
                        
                        if content.isEmpty {
                            self.orderData.removeAll()
                        } else {
                            self.orderData.append(contentsOf: content)
                            self.pageNo += 1
                        }
                        
                        self.tableViewOrder.reloadData()
                        
                    } else if dResponse.status == StatusCode.notFound.rawValue {
                        
                        if self.orderData.isEmpty {
                            AlertHelper.shared.showAlert(message: dResponse.message!)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: dResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
        
    }
    
}

extension InternalDeliveryVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getInternalDelivery()
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
        resetData()
        getInternalDelivery(isLoading: true)
    }
    
}
