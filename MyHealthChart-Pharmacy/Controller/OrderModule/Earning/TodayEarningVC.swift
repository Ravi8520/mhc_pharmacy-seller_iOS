//
//  TodayEarningVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 04/10/21.
//

import UIKit

extension TodayEarningVC {
    static func instantiate() -> TodayEarningVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: TodayEarningVC.self)) as! TodayEarningVC
    }
}

class TodayEarningVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var tableViewOrder: UITableView!
    
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    
    private var orderData: [EarningContentApiResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Today Earning"
        setupTableView()
        getTodayEarningData(isLoading: true)
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

extension TodayEarningVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayOrderTblCell.idetifire()) as! TodayOrderTblCell
        
        if orderData.indices.contains(indexPath.row) {
            cell.data = orderData[indexPath.row]
        }
        
        return cell
        
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
            getTodayEarningData()
        }
        
    }
    
}

extension TodayEarningVC {
    
    private func getTodayEarningData(isLoading: Bool = false) {
        
//        {"searchText": "","pageNo": "1","dataType": "month","date": ""}
        
        isPaginating = true
        
        let param = [
            Parameter.searchText: uiViewToolBar.searchBar.text ?? "",
            Parameter.pageNo: "\(pageNo)",
            Parameter.dataType: "day",
            Parameter.date: DateHelper.shared.getCurrentServerFormatDate()
        ]
        
        Networking.request(
            url: Urls.getEarningData,
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
                    
                    let earningDataResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: EarningApiResponse.self)
                    
                    guard let edResponse = earningDataResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if edResponse.status == StatusCode.success.rawValue {
                        
                        self.totalPage = edResponse.data?.totalPage ?? 0
                        
                        guard let content = edResponse.data?.content else { return }
                        
                        if content.isEmpty {
                            self.orderData.removeAll()
                        } else {
                            self.orderData.append(contentsOf: content)
                            self.pageNo += 1
                        }
                        
                        self.tableViewOrder.reloadData()
                        
                    } else if edResponse.status == StatusCode.notFound.rawValue {
                        
                        if self.orderData.isEmpty {
                            AlertHelper.shared.showAlert(message: edResponse.message!)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: edResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
        
    }
    
}

extension TodayEarningVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getTodayEarningData()
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
        getTodayEarningData(isLoading: true)
    }
    
}
