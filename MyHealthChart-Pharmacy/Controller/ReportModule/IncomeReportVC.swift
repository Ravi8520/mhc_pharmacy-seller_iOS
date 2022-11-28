//
//  IncomeReportVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

extension IncomeReportVC {
    static func instantiate() -> IncomeReportVC {
        StoryBoardConstants.report.instantiateViewController(withIdentifier: String(describing: IncomeReportVC.self)) as! IncomeReportVC
    }
}

class IncomeReportVC: UIViewController {

    @IBOutlet weak var tableViewIncomeHistory: UITableView!
    @IBOutlet weak var labelTotlaEarning: UILabel!
    
    private var historyData: [IncomeReportContentApiResponse] = []
    
    private var yearData: [String] = []
    private var incomeReportData: [[IncomeReportContentApiResponse]] = [[]]
    
    private var isPaginating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupTableView()
        getIncomeReport()
    }
    
    private func setupTableView() {
        tableViewIncomeHistory.register(
            IncomeReportTblCell.loadNib(),
            forCellReuseIdentifier: IncomeReportTblCell.idetifire()
        )
        tableViewIncomeHistory.setRefreshControll {
            self.refresh()
        }
    }
    
}

extension IncomeReportVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        yearData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "IncomeReportHeaderTblCell"
        ) as! IncomeReportHeaderTblCell
        
        cell.labelHeader.text = yearData[section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if incomeReportData.indices.contains(section) {
            return incomeReportData[section].count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IncomeReportTblCell.idetifire()) as! IncomeReportTblCell
        
        if incomeReportData[indexPath.section].indices.contains(indexPath.row) {
            cell.data = incomeReportData[indexPath.section][indexPath.row]
        }
        
        return cell
    }
    
}

extension IncomeReportVC {
    
    func getIncomeReport() {
        
        isPaginating = true
        
        Networking.request(
            url: Urls.incomeReport,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: nil,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
        
            self.isPaginating = false
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let incomeResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: IncomeReportApiResponse.self)
                    
                    guard let icResponse = incomeResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if icResponse.status == StatusCode.success.rawValue {
                        
                        self.labelTotlaEarning.text = icResponse.data?.totalEarning ?? "0"
                        
                        guard let content = icResponse.data?.content else { return }
                        
                        self.setupData(data: content)
                        
                    } else if icResponse.status == StatusCode.notFound.rawValue {
                        
                        //AlertHelper.shared.showAlert(message: icResponse.message!)
                        
                    } else {
                        AlertHelper.shared.showAlert(message: icResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
    }
    
    private func setupData(data: [IncomeReportYearViseContent]) {
        
        for incomeData in data {
            let dates = incomeData.incomeReport!.map({ report in
                return report.date ?? ""
            })
            
            var years: Set<String> = []
            
            dates.forEach({ date in
                years.insert(DateHelper.shared.getMonthYearFrom(date: date).year)
            })
            
            let uniqueYearArray = Array(years)
            
    // https://developer.apple.com/forums/thread/113597
    // For sorting array of string date array
            
            Log.d("Year data length \(years.count)")
            
            yearData = uniqueYearArray.sorted {
                $0.compare(
                    $1,
                    options: .numeric
                ) == .orderedDescending
            }
            
            Log.d("IncomeReportData length \(incomeReportData.count)")
            
            for (index,year) in yearData.enumerated() {
                for report in incomeData.incomeReport! {
                    if year == DateHelper.shared.getMonthYearFrom(date: report.date).year {
                        Log.d("Income lenght \(incomeReportData[index].count)")
                        incomeReportData[index].append(report)
                    }
                }
            }
        }
        
        tableViewIncomeHistory.reloadData()
        
    }
    
}

extension IncomeReportVC {
    
    private func refresh() {
        if !isPaginating {
            resetData()
            getIncomeReport()
        }
    }
    
    private func resetData() {
        yearData.removeAll()
        //historyData.removeAll()
        incomeReportData = [[]]
        tableViewIncomeHistory.reloadData()
    }
    
}

class IncomeReportHeaderTblCell: UITableViewCell {
    
    @IBOutlet weak var labelHeader: UILabel!
    
}

extension IncomeReportHeaderTblCell {
    static func identifire() -> String {
        String(describing: IncomeReportHeaderTblCell.self)
    }
}
