//
//  UnpaidVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Miral vadher on 17/05/22.
//

import UIKit


extension UnpaidVC {
    static func instantiate() -> UnpaidVC {
        StoryBoardConstants.ledgerstatement.instantiateViewController(withIdentifier: String(describing: UnpaidVC.self)) as! UnpaidVC
    }
}
class UnpaidVC: UIViewController {

    @IBOutlet weak var lblTotalOrders: UILabel!
    @IBOutlet weak var tableViewOrder: UITableView!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    var UnpaidOrderData: LdgerStatementApiMOdel?
    var UnpaidData : [UnpidlDataApiResponse] = []
    //private var UnpaidOrderData: [LdgerStatementApiMOdel] = []
    
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    private var searchText = ""
    
   
    private var fromDate = ""
    private var toDate = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
  
    private func setupView() {
     getUnpaidOrderList(isLoading: true)
      setupTableView()
     
        
        
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

extension UnpaidVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.UnpaidData.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CompleteOrderTblCell.idetifire()) as! CompleteOrderTblCell
        cell.uiViewStarView.isHidden = true
        cell.ladgerDatestackView.isHidden = false
        
        if UnpaidData.indices.contains(indexPath.row) {
            cell.UnpaidData = UnpaidData[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrderDetailVC.instantiate()
        vc.orderId = UnpaidData[indexPath.row].order_id ?? ""
       
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
            getUnpaidOrderList()
        }
        
    }
    
}

extension UnpaidVC {
    
    private func getUnpaidOrderList(isLoading: Bool = false) {
        
        isPaginating = true
        
        var param = [Parameter.paymentStatus: "unpaid", Parameter.pageNo: "\(pageNo)"] as [String : Any]
        
        Networking.request(
            url: Urls.ledgersheetlist,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: isLoading,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            self.tableViewOrder.tableFooterView = nil
            self.isPaginating = false
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    
                    let t = try! JSONDecoder().decode(LdgerStatementApiMOdel.self, from: jsonData)
                    print(t)
                    
                    
                    let upcomingResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: LdgerStatementApiMOdel.self)
        
                    guard let Unresponce = upcomingResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if Unresponce.status == StatusCode.success.rawValue{
                        
                        self.lblTotalOrders.text = Unresponce.num_of_order
                        self.lblTotalAmount.text =   "₹ \(Unresponce.total_amount ?? "")"
                        
                        guard let content = Unresponce.data else { return }
                        
                        if content.isEmpty {
                            self.UnpaidData.removeAll()
                        } else {
                            self.UnpaidData.append(contentsOf: content)
                            self.pageNo += 1
                        }
                        self.tableViewOrder.reloadData()
                    }
                    else {
                        AlertHelper.shared.showAlert(message: Unresponce.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
    }
}

extension UnpaidVC: MyTeamDelegate, FilterDelegate {
    
    func searchList(searchText: String) {
        self.searchText = searchText
        resetData()
        getUnpaidOrderList()
    }
    
    func settingsPressed() {
        let vc = FilterVC.instantiate()
        vc.delegate = self
        vc.fromDate = fromDate
        vc.toDate = toDate
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterApplied(fromDate: String, toDate: String, selectedDeliveryBoy: [FilterUserModel], selectedSeller: [FilterUserModel], rating: Double?) {
        
        self.fromDate = fromDate
        self.toDate = toDate
        resetData()
        getUnpaidOrderList(isLoading: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getUnpaidOrderList()
        }
    }
    
    private func resetData() {
        pageNo = 1
        UnpaidData.removeAll()
        tableViewOrder.reloadData()
    }
    
    
}
