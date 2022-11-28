//
//  NotificationVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

extension NotificationVC {
    static func instantiate() -> NotificationVC {
        StoryBoardConstants.dashboard.instantiateViewController(withIdentifier: String(describing: NotificationVC.self)) as! NotificationVC
    }
}

class NotificationVC: UIViewController {
    
    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var tableViewNotification: UITableView!
    
    private var dataSource: [NotificationContentApiResponse] = []
    
    private var pageNo = 1
    private var totalPage = 0
    private var isPaginating = false
    
    private var selectedOption = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        uiViewToolBar.delegate = self
        uiViewToolBar.labelTitle.text = "Notification"
        uiViewToolBar.btnClearAll.isHidden = false
        uiViewToolBar.btnSearch.isHidden = true
        setUpTableView()
        getNotificationList()
    }
    
    private func setUpTableView() {
        tableViewNotification.register(
            NotificationTblCell.loadNib(),
            forCellReuseIdentifier: NotificationTblCell.idetifire()
        )
        tableViewNotification.setRefreshControll { [self] in
            refresh()
        }
    }
    
    
    
   
    
}

extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationTblCell.idetifire()
        ) as! NotificationTblCell
        
        cell.selectionStyle = .none
        
        if dataSource.indices.contains(indexPath.row) {
            cell.data = dataSource[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let id = dataSource[indexPath.row].order_id {
//            let vc = OrderDetailVC.instantiate()
//            vc.orderId = id
//            vc.screenType = .notification
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 70 }
    
    
    func executePagination(scrollView: UIScrollView) {
        if pageNo <= totalPage && !isPaginating {
            paginate(scrollView: scrollView)
        }
    }
    
    func paginate(scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        
        let comparePosition = (tableViewNotification.contentSize.height-(-30)-scrollView.frame.size.height)
        
        if position > comparePosition {
            tableViewNotification.tableFooterView = Helper.shared.createSpinnerFooterView(view: view)
            getNotificationList()
        }
    }
    
}

extension NotificationVC {
    
    func getNotificationList() {
        
        isPaginating = true

        let param = [
            Parameter.pageNo: pageNo
        ]

        Networking.request(
            url: Urls.notificationList,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: true
        ) { [self] response in

            isPaginating = false
            tableViewNotification.tableFooterView = nil

            switch response {

                case .success(let data):

                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }

                    let notificationResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: NotificationApiResponse.self)

                    guard let noResponse = notificationResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }

                    if noResponse.status == StatusCode.success.rawValue {
                        
                        self.totalPage = noResponse.data?.totalPage ?? 0
                        
                        guard let content = noResponse.data?.content else { return }
                        
                        if content.isEmpty {
                            self.dataSource.removeAll()
                        } else {
                            self.dataSource.append(contentsOf: content)
                            self.pageNo += 1
                        }
                        
                        self.tableViewNotification.reloadData()
                        
                    } else if noResponse.status == StatusCode.notFound.rawValue {
                        
                        if self.dataSource.isEmpty {
                            AlertHelper.shared.showAlert(message: noResponse.message!)
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: noResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }

            tableViewNotification.reloadData()

            if dataSource.isEmpty {
                uiViewToolBar.btnClearAll.isHidden = true
            } else {
                uiViewToolBar.btnClearAll.isHidden = false
            }
            
//            Helper.shared.setTableViewEmpatyPlaceHolder(
//                count: dataSource.count,
//                message: Strings.noDataFound,
//                anchorView: tableViewNotification,
//                textAlignMent: .center
//            )
        }
        
    }
    
    func clearAllNotification() {
        
        Networking.request(
            url: Urls.clearNotification,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: nil,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in

            switch response {

                case .success(let data):

                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }

                    let commonResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)

                    guard let coResponse = commonResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }

                    if coResponse.status == StatusCode.success.rawValue {
                        resetData()
                        getNotificationList()

                    } else {

                        AlertHelper.shared.showAlert(message: coResponse.message!)
                    }

                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }

        }
        
    }
    
}


extension NotificationVC: ToolBarDelegate {
    
    func clearAllPressed() {
        
        AlertHelper.shared.showConfirmAlert(
            title: Strings.alertTitle,
            message: Strings.clearNotificationConfirmationMessage,
            yesActionTitle: Strings.clearOption,
            noActionTitle: Strings.cancelOption,
            yesActionStyle: .default,
            noActionStyle: .cancel,
            YesAction: { [self] action in
                clearAllNotification()
            },
            NoAction: nil)
        
    }
    
    func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getNotificationList()
        }
    }
    
    private func resetData() {
        pageNo = 1
        dataSource.removeAll()
        tableViewNotification.reloadData()
    }
    
}
