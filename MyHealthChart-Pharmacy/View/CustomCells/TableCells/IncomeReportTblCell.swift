//
//  IncomeReportTblCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

class IncomeReportTblCell: UITableViewCell {

    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelOrderNo: UILabel!
    @IBOutlet weak var labelAmt: UILabel!
    
    @IBOutlet weak var uiViewCard: UIView!
    
    var data: IncomeReportContentApiResponse? {
        didSet {
            labelMonth.text = DateHelper.shared.getMonthYearFrom(date: data?.date).month
            labelOrderNo.text = data?.orderCount ?? "0"
            labelAmt.text = "₹ "
            labelAmt.text! += data?.orderAmt ?? "0"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        uiViewCard.setCardView()
    }
    
}

extension IncomeReportTblCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: IncomeReportTblCell.self
            ),bundle: nil
        )
        
    }
    
    static func idetifire() -> String {
        String(describing: IncomeReportTblCell.self)
    }
    
}
