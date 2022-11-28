//
//  DashboardVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 30/09/21.
//

import UIKit

extension DashboardVC {
    static func instantiate() -> DashboardVC {
        StoryBoardConstants.dashboard.instantiateViewController(withIdentifier: String(describing: DashboardVC.self)) as! DashboardVC
    }
}

class DashboardVC: UIViewController {

    @IBOutlet weak var uiViewToolBar: ToolBarOrder!
    
    @IBOutlet weak var gradientView: GradientView!
    
    
    @IBOutlet weak var labelTodayEarning: UILabel!
    @IBOutlet weak var labelThisMonthEarning: UILabel!
    
    @IBOutlet weak var labelPendingDeliveryTitle: UILabel!
    @IBOutlet weak var labelInternalDeliveryTitle: UILabel!
    @IBOutlet weak var labelLogisticDeliveryTitle: UILabel!
    
    @IBOutlet weak var labelCompleteDelivery: UILabel!
    @IBOutlet weak var labelPendignDelivery: UILabel!
    
    @IBOutlet weak var labelCompleteInternalDelivery: UILabel!
    @IBOutlet weak var labelInternalDelivery: UILabel!
    
    @IBOutlet weak var labelTotalCompleteDelivery: UILabel!
    
    @IBOutlet weak var labelCompleteLogisticDelivery: UILabel!
    @IBOutlet weak var labelLogisticDelivery: UILabel!
    
    @IBOutlet weak var labelRemainingLogisticDelivery: UILabel!
    
    
    @IBOutlet weak var labelUpcomingCount: UILabel!
    @IBOutlet weak var labelAcceptedCount: UILabel!
    @IBOutlet weak var labelReadyForPickupCount: UILabel!
    @IBOutlet weak var labelOutForDeliveryCount: UILabel!
    @IBOutlet weak var labelCompleteOrderCount: UILabel!
    
    @IBOutlet weak var lblCompleteManualOrders: UILabel!
    @IBOutlet weak var lblPendingManualOrders: UILabel!
    
    @IBOutlet weak var pendingProgressView: CircularProgressBar!
    @IBOutlet weak var internalProgressView: CircularProgressBar!
    @IBOutlet weak var logisticProgressView: CircularProgressBar!
    
    @IBOutlet weak var uiViewPendingCard: UIView!
    @IBOutlet weak var uiViewInternalCard: UIView!
    @IBOutlet weak var uiViewLogisticCard: UIView!
    
    @IBOutlet weak var uiViewUpcomingCard: UIView!
    @IBOutlet weak var uiViewAcceptedCard: UIView!
    @IBOutlet weak var uiViewReadyForPickupCard: UIView!
    @IBOutlet weak var uiViewOutForDelivery: UIView!
    @IBOutlet weak var uiViewCompleteCard: UIView!
    
    @IBOutlet weak var uiViewManualOrder: UIView!
    
    @IBOutlet weak var stackViewEarning: UIStackView!
    
    private var dashboardDataSource: DashboardCountDataApiResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        
        if AppConfig.userType == .seller {
            stackViewEarning.isHidden = true
            labelPendingDeliveryTitle.text = "Today Delivery"
            labelInternalDeliveryTitle.text = "Free Delivery"
            labelLogisticDeliveryTitle.text = "Standard Delivery"
            labelTotalCompleteDelivery.textColor = .clear
            labelRemainingLogisticDelivery.textColor = .clear
            
        }
        
        uiViewToolBar.labelTitle.text = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.pharmacyName) as? String
        uiViewToolBar.backgroundColor = .clear
        uiViewToolBar.delegate = self
        uiViewToolBar.btnSetting.isHidden = true
        uiViewToolBar.btnImage.addAction {
            self.navigationController?.pushViewController(MoreVC.instantiate(), animated: true)
        }
        
        uiViewPendingCard.setCardView()
        uiViewInternalCard.setCardView()
        uiViewLogisticCard.setCardView()
        
        pendingProgressView.progress = 0.5
        internalProgressView.progress = 0.6
        logisticProgressView.progress = 0.35
        
        uiViewUpcomingCard.setCardView()
        uiViewAcceptedCard.setCardView()
        uiViewReadyForPickupCard.setCardView()
        uiViewOutForDelivery.setCardView()
        uiViewCompleteCard.setCardView()
        uiViewManualOrder.setCardView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let logoUrl = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.pharmacyLogo) as? String
        
        uiViewToolBar.imgProfile.loadImageFromUrl(
            urlString: logoUrl ?? "",
            placeHolder: UIImage(named: "ic_profile_placeholder")
        )
        
        getDashboardCount()
    }
    

    @IBAction func btnMaunalOrder(_ sender: Any) {
        self.navigationController?.pushViewController(DeliveryorderVC.instantiate(), animated: true)
    }
    @IBAction func btnTodayEarningPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(TodayEarningVC.instantiate(), animated: true)
    }
    
    @IBAction func btnMonthEarningPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(TotalEarningVC.instantiate(), animated: true)
    }
    
    @IBAction func btnPendingDeliveryPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(SwipableTabBarVC.instantiate(), animated: true)
    }
    
    @IBAction func btnInternalDeliveryPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(InternalDeliveryVC.instantiate(), animated: true)
    }
    
    @IBAction func btnLogisticDeliveryPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(LogisticDeliveryVC.instantiate(), animated: true)
    }
    
    @IBAction func btnUpcomingPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(UpcomingOrderVC.instantiate(), animated: true)
    }
    
    @IBAction func btnAcceptedPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(AcceptedOrderVC.instantiate(), animated: true)
    }
    
    @IBAction func btnReadyForPickupPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(ReadyForPickupVC.instantiate(), animated: true)
    }
    
    @IBAction func btnOutOfDeliveryPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(OutForDeliveryVC.instantiate(), animated: true)
    }
    
    @IBAction func btnCompleteOrderPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(CompleteOrderVC.instantiate(), animated: true)
    }
    
    
}

extension DashboardVC {
    
    private func getDashboardCount() {
        
        Networking.request(
            url: Urls.dashboardCount,
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
                    
                    let dashboardCountResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: DashboardCountApiResponse.self)
                    
                    guard let dcResponse = dashboardCountResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if dcResponse.status == StatusCode.success.rawValue {
                        
                        dashboardDataSource = dcResponse.data
                        setupDashboardData()
                        
                    } else {
                        AlertHelper.shared.showAlert(message: dcResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    private func setupDashboardData() {
        
        guard let data = dashboardDataSource else { return }
        
        labelTodayEarning.text = data.todayEarning ?? "0"
        labelThisMonthEarning.text = data.thisMonthEarning ?? "0"
        
        labelCompleteDelivery.text = "\(data.todayCompleteDelivery ?? 0)"
        labelPendignDelivery.text = "off \(data.todayTotalDelivery ?? 0)"
        
        pendingProgressView.progress = CGFloat(
            Helper.shared.getPercentage(
                value1: data.todayCompleteDelivery ?? 0,
                value2: data.todayTotalDelivery ?? 0
            )
        )
        
        labelCompleteInternalDelivery.text = "\(data.todayCompleteInternalDelivery ?? 0)"
        labelInternalDelivery.text = "off \(data.todayTotalInternalDelivery ?? 0)"
        
        internalProgressView.progress = CGFloat(
            Helper.shared.getPercentage(
                value1: data.todayCompleteInternalDelivery ?? 0,
                value2: data.todayTotalInternalDelivery ?? 0
            )
        )
        
        labelCompleteLogisticDelivery.text = "\(data.todayCompleteLogisticDelivery ?? 0)"
        labelLogisticDelivery.text = "off \(data.todayTotalLogisticDelivery ?? 0)"
        
        logisticProgressView.progress = CGFloat(
            Helper.shared.getPercentage(
                value1: data.todayCompleteLogisticDelivery ?? 0,
                value2: data.todayTotalLogisticDelivery ?? 0
            )
        )
     
        labelRemainingLogisticDelivery.text = "Available \(data.remainingLogisticDelivery ?? 0)"
        
        labelTotalCompleteDelivery.text = "Total Delivery \(data.totalInternalDelivery ?? 0)"
        
        labelUpcomingCount.text = "\(data.upcomingOrders ?? 0)"
        labelAcceptedCount.text = "\(data.acceptedOrders ?? 0)"
        labelReadyForPickupCount.text = "\(data.readyForPickupOrders ?? 0)"
        labelOutForDeliveryCount.text = "\(data.outForDeliveryOrders ?? 0)"
        labelCompleteOrderCount.text = "\(data.completedOrders ?? 0)"
        
        lblPendingManualOrders.text = "\(data.manualDeliveryPendingOrders ?? 0)"
        lblCompleteManualOrders.text = "\(data.manualDeliveryCompleteOrders ?? 0)"
    }
    
}

extension DashboardVC: ToolBarDelegate {
    
    func notificationPressed() {
        self.navigationController?.pushViewController(NotificationVC.instantiate(), animated: true)
    }
    
    func searchPressed() {
        
        let vc = DashboardSearchVC.instantiate()
        let navController = UINavigationController(
            rootViewController: vc
        )
        
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overCurrentContext
        navController.navigationBar.isHidden = true
        
        present(navController, animated: true, completion: nil)
    }
    
}
