//
//  PackageHistoryHeaderTblCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

class PackageHistoryHeaderTblCell: UITableViewCell {

    @IBOutlet weak var lableDateAndTime: UILabel!
    
    
}

extension PackageHistoryHeaderTblCell {
    
    static func loadNib() -> UINib {
        
        UINib(
            nibName: String(
                describing: PackageHistoryHeaderTblCell.self
            ),bundle: nil
        )
        
    }
    
    static func idetifire() -> String {
        String(describing: PackageHistoryHeaderTblCell.self)
    }
    
}
