//
//  UpcomingOrderVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 02/10/21.
//

import UIKit

extension UpcomingOrderVC {
    static func instantiate() -> UpcomingOrderVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: UpcomingOrderVC.self)) as! UpcomingOrderVC
    }
}

class UpcomingOrderVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var tableViewOrder: UITableView!
    
    private var orderData: [CommonOrderContentApiReponse] = []
    
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
        uiViewToolBar.labelTitle.text = "Upcoming"
        setupTableView()
        getUpcomingOrder(isLoading: true)
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

extension UpcomingOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTblCell.idetifire()) as! OrderTblCell
        
        if orderData.indices.contains(indexPath.row) {
            cell.upcomingData = orderData[indexPath.row]
        }
        
        cell.btnViewHandler = {
            self.navigateToDetailView(index: indexPath.row)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetailView(index: indexPath.row)
    }
    
    private func navigateToDetailView(index: Int) {
        let vc = OrderDetailVC.instantiate()
        vc.orderId = orderData[index].orderId ?? ""
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
            getUpcomingOrder()
        }
        
    }
    
}

extension UpcomingOrderVC {
    
    private func getUpcomingOrder(isLoading: Bool = false) {

        isPaginating = true
        
        let param = [
            Parameter.searchText: searchText,
            Parameter.pageNo: "\(pageNo)"
        ]
        
        Networking.request(
            url: Urls.upcomingOrderList,
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
                    
                    let upcomingResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonOrderApiReponse.self)
                    
                    guard let upResponse = upcomingResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if upResponse.status == StatusCode.success.rawValue {
                        
                        self.totalPage = upResponse.data?.totalPage ?? 0
                        
                        guard let content = upResponse.data?.content else { return }
                        
                        if content.isEmpty {
                            self.orderData.removeAll()
                        } else {
                            self.orderData.append(contentsOf: content)
                            self.pageNo += 1
                        }
                        
                        self.tableViewOrder.reloadData()
                        
                    } else if upResponse.status == StatusCode.notFound.rawValue {
                        
                        if self.orderData.isEmpty {
                            AlertHelper.shared.showAlert(message: upResponse.message!)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: upResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
    }
    
    
}

extension UpcomingOrderVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getUpcomingOrder()
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
        getUpcomingOrder(isLoading: true)
    }
}
