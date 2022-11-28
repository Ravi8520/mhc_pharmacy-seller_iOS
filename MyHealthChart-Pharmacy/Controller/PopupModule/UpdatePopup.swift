//
//  UpdatePopup.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 05/10/21.
//

import UIKit

extension UpdatePopup {
    static func instantiate() -> UpdatePopup {
        StoryBoardConstants.popup.instantiateViewController(withIdentifier: String(describing: UpdatePopup.self)) as! UpdatePopup
    }
}

class UpdatePopup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnUpdatePressed(_ sender: UIButton) {
        
        if let link = URL(string: "\(Strings.appStoreLink)?\(Int(Date().timeIntervalSince1970))") {
            print(link)
            UIApplication.shared.open(link)
        }
        
    }
    
    @IBAction func btnExitPressed(_ sender: BorderButton) {
        exit(0)
    }
    
    

}
