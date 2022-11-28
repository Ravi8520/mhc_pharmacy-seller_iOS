//
//  DeletePopUpVC.swift
//  Pharma
//
//  Created by Jatan  on 10/06/21.
//  Copyright © 2021 TFB. All rights reserved.
//

import UIKit

class ComingSoonVC: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    
    @IBOutlet weak var labelText: UILabel!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocal()
    }
    
    func setUpLocal() {
        btnOk.setTitle(Strings.okConfirmation, for: .normal)
        labelText.text = Strings.comingSoon
    }
    
    @IBAction func btnOkPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension ComingSoonVC {
    
    static func instanciate() -> ComingSoonVC {
        UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: String(describing: ComingSoonVC.self)) as! ComingSoonVC
    }
}
