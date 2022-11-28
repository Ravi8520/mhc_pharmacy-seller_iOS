//
//  EncryptionManager.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import Foundation

class Encryption {
    
    static var shared = Encryption()
    
    let cryptLib = CryptLib()
    
    private let KEY = "m4KL$RVJCIx17ntFK2$v4Wy3p0^vI#If"
    
    private let isEncryptionEnable = false
    
    func encryptData(data : String) -> String? {
        if !isEncryptionEnable {
            return data
        }
        let cipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: data, key: KEY)
        return cipherText
    }
    
    func decryptData(data : String ) -> String? {
        if !isEncryptionEnable {
            return data
        }
        let decryptData = cryptLib.decryptCipherTextRandomIV(withCipherText: data, key: KEY)
        return decryptData
    }
    
}
