//
//  UITableViewExtension.swift
//  My Health Chart-Pharmacy
//
//  Created by Freebird App Studio LLP on 13/12/21.
//

import UIKit

extension UITableView {
    
    func setRefreshControll(refreshAction action: (()->Void)? = nil) {
        
        let refreshControll = UIRefreshControl()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont.medium(ofSize: 10),
            .foregroundColor: UIColor.appColor.appThemeColor
        ]
        
        let refreshString = NSAttributedString(
            string: "Pull to refresh",
            attributes: attributes
        )
        
        refreshControll.attributedTitle = refreshString
        
        refreshControll.addAction(for: .valueChanged) {
            refreshControll.endRefreshing()
            action?()
        }
        
        refreshControll.tintColor = .appColor.appThemeColor
        
        self.refreshControl = refreshControll
    }
    
}

//https://stackoverflow.com/questions/25919472/adding-a-closure-as-target-to-a-uibutton

extension UIControl {
    
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        @objc class ClosureSleeve: NSObject {
            let closure:()->()
            init(_ closure: @escaping()->()) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
