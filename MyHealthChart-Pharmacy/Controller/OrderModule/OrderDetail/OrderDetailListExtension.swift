//
//  OrderDetailListExtension.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 07/10/21.
//

import UIKit

extension OrderDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderDetailData?.manual_order?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManualOrderTblCell") as! ManualOrderTblCell
        cell.data = orderDetailData?.manual_order?[indexPath.row]
        
        cell.fullScreenImage = { [self] image in
            let vc = FullScreenVC.instantiate()
            vc.image = image
            present(vc, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension OrderDetailVC: OrderUpdateDelegate {
    
    func orderUpdated(vc: UIViewController) {
//        vc.navigationController?.popToViewController(self, animated: false)
        vc.navigationController?.popViewController(animated: false)
        getOrderDetail()
    }
    
}

class ManualOrderTblCell: UITableViewCell {
    
    @IBOutlet weak var imageViewOrder: UIImageView!
    @IBOutlet weak var labelOrderName: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var labelCompanyName: UILabel!
    
    var fullScreenImage:((UIImage)->Void)?
    
    var data: OrderDetailManualOrderApiResponse? {
        didSet {
            
            imageViewOrder.contentMode = .scaleAspectFill
            
            let url = data?.image ?? ""
            
            labelOrderName.text = data?.product
            labelQty.text = String(data!.qty!)
            labelQty.text! += " \(data?.type ?? "")"
            labelCompanyName.text = data?.company_name
            
            imageViewOrder.loadImageFromUrl(
                urlString: url,
                placeHolder: #imageLiteral(resourceName: "ic_prescription_placeHolder")
            )
            
        }
    }
    
    @IBAction func btnImageViewPressed(_ sender: UIButton) {
        if let img = imageViewOrder.image {
            fullScreenImage?(img)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewOrder.image = #imageLiteral(resourceName: "ic_prescription_placeHolder")
    }
    
}
