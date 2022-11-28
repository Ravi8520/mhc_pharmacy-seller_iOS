//
//  LoadingLabel.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

class LoadingLabel: UILabel {
    var timer: Timer?
    let states = [" ",".", "..", "..."]
    var currentState = 0
    
    func start() {
        stop(withText: "")
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func stop(withText text: String) {
        timer?.invalidate()
        timer = nil
        
        self.text = text
    }
    
    @objc func update() {
        text = "\(Strings.pleaseWaitMesage) " + states[currentState]
        currentState = (currentState + 1) % states.count
    }
}
