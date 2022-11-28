//
//  PaidTblCell.swift
//  My Health Chart-Pharmacy
//
//  Created by Miral vadher on 18/05/22.
//

import UIKit

protocol navirateToDetailScreenDelegate {
    func navigateToDetailScreenPaid(OrderID:String)
}
class PaidTblCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var imageVieww: UIImageView!
    @IBOutlet weak var labelTransactionDate: UILabel!
    @IBOutlet weak var labelTransactionNO: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var btnArrowDown: UIButton!

    @IBOutlet weak var innerTableView: UITableView!
    var delegate: navirateToDetailScreenDelegate?
    var tblHeight : CGFloat = 0.0
    
    
    var orderDataList : [OrderData] = []

    
    var PaidData: paidDataList? {
        didSet {
            labelTransactionDate.text = PaidData?.payment_date
            labelTransactionNO.text = PaidData?.transaction_no
            labelTotalAmount.text = "₹ \(PaidData?.total_amount ?? "")"
                
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.setCardView()
        
        self.innerTableView.delegate = self
        self.innerTableView.dataSource = self

        self.innerTableView.estimatedRowHeight = 100
        self.innerTableView.rowHeight = UITableView.automaticDimension
        
         innerTableView.register(
            CompleteOrderTblCell.loadNib(),
            forCellReuseIdentifier: CompleteOrderTblCell.idetifire()
            )
        
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension PaidTblCell:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteOrderTblCell") as! CompleteOrderTblCell
        if orderDataList.indices.contains(indexPath.row) {
            cell.orderDataList = orderDataList[indexPath.row]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.navigateToDetailScreenPaid(OrderID: (orderDataList[indexPath.row].order_id)!)
        
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
