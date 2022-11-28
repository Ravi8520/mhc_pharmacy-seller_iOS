//
//  DeliveryorderVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Mac Mini on 07/04/22.
//

import UIKit

extension DeliveryorderVC {
    static func instantiate() -> DeliveryorderVC {
        StoryBoardConstants.order.instantiateViewController(withIdentifier: String(describing: DeliveryorderVC.self)) as! DeliveryorderVC
    }
}

class DeliveryorderVC: UIViewController {
    
    @IBOutlet weak var collVOrderStatus: UICollectionView!
    @IBOutlet weak var tblDeliveryOrders: UITableView!
    
    
    //MARK: -  Properties
    var marrStatusName = ["Created","Pickup","Complete","Incomplete","Cancelled"]
    var strStatus = ""
    
    private var orderData: [ManualOrderContentApiResponse] = []
    
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    private var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblDeliveryOrders.register(UINib(nibName: "DeliveryOrderTVC", bundle: nil), forCellReuseIdentifier: "DeliveryOrderTVC")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView(collVOrderStatus, didSelectItemAt: IndexPath(row: 0, section: 0))
        // getManualOrderList(isLoading: true)
        
    }
    
    func getManualOrderList(isLoading: Bool = false , urlManualOrder: String) {
        
        isPaginating = true
        
        let param = [
            Parameter.searchText: searchText,
            Parameter.pageNo: "\(pageNo)"
        ]
        print("params", param)
        Networking.request(
            url: urlManualOrder,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: isLoading,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            self.tblDeliveryOrders.tableFooterView = nil
            self.isPaginating = false
            
            switch response {
                
            case .success(let data):
                
                guard let jsonData = data else {
                    AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                    return
                }
                
                
                let ManualOrderResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: ManualOrderApiResponse.self)
                
                guard let MuResponse = ManualOrderResponse else {
                    AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                    return
                }
                
                if MuResponse.status == StatusCode.success.rawValue {
                    
                    self.totalPage = MuResponse.data?.totalPage ?? 0
                    
                    guard let content = MuResponse.data?.content else { return }
                    
                    if content.isEmpty {
                        self.orderData.removeAll()
                    } else {
                        if self.pageNo == 1 {
                            self.orderData = content
                        }else{
                            self.orderData.append(contentsOf: content)
                        }
                        print("order data==>>" , content)
                        self.pageNo += 1
                    }
                    
                    self.tblDeliveryOrders.reloadData()
                    //   self.collVOrderStatus.reloadData()
                    
                } else if MuResponse.status == StatusCode.notFound.rawValue {
                    /*
                    if self.orderData.isEmpty {
                        */
                        AlertHelper.shared.showAlert(message: MuResponse.message!)
                        self.orderData.removeAll()
                        self.tblDeliveryOrders.reloadData()
                    
                    
                } else {
                    AlertHelper.shared.showAlert(message: MuResponse.message!)
                }
                
            case .failure(let error):
                AlertHelper.shared.showAlert(message: error.localizedDescription)
                Log.e(error.localizedDescription)
            }
        }
        
    }
    
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension DeliveryorderVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderData.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrderDetailsVC.instantiate()
        if strStatus == "Created" {
            vc.cancelbtn = false
        }else{
            vc.cancelbtn = true
        }
        
        if strStatus == "Cancelled"{
            vc.canelOrder = true
        }else{
            vc.canelOrder = false
        }
        
        vc.orderId = orderData[indexPath.row].orderId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryOrderTVC") as! DeliveryOrderTVC
        cell.selectionStyle = .none
        
        if orderData.indices.contains(indexPath.row) {
            if strStatus == "Cancelled" {
                cell.ManualOrderDataCancel = orderData[indexPath.row]
            }else if strStatus == "Pickup"{
                cell.ManualOrderDataPickup = orderData[indexPath.row]
            }else if strStatus == "Complete" {
                cell.ManualOrderDataComplete = orderData[indexPath.row]
            }else if strStatus == "Incomplete"{
                cell.ManualOrderDataInComplete = orderData[indexPath.row]
            }
            else{
                cell.ManualOrderData = orderData[indexPath.row]
            }
        }
        
        return cell
        
    }
    
    
}


//MARK: -  UICollectionViewDelegate, UICollectionViewDataSource
extension DeliveryorderVC: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marrStatusName.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderStatusCVC", for: indexPath) as! OrderStatusCVC
        
        cell.lblOrderStatus.text = marrStatusName[indexPath.row]
        
        if strStatus == marrStatusName[indexPath.row] {
            cell.uiView.backgroundColor = .appColor.appThemeColor
            cell.lblOrderStatus.textColor = .white
        }
        else{
            cell.uiView.backgroundColor = nil
            cell.lblOrderStatus.textColor = .black
            
        }
        
        cell.layer.cornerRadius = 4
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        pageNo = 1
        
        strStatus = marrStatusName[indexPath.row]
        
        if marrStatusName[indexPath.row] == "Created" {
            getManualOrderList(isLoading: true, urlManualOrder: Urls.manualDeliveryOrderCreateList)
            
        }else if marrStatusName[indexPath.row] == "Pickup"{
            getManualOrderList(isLoading: true, urlManualOrder: Urls.manualDeliveryOrderPickupList)
            
        }else if marrStatusName[indexPath.row] == "Complete"{
            getManualOrderList(isLoading: true, urlManualOrder: Urls.manualDeliveryOrderCompleteList)
            
        }else if marrStatusName[indexPath.row] == "Incomplete"{
            getManualOrderList(isLoading: true, urlManualOrder: Urls.manualDeliveryOrderIncompleteList)
            
        }else if marrStatusName[indexPath.row] == "Cancelled" {
            getManualOrderList(isLoading: true, urlManualOrder: Urls.manualDeliveryOrderCanceList)
            
        }else{
            print("error")
        }
        collVOrderStatus.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let size:CGSize = CGSize(width: 80, height: 40)
        return size
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        
    }

    
}
