//
//  ThankyouVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 01/10/21.
//

import UIKit

extension ThankyouVC {
    static func instantiate() -> ThankyouVC {
        StoryBoardConstants.main.instantiateViewController(withIdentifier: String(describing: ThankyouVC.self)) as! ThankyouVC
    }
}

class ThankyouVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(popToLoginVC), userInfo: nil, repeats: false)
    }
    
    @objc func popToLoginVC() {
        let vc = navigationController!.viewControllers.filter { $0 is LoginVC }.first!
        self.navigationController!.popToViewController(vc, animated: false)
    }

}
