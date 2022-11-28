//
//  Socket.swift
//  My Pharmacy
//
//  Created by Jatan Ambasana on 25/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit
import SocketIO

//class Socket: NSObject {
//    
//    static let shared = Socket()
//    
//    private let pharmacyId = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.UserDefaultKeys.pharmacyId) as? Int
//    
//    private override init() { super.init() }
//    
//    private let socketManager = SocketManager(
//        
//        socketURL: URL(
//            string: "Set Socket Url"
//        )!,
//        
//        config: [
//            .path("Set Socket Path"),
//            .log(true),
//            .forceWebsockets(true)
//        ]
//    )
//    
//    func establishConnection() {
//        
//        socketManager.defaultSocket.connect()
//        listionForDisconnection()
//        print("Socket connected...")
//    }
//    
//    func closeConnection() {
//        socketManager.defaultSocket.off(clientEvent: .disconnect)
//        socketManager.defaultSocket.disconnect()
//        print("Socket disconnected...")
//    }
//    
//    func listionForDisconnection() {
//        socketManager.defaultSocket.on(clientEvent: .disconnect) { [self] data, ack in
//            print("Socket disconnected event get...")
//            stopListionForDisconnection()
//            establishConnection()
//        }
//    }
//    
//    func stopListionForDisconnection() {
//        socketManager.defaultSocket.off(clientEvent: .disconnect)
//    }
//    
//    deinit {
//        closeConnection()
//    }
//    
//}
//
//
