//
//  SellerListVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jatan Ambasana on 06/10/21.
//

import UIKit

extension SellerListVC {
    static func instantiate() -> SellerListVC {
        StoryBoardConstants.myTeam.instantiateViewController(withIdentifier: String(describing: SellerListVC.self)) as! SellerListVC
    }
}

class SellerListVC: UIViewController {

    @IBOutlet weak var tableViewUser: UITableView!
    
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

extension SellerListVC: UITableViewDelegate, UITableViewDataSource {
    
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
        
        cell.switchHandler = { isOn in
            self.changeUserStatus(
                to: isOn,
                index: indexPath.row
            )
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
        let vc = TeamDetailVC.instantiate()
        vc.userType = teamDataSource[indexPath.row].userType!
        vc.userId = "\(teamDataSource[indexPath.row].id!)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SellerListVC {
    
    private func getTeamMember(isLoading: Bool = false) {
        
        let param = [
            Parameter.searchText: searchText,
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
                            message:"ERRORRRR"
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

extension SellerListVC: MyTeamDelegate, AddTeamDelegate {
    
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
