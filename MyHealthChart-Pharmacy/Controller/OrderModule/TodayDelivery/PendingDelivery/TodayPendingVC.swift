//
//  TodayPendingVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 04/10/21.
//

import UIKit

extension TodayPendingVC {
    static func instantiate() -> TodayPendingVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: TodayPendingVC.self)) as! TodayPendingVC
    }
}

class TodayPendingVC: UIViewController {

    @IBOutlet weak var tableViewOrder: UITableView!
    
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    private var searchText = ""
    
    private var orderData: [TodayPendingOrderContentApiResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwipableTabBarVC.delegate = self
    }
    
    private func setupView() {
        setupTableView()
        getPendingOrder(isLoading: true)
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

extension TodayPendingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTblCell.idetifire()) as! OrderTblCell
        
        if orderData.indices.contains(indexPath.row) {
            cell.todayPendingOrderData = orderData[indexPath.row]
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
            getPendingOrder()
        }
        
    }
    
}

extension TodayPendingVC {
    
    private func getPendingOrder(isLoading: Bool = false) {
        
        isPaginating = true
        
        let param = [
            Parameter.searchText: searchText,
            Parameter.pageNo: "\(pageNo)",
        ]
        
        Networking.request(
            url: Urls.todayPendingDelivery,
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
                    
                    let pendingOrderResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: TodayPendingOrderApiResponse.self)
                    
                    guard let poResponse = pendingOrderResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if poResponse.status == StatusCode.success.rawValue {
                        
                        self.totalPage = poResponse.data?.totalPage ?? 0
                        
                        guard let content = poResponse.data?.content else { return }
                        
                        if content.isEmpty {
                            self.orderData.removeAll()
                        } else {
                            self.orderData.append(contentsOf: content)
                            self.pageNo += 1
                        }
                        
                        self.tableViewOrder.reloadData()
                        
                    } else if poResponse.status == StatusCode.notFound.rawValue {
                        
                        if self.orderData.isEmpty {
                            //AlertHelper.shared.showAlert(message: poResponse.message!)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: poResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
        
    }
    
}

extension TodayPendingVC: MyTeamDelegate {
    
    func searchList(searchText: String) {
        self.searchText = searchText
        resetData()
        getPendingOrder()
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getPendingOrder()
        }
    }
    
    private func resetData() {
        pageNo = 1
        orderData.removeAll()
        tableViewOrder.reloadData()
    }
    
}
