//
//  OutForDeliveryVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 02/10/21.
//

import UIKit
 
extension OutForDeliveryVC {
    static func instantiate() -> OutForDeliveryVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: OutForDeliveryVC.self)) as! OutForDeliveryVC
    }
}

class OutForDeliveryVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var tableViewOrder: UITableView!
    
    private var orderData: [OutForDeliveryContentApiResponse] = []
    
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
        uiViewToolBar.labelTitle.text = "Out for delivery"
        setupTableView()
        getOutForDeliveryOrder(isLoading: true)
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

extension OutForDeliveryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTblCell.idetifire()) as! OrderTblCell
        
        if orderData.indices.contains(indexPath.row) {
            cell.outForDeliveryData = orderData[indexPath.row]
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
            getOutForDeliveryOrder()
        }
        
    }
    
}

extension OutForDeliveryVC {
    
    private func getOutForDeliveryOrder(isLoading: Bool = false) {
        
        isPaginating = true
        
        let param = [
            Parameter.searchText: searchText,
            Parameter.pageNo: "\(pageNo)"
        ]
        
        Networking.request(
            url: Urls.outForDeliveryOrderList,
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
                    
                    let orderResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: OutForDeliveryOrderApiResponse.self)
                    
                    guard let odResponse = orderResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if odResponse.status == StatusCode.success.rawValue {
                        
                        self.totalPage = odResponse.data?.totalPage ?? 0
                        
                        guard let content = odResponse.data?.content else { return }
                        
                        if content.isEmpty {
                            self.orderData.removeAll()
                        } else {
                            self.orderData.append(contentsOf: content)
                            self.pageNo += 1
                        }
                        
                        self.tableViewOrder.reloadData()
                        
                    } else if odResponse.status == StatusCode.notFound.rawValue {
                        
                        if self.orderData.isEmpty {
                            AlertHelper.shared.showAlert(message: odResponse.message!)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: odResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
    }
    
}

extension OutForDeliveryVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getOutForDeliveryOrder()
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
        getOutForDeliveryOrder(isLoading: true)
    }
    
}
