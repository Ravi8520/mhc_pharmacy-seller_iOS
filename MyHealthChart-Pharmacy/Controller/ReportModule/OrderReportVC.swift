//
//  OrderReportVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

extension OrderReportVC {
    static func instantiate() -> OrderReportVC {
        StoryBoardConstants.report.instantiateViewController(withIdentifier: String(describing: OrderReportVC.self)) as! OrderReportVC
    }
}

class OrderReportVC: UIViewController {

    @IBOutlet weak var tableViewOrder: UITableView!
    
    private var orderData: [OrderReportListContentApiReponse] = []
    
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    private var searchText = ""
    
    private var selectedSeller: [FilterUserModel] = []
    private var selectedDeliveryBoy: [FilterUserModel] = []
    private var fromDate = ""
    private var toDate = ""
    private var rating : Double? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReportTabbarVC.delegate = self
    }
    
    private func setupView() {
        setupTableView()
        getOrderReportList(isLoading: true)
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

extension OrderReportVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { orderData.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CompleteOrderTblCell.idetifire()) as! CompleteOrderTblCell
        
        if orderData.indices.contains(indexPath.row) {
            cell.orderReportData = orderData[indexPath.row]
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
            getOrderReportList()
        }
        
    }
    
}

extension OrderReportVC {
    
    private func getOrderReportList(isLoading: Bool = false) {
                
        var selectedSellerIds : [String] = []
        var selectedDeliveryBoyIds : [String] = []
        
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
        
        for deliveryBoy in selectedDeliveryBoy {
            if deliveryBoy.id == -1 {
                selectedDeliveryBoyIds.removeAll()
                selectedDeliveryBoyIds.append(deliveryBoy.name)
                break
            }
            selectedDeliveryBoyIds.append(
                deliveryBoy.id < 0 ? deliveryBoy.name : "\(deliveryBoy.id)"
            )
        }
        
        isPaginating = true
        
        var param = [
            Parameter.searchText: searchText,
            Parameter.pageNo: "\(pageNo)",
            Parameter.fromDate: DateHelper.shared.convertServerDate(oldDate: fromDate) ?? "",
            Parameter.toDate: DateHelper.shared.convertServerDate(oldDate: toDate) ?? "",
            Parameter.seller: selectedSellerIds.isEmpty ? ["all".lowercased()] : selectedSellerIds,
            Parameter.deliveryBoy: selectedDeliveryBoyIds.isEmpty ? ["all".lowercased()] : selectedDeliveryBoyIds,
            Parameter.rating: rating == nil ? "" : rating! == 0 ? "" : "\(rating!)"
        ] as [String : Any]
        
        
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
        
        if let deliveryBoy = param[Parameter.deliveryBoy]  as? [String] {
            
            let isContains = deliveryBoy.contains { str in
                if str.lowercased() == "all" {
                    return true
                } else {
                    return false
                }
            }
            
            if isContains {
                param[Parameter.deliveryBoy] = ["all"]
            }
        }
        
        
        Networking.request(
            url: Urls.orderReport,
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
                    
                    let upcomingResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: OrderReportListApiReponse.self)
                    
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
                            //AlertHelper.shared.showAlert(message: upResponse.message!)
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

extension OrderReportVC: MyTeamDelegate, FilterDelegate {
    
    func searchList(searchText: String) {
        self.searchText = searchText
        resetData()
        getOrderReportList()
    }
    
    func settingsPressed() {
        let vc = FilterVC.instantiate()
        vc.delegate = self
        vc.fromDate = fromDate
        vc.toDate = toDate
        vc.selectedSellerList = selectedSeller
        vc.selectedDeliveryList = selectedDeliveryBoy
        vc.rate = rating
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterApplied(fromDate: String, toDate: String, selectedDeliveryBoy: [FilterUserModel], selectedSeller: [FilterUserModel], rating: Double?) {
        
        self.fromDate = fromDate
        self.toDate = toDate
        self.selectedSeller = selectedSeller
        self.selectedDeliveryBoy = selectedDeliveryBoy
        self.rating = rating
        
        resetData()
        
        getOrderReportList(isLoading: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getOrderReportList()
        }
    }
    
    private func resetData() {
        pageNo = 1
        orderData.removeAll()
        tableViewOrder.reloadData()
    }
    
    
}
