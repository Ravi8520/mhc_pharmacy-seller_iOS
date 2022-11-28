//
//  DeliveryBoyListVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jatan Ambasana on 06/10/21.
//

import UIKit

extension DeliveryBoyListVC {
    static func instantiate() -> DeliveryBoyListVC {
        StoryBoardConstants.myTeam.instantiateViewController(withIdentifier: String(describing: DeliveryBoyListVC.self)) as! DeliveryBoyListVC
    }
}

class DeliveryBoyListVC: UIViewController {

    @IBOutlet weak var uiViewToolbar: ToolBar!
    
    
    @IBOutlet weak var tableViewUser: UITableView!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    
    private var teamDataSource: [MyTeamListDataApiResponse] = []
    
    private var searchText = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MyTeamTabbarVC.delegate = self
    }
    
    private func setupView() {
        
        if AppConfig.userType == .seller {
            uiViewToolbar.isHidden = false
            uiViewToolbar.labelTitle.isHidden = false
            uiViewToolbar.labelTitle.text = "Deliveryboys"
            uiViewToolbar.delegate = self
            btnAdd.isHidden = true
        } else {
            uiViewToolbar.isHidden = true
        }
        
        setupTableView()
        getTeamMember(isLoading: true)
    }
    
    private func setupTableView() {
        
        tableViewUser.register(
            MyTeamTblCell.loadNib(),
            forCellReuseIdentifier: MyTeamTblCell.idetifire()
        )
        
        tableViewUser.setRefreshControll { [self] in
            refresh()
        }
    }
    
    @IBAction func btnAddMember(_ sender: UIButton) {
        let vc = AddTeamVC.instantiate()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func refresh() {
        resetData()
        getTeamMember()
    }
    
    private func resetData() {
        teamDataSource.removeAll()
        tableViewUser.reloadData()
    }
    
}

extension DeliveryBoyListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int { teamDataSource.count }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTeamTblCell.idetifire()) as! MyTeamTblCell
        
        cell.data = teamDataSource[indexPath.row]
        
        if AppConfig.userType == .seller {
            cell.switchUserAvailibility.isHidden = true
        }
        
        cell.switchHandler = { isOn in
            self.changeUserStatus(to: isOn, index: indexPath.row)
        }
        
        cell.callHandler = {
            let number = self.teamDataSource[indexPath.row].mobileNo ?? ""
            if !number.isEmpty {
                Helper.shared.sendNumberForCall(num: number)
            }
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if AppConfig.userType == .pharmacy {
            let vc = TeamDetailVC.instantiate()
            vc.userType = teamDataSource[indexPath.row].userType!
            vc.userId = "\(teamDataSource[indexPath.row].id!)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension DeliveryBoyListVC {
    
    private func getTeamMember(isLoading: Bool = false) {
        
        let param = [
            Parameter.searchText: searchText,
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
                            message: "DeliveryBoy :-- 162"//CustomError.missinJsonData.localizedDescription
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
                            teamDataSource.removeAll()
                            teamDataSource = listData
                            tableViewUser.reloadData()
                        }
                        
                    } else if mtResponse.status == StatusCode.notFound.rawValue {
                        
                        if self.teamDataSource.isEmpty {
                            //AlertHelper.shared.showAlert(message: odResponse.message!)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: mtResponse.message!)
                    }
                    
                case .failure(let error):
                    //AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func changeUserStatus(to: Bool, index: Int) {
        
        Log.d("User status change to:- \(to)")
        
        let param = [
            Parameter.userId: teamDataSource[index].id!,
            Parameter.userType: teamDataSource[index].userType!,
            Parameter.status: to
        ] as [String : Any]
        
        Networking.request(
            url: Urls.teammemberStatusChanged,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(
                            message: "Error:-- Delivery :--233"//CustomError.missinJsonData.localizedDescription
                        )
                        return
                    }
                    
                    let commonResponse = NetworkHelper.decodeJsonData(
                        data: jsonData,
                        decodeWith: CommonApiResponse.self
                    )
                    
                    guard let cmResponse = commonResponse else {
                        AlertHelper.shared.showAlert(
                            message: CustomError.invalidJsonData.localizedDescription
                        )
                        return
                    }
                    
                    if cmResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: cmResponse.message ?? "")
                        
                    } else {
                        
                        let indexPath = IndexPath(row: index, section: 0)
                        let cell = tableViewUser.cellForRow(at: indexPath) as? MyTeamTblCell
                        cell?.switchUserAvailibility.isOn = !(cell?.switchUserAvailibility.isOn ?? false)
                        
                        AlertHelper.shared.showAlert(message: cmResponse.message!)
                    }
                    
                case .failure(let error):
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = tableViewUser.cellForRow(at: indexPath) as? MyTeamTblCell
                    cell?.switchUserAvailibility.isOn = !(cell?.switchUserAvailibility.isOn ?? false)
                    
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
}

extension DeliveryBoyListVC: MyTeamDelegate, AddTeamDelegate {
    
    func searchList(searchText: String) {
        teamDataSource.removeAll()
        self.searchText = searchText
        getTeamMember()
    }
    
    func memberAdded(view: UIViewController) {
        view.navigationController?.popViewController(animated: true)
        getTeamMember()
    }
    
}

extension DeliveryBoyListVC: ToolBarDelegate {
    
    func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchModePressed() {
        uiViewToolbar.setSearchMode(with: true)
    }
    
    func searchPressed() {
        searchText = uiViewToolbar.searchBar.text ?? ""
        getTeamMember()
    }
    
}
