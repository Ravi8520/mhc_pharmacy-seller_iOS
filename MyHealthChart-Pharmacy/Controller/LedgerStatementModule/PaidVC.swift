//
//  PaidVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Miral vadher on 17/05/22.
//

import UIKit



extension PaidVC {
    static func instantiate() -> PaidVC {
        StoryBoardConstants.ledgerstatement.instantiateViewController(withIdentifier: String(describing: PaidVC.self)) as! PaidVC
    }
}

class PaidVC: UIViewController, navirateToDetailScreenDelegate {
    
    
    
    func navigateToDetailScreenPaid(OrderID: String) {
        let vc = OrderDetailVC.instantiate()
        vc.orderId = OrderID
        vc.status = "paid"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var tblView: UITableView!
    private var orderData: [OrderReportListContentApiReponse] = []
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    private var searchText = ""
    
    private var selectedSeller: [FilterUserModel] = []
    private var selectedDeliveryBoy: [FilterUserModel] = []
    private var fromDate = ""
    private var toDate = ""
    var isSelect = false
    
    var height :CGFloat = 0.0
    
    var indexPaths :[Int] = []
    
    var PaidOrderdata: PaidOrderAPIResponse?
    var PaidData : [paidDataList] = []
    var orderDataList : [OrderData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupTableView()
        getPaidOrderList(isLoading: true)
    }
    private func setupTableView() {
        
        
        tblView.register(
            CompleteOrderTblCell.loadNib(),
            forCellReuseIdentifier: CompleteOrderTblCell.idetifire()
        )
        tblView.setRefreshControll { [self] in
            refresh()
        }
    }
    @objc func btnArrowPressed(_ sender: UIButton){
        if isSelect == true{
            self.isSelect = false
            self.indexPaths.removeAll()
            
            self.tblView.reloadData()
            
        }else{
            self.isSelect = true
            self.indexPaths.append(sender.tag)
            self.tblView.reloadData()
            
        }
    }
}
extension PaidVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaidData.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaidTblCell") as! PaidTblCell
        cell.imageVieww?.transform = CGAffineTransform(rotationAngle:0)
        cell.btnArrowDown.tag = indexPath.row
        cell.btnArrowDown.addTarget(self, action: #selector(btnArrowPressed), for: .touchUpInside)
    
        if self.isSelect == true && self.indexPaths.contains(indexPath.row){
            cell.imageVieww?.transform = CGAffineTransform.init(rotationAngle: .pi)
            cell.innerTableView.isHidden = false
            cell.delegate = self
            
        }else{
            cell.imageVieww?.transform = CGAffineTransform(rotationAngle:0)
            cell.innerTableView.isHidden = true
        }
        if PaidData.indices.contains(indexPath.row) {
            cell.PaidData = PaidData[indexPath.row]
        }
        cell.orderDataList = self.PaidData[indexPath.row].order_data ?? []
        cell.selectionStyle = .none
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSelect == true && self.indexPaths.contains(indexPath.row) {
            if self.PaidData[indexPath.row].order_data!.count == 1{
                return 200
            }else{
                return CGFloat(self.PaidData[indexPath.row].order_data!.count) * 160
            }
        }
        else{
            return 60.0
        }
    }
    /*
    if self.marrFaq.count > 0 {
                    self.tblAboutUsHeight.constant = CGFloat.greatestFiniteMagnitude
                    self.tblAboutUs.reloadData()
                    self.tblAboutUs.layoutIfNeeded()
                    self.tblAboutUsHeight.constant = self.tblAboutUs.contentSize.height
                }else{
                    self.tblAboutUsHeight.constant = 0
                }
    
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if pageNo <= totalPage && !isPaginating {
            executePagination(scrollView: scrollView)
        }
    }
    
    func executePagination(scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        let comparePosition = (tblView.contentSize.height-(-30)-scrollView.frame.size.height)
        
        if position > comparePosition {
            self.tblView.tableFooterView = Helper.shared.createSpinnerFooterView(view: self.view)
            getPaidOrderList()
        }
        
    }
    
}
extension PaidVC {
    
    private func getPaidOrderList(isLoading: Bool = false) {
        
        isPaginating = true
        
        var param = [Parameter.paymentStatus: "paid"] as [String : Any]
        
        Networking.request(
            url: Urls.ledgersheetlist,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: isLoading,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            self.tblView.tableFooterView = nil
            self.isPaginating = false
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    
                    let t = try! JSONDecoder().decode(PaidOrderAPIResponse.self, from: jsonData)
                    print(t)
                    
                    
                    let upcomingResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: PaidOrderAPIResponse.self)
        
                    guard let paidresponce = upcomingResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if paidresponce.status == StatusCode.success.rawValue {
                        
                        guard let data = data else { return }
                        
                        self.PaidData = paidresponce.data!
                        self.tblView.reloadData()
                    } else {
                        AlertHelper.shared.showAlert(message: paidresponce.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
    }
}

extension PaidVC: MyTeamDelegate, FilterDelegate {
    
    func searchList(searchText: String) {
        self.searchText = searchText
        resetData()
        getPaidOrderList()
    }
    
    func settingsPressed() {
        let vc = FilterVC.instantiate()
        vc.delegate = self
        vc.fromDate = fromDate
        vc.toDate = toDate
        vc.selectedSellerList = selectedSeller
        vc.selectedDeliveryList = selectedDeliveryBoy
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterApplied(fromDate: String, toDate: String, selectedDeliveryBoy: [FilterUserModel], selectedSeller: [FilterUserModel], rating: Double?) {
        
        self.fromDate = fromDate
        self.toDate = toDate
        self.selectedSeller = selectedSeller
        self.selectedDeliveryBoy = selectedDeliveryBoy
        
        resetData()
        
        getPaidOrderList(isLoading: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getPaidOrderList()
        }
    }
    
    private func resetData() {
        pageNo = 1
        orderData.removeAll()
        tblView.reloadData()
    }
}
