//
//  ReferralUsersVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

extension ReferralUsersVC {
    static func instantiate() -> ReferralUsersVC {
        StoryBoardConstants.dashboard.instantiateViewController(withIdentifier: String(describing: ReferralUsersVC.self)) as! ReferralUsersVC
    }
}

class ReferralUsersVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBar!
    @IBOutlet weak var tableViewUser: UITableView!
    
    private var userData: [ReferralUsersContentApiResponse] = []
    
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupDelegates()
        uiViewToolBar.labelTitle.text = "Referral Users"
        setupTableView()
        getReferralUsers(isLoading: true)
    }
    
    private func setupDelegates() {
        uiViewToolBar.delegate = self
        
    }
    
    private func setupTableView() {
        tableViewUser.register(
            ReferralUserTblCell.loadNib(),
            forCellReuseIdentifier: ReferralUserTblCell.idetifire()
        )
        tableViewUser.setRefreshControll { [self] in
            refresh()
        }
    }
    
}

extension ReferralUsersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReferralUserTblCell.idetifire()) as! ReferralUserTblCell
        
        if userData.indices.contains(indexPath.row) {
            cell.data = userData[indexPath.row]
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
        let comparePosition = (tableViewUser.contentSize.height-(-30)-scrollView.frame.size.height)
        
        if position > comparePosition {
            self.tableViewUser.tableFooterView = Helper.shared.createSpinnerFooterView(view: self.view)
            getReferralUsers()
        }
        
    }
    
}

extension ReferralUsersVC {
    
    private func getReferralUsers(isLoading: Bool = false) {
        
        isPaginating = true
        
        let param = [
            Parameter.searchText: uiViewToolBar.searchBar.text ?? "",
            Parameter.pageNo: "\(pageNo)"
        ]
        
        Networking.request(
            url: Urls.referralUsers,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: isLoading,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            self.tableViewUser.tableFooterView = nil
            self.isPaginating = false
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let usersResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: ReferralUsersApiResponse.self)
                    
                    guard let uResponse = usersResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if uResponse.status == StatusCode.success.rawValue {
                        
                        self.totalPage = uResponse.data?.totalPage ?? 0
                        
                        guard let content = uResponse.data?.content else { return }
                        
                        if content.isEmpty {
                            self.userData.removeAll()
                        } else {
                            self.userData.append(contentsOf: content)
                            self.pageNo += 1
                        }
                        
                        self.tableViewUser.reloadData()
                        
                    } else if uResponse.status == StatusCode.notFound.rawValue {
                        
                        if self.userData.isEmpty {
                            AlertHelper.shared.showAlert(message: uResponse.message!)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: uResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
    }
    
}

extension ReferralUsersVC: ToolBarDelegate {
    
    func btnBackPressed() {
        Log.m("Back pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getReferralUsers()
        }
    }
    
    private func resetData() {
        pageNo = 1
        userData.removeAll()
        tableViewUser.reloadData()
    }
    
    func searchModePressed() {
        uiViewToolBar.setSearchMode(with: true)
    }
    
    func searchPressed() {
        resetData()
        getReferralUsers(isLoading: true)
    }
    
}
