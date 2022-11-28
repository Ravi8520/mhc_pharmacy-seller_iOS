//
//  PackagesVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

extension PackagesVC {
    static func instantiate() -> PackagesVC {
        StoryBoardConstants.dashboard.instantiateViewController(withIdentifier: String(describing: PackagesVC.self)) as! PackagesVC
    }
}

class PackagesVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var tableViewHistory: UITableView!
    @IBOutlet weak var collectionViewPackages: UICollectionView!
    
    private var packageList: [PackageListDataApiResponse] = []
    private var packageHistory: [PackageListDataApiResponse] = []
    
    private var isPaginating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Packages"
        uiViewToolBar.btnSearch.isHidden = true
        setupTableView()
        self.getPackageList()
        self.getPackageHistoryList(isLoading: true)
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        
    }
    
    private func setupTableView() {
        tableViewHistory.register(
            PackageHistoryTblCell.loadNib(),
            forCellReuseIdentifier: PackageHistoryTblCell.idetifire()
        )
        tableViewHistory.register(
            PackageHistoryHeaderTblCell.loadNib(),
            forCellReuseIdentifier: PackageHistoryHeaderTblCell.idetifire()
        )
    }
    
}

extension PackagesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        packageHistory.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: PackageHistoryHeaderTblCell.idetifire()) as! PackageHistoryHeaderTblCell
        
        cell.lableDateAndTime.text = DateHelper.shared.getOrderFormateDate(serverDate: packageHistory[section].date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PackageHistoryTblCell.idetifire()) as! PackageHistoryTblCell
        
        if packageHistory.indices.contains(indexPath.section) {
            cell.data = packageHistory[indexPath.section]
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
}

extension PackagesVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        packageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PackageCollectionCell.self), for: indexPath) as! PackageCollectionCell
        
        cell.data = packageList[indexPath.row]
        
        return cell
    }
    
}

extension PackagesVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
}

extension PackagesVC {
    
    private func getPackageList() {
        
        let param = [
            Parameter.cityId: Parameter.module_city_id
        ]
        
        Networking.requestNew(
            url: Urls.packageList,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            

            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let upcomingResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: PackageListApiResponse.self)
                    
                    guard let upResponse = upcomingResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if upResponse.status == StatusCode.success.rawValue {
                        
                        guard let content = upResponse.data else { return }
                        
                        self.packageList.append(contentsOf: content)
                        DispatchQueue.main.async {
                            self.collectionViewPackages.reloadData()
                        }
                        
                        
                    } else if upResponse.status == StatusCode.notFound.rawValue {
        
                        AlertHelper.shared.showAlert(message: upResponse.message!)
                    
                    } else {
                        AlertHelper.shared.showAlert(message: upResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
    }
    
    private func getPackageHistoryList(isLoading: Bool = false) {
        
        let param = [
            "user_id": UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.userId) as? Int ?? 0
        ]
        
        isPaginating = true
        
        Networking.request(
            url: Urls.packageHistory,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: isLoading,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            self.tableViewHistory.tableFooterView = nil
            self.isPaginating = false
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let upcomingResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: PackageListApiResponse.self)
                    
                    guard let upResponse = upcomingResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if upResponse.status == StatusCode.success.rawValue {
                        
                        guard let content = upResponse.data else { return }
                        
                        self.packageHistory.append(contentsOf: content)
                        DispatchQueue.main.async {
                            self.tableViewHistory.reloadData()
                        }
                        
                        
                    } else if upResponse.status == StatusCode.notFound.rawValue {
                        
                        AlertHelper.shared.showAlert(message: upResponse.message!)
                        
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

class PackageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var uiViewShadowView: UIView!
    @IBOutlet weak var uiViewCard: UIView!
    @IBOutlet weak var labelDeliveryCount: UILabel!
    @IBOutlet weak var labelPrize: UILabel!
    @IBOutlet weak var labelPackageType: PaddingLabel!
    
    var data: PackageListDataApiResponse? {
        didSet {
            labelDeliveryCount.text = "\(data?.noOfDelivery ?? 0)"
            labelPrize.text = "₹ \(data?.packageAmt ?? 0)"
            labelPackageType.text = data?.packageName
            
            if data?.packageName == "Standard" {
                labelPackageType.backgroundColor = .appColor.assignColor
            } else if data?.packageName == "Premium" {
                labelPackageType.backgroundColor = .appColor.expressColor
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelPackageType.setCornerRadius(
            radius: 3,
            isMaskedBound: true,
            maskedBound: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        )
        uiViewCard.setCornerRadius(isMaskedToBound: true)
        uiViewShadowView.setCardView()
    }
    
}
