//
//  AllTeamVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jatan Ambasana on 06/10/21.
//

import UIKit

extension AllTeamVC {
    static func instantiate() -> AllTeamVC {
        StoryBoardConstants.myTeam.instantiateViewController(withIdentifier: String(describing: AllTeamVC.self)) as! AllTeamVC
    }
}

class AllTeamVC: UIViewController {

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
    
    private func refresh() {
        
        resetData()
        getTeamMember()
    }
    
    private func resetData() {
        teamDataSource.removeAll()
        tableViewUser.reloadData()
    }
    
}

extension AllTeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { teamDataSource.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTeamTblCell.idetifire()) as! MyTeamTblCell
        
        cell.switchUserAvailibility.isHidden = true
        
        cell.data = teamDataSource[indexPath.row]
        
        cell.callHandler = {
            let number = self.teamDataSource[indexPath.row].mobileNo ?? ""
            if !number.isEmpty {
                Helper.shared.sendNumberForCall(num: number)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TeamDetailVC.instantiate()
        vc.userType = teamDataSource[indexPath.row].userType!
        vc.userId = "\(teamDataSource[indexPath.row].id!)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AllTeamVC {
    
    private func getTeamMember(isLoading: Bool = false) {
        
        let param = [
            Parameter.searchText: searchText,
            Parameter.userType: ""
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
    
}

extension AllTeamVC: MyTeamDelegate {
    
    func searchList(searchText: String) {
        self.searchText = searchText
        getTeamMember()
    }
    
}
