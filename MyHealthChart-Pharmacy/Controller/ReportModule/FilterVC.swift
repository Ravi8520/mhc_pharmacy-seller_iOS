//
//  FilterVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit
import Cosmos

protocol FilterDelegate {
    func filterApplied(
        fromDate: String,
        toDate: String,
        selectedDeliveryBoy: [FilterUserModel],
        selectedSeller: [FilterUserModel],
        rating: Double?
    )
}

extension FilterVC {
    static func instantiate() -> FilterVC {
        StoryBoardConstants.report.instantiateViewController(withIdentifier: String(describing: FilterVC.self)) as! FilterVC
    }
}

class FilterVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var labelFromDate: UILabel!
    @IBOutlet weak var labelToDate: UILabel!
    
    @IBOutlet weak var uiViewShadowFrom: UIView!
    @IBOutlet weak var uiViewShadowTo: UIView!
    
    @IBOutlet weak var collectionViewSeller: UICollectionView!
    @IBOutlet weak var collectionViewDeliveryBoy: UICollectionView!
    
    
    @IBOutlet weak var sellerHeight: NSLayoutConstraint!
    @IBOutlet weak var deliveryBoyHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stackviewSellerSearch: UIStackView!
    @IBOutlet weak var searchBarSeller: UISearchBar!
    
    @IBOutlet weak var stackViewdeliveryBoyList: UIStackView!
    @IBOutlet weak var stackviewDeliveryboySearch: UIStackView!
    @IBOutlet weak var searchBarDeliveryBoy: UISearchBar!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    private var isSellerSearchMode = false
    private var isDeliverySearchMode = false
    
    var isDeliveryBoyFilter = true
    var fromDate = ""
    var toDate = ""
    var rate: Double? = 0
    var delegate: FilterDelegate?
    
    private var sellerList: [FilterUserModel] = []
    private var deliveryBoyList: [FilterUserModel] = []
    
    var selectedSellerList: [FilterUserModel] = []
    var selectedDeliveryList: [FilterUserModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupDelegates()
        setupCollectionView()
        uiViewShadowFrom.setCardView()
        uiViewShadowTo.setCardView()
        uiViewToolBar.labelTitle.text = "Filter"
        uiViewToolBar.btnSearch.isHidden = true
        searchBarSeller.isHidden = true
        searchBarDeliveryBoy.isHidden = true
        
        setupOldState()
        
        if isDeliveryBoyFilter {
            getDeliveryBoyList(isLoading: true)
        } else {
            stackViewdeliveryBoyList.isHidden = true
        }
        getSellerList(isLoading: true)
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        searchBarSeller.delegate = self
        searchBarDeliveryBoy.delegate = self
    }
    
    private func setupOldState() {
        ratingView.rating = rate ?? 0.0
        labelFromDate.text = fromDate
        labelToDate.text = toDate
    }
    
    private func setupCollectionView() {
        collectionViewSeller.register(
            SellerNameCollCell.loadNib(),
            forCellWithReuseIdentifier: SellerNameCollCell.idetifire()
        )
        collectionViewDeliveryBoy.register(
            SellerNameCollCell.loadNib(),
            forCellWithReuseIdentifier: SellerNameCollCell.idetifire()
        )
        setFlowLayout()
        reloadCollectionView()
    }
    
    func setFlowLayout() {
        let sellerLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        sellerLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        sellerLayout.minimumInteritemSpacing = 0
        sellerLayout.minimumLineSpacing = 8
        sellerLayout.scrollDirection = .vertical
        
        let deliveryBoyLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        deliveryBoyLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        deliveryBoyLayout.minimumInteritemSpacing = 0
        deliveryBoyLayout.minimumLineSpacing = 8
        deliveryBoyLayout.scrollDirection = .vertical
        
        
        self.collectionViewSeller.collectionViewLayout = sellerLayout
        self.collectionViewDeliveryBoy.collectionViewLayout = deliveryBoyLayout
    }
    
    @IBAction func btnFromDatePressed(_ sender: UIButton) {
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseDateTitle,
            Format: DateHelper.DateStrings.appDateFormat,
            Mode: .date,
            YesActionTitle: Strings.okConfirmation,
            NoActionTitle: Strings.cancelOption,
            minimumDate: nil,
            maximumDate: Date()) { [self] dateString in
                
                if dateString == labelToDate.text {
                    showSameDateAlert()
                } else {
                    labelFromDate.text = dateString
                }
                
            
        } NoAction: { noAction in }
    }
    
    @IBAction func btnToDatePressed(_ sender: UIButton) {
        DateHelper.shared.openDatePicker(
            Message: Strings.chooseDateTitle,
            Format: DateHelper.DateStrings.appDateFormat,
            Mode: .date,
            YesActionTitle: Strings.okConfirmation,
            NoActionTitle: Strings.cancelOption,
            minimumDate: nil,
            maximumDate: Date()) { [self] dateString in
                
                if dateString == labelFromDate.text {
                    showSameDateAlert()
                } else {
                    labelToDate.text = dateString
                }
            
        } NoAction: { noAction in }
    }
    
    private func showSameDateAlert() {
        AlertHelper.shared.showAlert(message: "From date and To date can not be same")
    }
    
    @IBAction func btnSearchSellerPressed(_ sender: UIButton) {
        toggleSearchMode(for: searchBarSeller)
    }
    
    
    @IBAction func btnSearchDeliveryBoyPressed(_ sender: UIButton) {
        toggleSearchMode(for: searchBarDeliveryBoy)
    }
    
    @IBAction func btnResetPressed(_ sender: UIButton) {
        labelFromDate.text = nil
        labelToDate.text = nil
        for (index,_) in sellerList.enumerated() {
            sellerList[index].isSelected = false
        }
        for (index,_) in deliveryBoyList.enumerated() {
            deliveryBoyList[index].isSelected = false
        }
        ratingView.rating = 0
        collectionViewSeller.reloadData()
        collectionViewDeliveryBoy.reloadData()
        selectedSellerList.removeAll()
        selectedDeliveryList.removeAll()
    }
    
    
    @IBAction func btnApplyPressed(_ sender: HalfCornerButton) {
        
        let selectedSeller = sellerList.filter({ $0.isSelected })
        let selectedDeliveryBoy = deliveryBoyList.filter({ $0.isSelected })
        
        delegate?.filterApplied(
            fromDate: labelFromDate.text ?? "",
            toDate: labelToDate.text ?? "",
            selectedDeliveryBoy: selectedDeliveryBoy,
            selectedSeller: selectedSeller,
            rating: ratingView.rating
        )
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    private func reloadCollectionView() {
        collectionViewSeller.reloadData()
        sellerHeight.constant = CGFloat(ceil(Double(sellerList.count)/2) * 58)
        collectionViewDeliveryBoy.reloadData()
        deliveryBoyHeight.constant = CGFloat(ceil(Double(deliveryBoyList.count)/2) * 58)
    }
    
}

extension FilterVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewSeller {
            return sellerList.count
        } else {
            return deliveryBoyList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SellerNameCollCell.idetifire(),
            for: indexPath
        ) as! SellerNameCollCell
        
        if collectionView == collectionViewSeller {
            cell.data = sellerList[indexPath.row]
        } else {
            cell.data = deliveryBoyList[indexPath.row]
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewSeller {
            sellerList[indexPath.row].isSelected = !sellerList[indexPath.row].isSelected
            if sellerList[indexPath.row].isSelected {
                selectedSellerList.append(sellerList[indexPath.row])
            } else {
                for (index,selectedSeller) in selectedSellerList.enumerated() {
                    if selectedSeller.id == sellerList[indexPath.row].id {
                        selectedSellerList.remove(at: index)
                    }
                }
            }
        } else {
            deliveryBoyList[indexPath.row].isSelected = !deliveryBoyList[indexPath.row].isSelected
            
            if deliveryBoyList[indexPath.row].isSelected {
                selectedDeliveryList.append(deliveryBoyList[indexPath.row])
            } else {
                for (index,selectedDeliveryBoy) in selectedDeliveryList.enumerated() {
                    if selectedDeliveryBoy.id == deliveryBoyList[indexPath.row].id {
                        selectedDeliveryList.remove(at: index)
                    }
                }
            }
        }

        collectionView.reloadData()
    }
  
}

extension FilterVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // Here, I need 3 equal cells occupying whole screen width so i divided it by 2.0. You can use as per your need.
        let width = ((UIScreen.main.bounds.size.width/2.0) - 16)
        let height: CGFloat = 50 // 150
        
        return CGSize(width: width, height: height)
    }
    
}

extension FilterVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.view.endEditing(true)
        toggleSearchMode(for: searchBar)
        if searchBar == searchBarSeller {
            getSellerList()
        } else {
            getDeliveryBoyList()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if searchBar == searchBarSeller {
            getSellerList()
        } else {
            getDeliveryBoyList()
        }
    }
    
    private func toggleSearchMode(for searchBar: UISearchBar) {
        if searchBar == searchBarSeller {
            isSellerSearchMode.toggle()
            stackviewSellerSearch.isHidden = isSellerSearchMode
            searchBarSeller.isHidden = !isSellerSearchMode
        } else {
            isDeliverySearchMode.toggle()
            stackviewDeliveryboySearch.isHidden = isDeliverySearchMode
            searchBarDeliveryBoy.isHidden = !isDeliverySearchMode
        }
    }
    
}

extension FilterVC {
    
    private func getSellerList(isLoading: Bool = false) {
        
        let param = [
            Parameter.searchText: searchBarSeller.text ?? "",
            Parameter.userType: UserType.seller.serverString
        ]
        
        Networking.request(
            url: Urls.myTeamList,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: isLoading,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let myTeamListResponse = NetworkHelper.decodeJsonData(
                        data: jsonData,
                        decodeWith: MyTeamListApiResponse.self
                    )
                    
                    guard let mtResponse = myTeamListResponse else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if mtResponse.status == StatusCode.success.rawValue {
                        
                        if let listData = mtResponse.data {
                            setSelectedDataForSeller(newData: listData)
                        }
                        
                    } else {
                        sellerList.removeAll()
                        reloadCollectionView()
                        AlertHelper.shared.showAlert(message: mtResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func setSelectedDataForSeller(newData: [MyTeamListDataApiResponse]) {
        
        if selectedSellerList.isEmpty {
            sellerList = newData.map({ user in
                return FilterUserModel(
                    id: user.id!,
                    name: user.name!,
                    isSelected: false
                )
            })
            sellerList.insert(FilterUserModel(id: -1, name: "All", isSelected: false), at: 0)
        } else {
            var sellers = newData.map({ user in
                return FilterUserModel(
                    id: user.id!,
                    name: user.name!,
                    isSelected: false
                )
            })
            sellers.insert(FilterUserModel(id: -1, name: "All", isSelected: false), at: 0)
            for data in selectedSellerList {
                for (index,seller) in sellers.enumerated() {
                    if data.id == seller.id {
                        sellers[index].isSelected = true
                    }
                }
            }
            sellerList = sellers
        }
        reloadCollectionView()
    }
    
    private func getDeliveryBoyList(isLoading: Bool = false) {
        
        let param = [
            Parameter.searchText: searchBarDeliveryBoy.text ?? "",
            Parameter.userType: UserType.deliveryBoy.serverString
        ]
        
        Networking.request(
            url: Urls.myTeamList,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: isLoading,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let myTeamListResponse = NetworkHelper.decodeJsonData(
                        data: jsonData,
                        decodeWith: MyTeamListApiResponse.self
                    )
                    
                    guard let mtResponse = myTeamListResponse else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if mtResponse.status == StatusCode.success.rawValue {
                        
                        if let listData = mtResponse.data {
                            setSelectedDataForDeliveryBoy(newData: listData)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: mtResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func setSelectedDataForDeliveryBoy(newData: [MyTeamListDataApiResponse]) {
        
        if selectedDeliveryList.isEmpty {
            deliveryBoyList = newData.map({ user in
                return FilterUserModel(
                    id: user.id!,
                    name: user.name!,
                    isSelected: false
                )
            })
            deliveryBoyList.insert(FilterUserModel(id: -1, name: "All", isSelected: false), at: 0)
            deliveryBoyList.insert(FilterUserModel(id: -2, name: "external", isSelected: false), at: 1)
        } else {
            var deliveryBoys = newData.map({ user in
                return FilterUserModel(
                    id: user.id!,
                    name: user.name!,
                    isSelected: false
                )
            })
            deliveryBoys.insert(FilterUserModel(id: -1, name: "All", isSelected: false), at: 0)
            deliveryBoys.insert(FilterUserModel(id: -2, name: "external", isSelected: false), at: 1)
            for data in selectedDeliveryList {
                for (index,deliveryBoy) in deliveryBoys.enumerated() {
                    if data.id == deliveryBoy.id {
                        deliveryBoys[index].isSelected = true
                    }
                }
            }
            deliveryBoyList = deliveryBoys
        }
        
        
        reloadCollectionView()
    }
    
}

extension FilterVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
}
