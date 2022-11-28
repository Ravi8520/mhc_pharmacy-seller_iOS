//
//  OrderDetailApiExtension.swift
//  My Health Chart-Pharmacy
//
//  Created by Freebird App Studio LLP on 16/12/21.
//

import UIKit

extension OrderDetailVC {
    
    func rejectReasonSelected(id: Int, msg: String) {
        
        let param = [
            Parameter.orderId : orderId,
            Parameter.reasonId : "\(id)"
        ]
        
        Networking.request(
            url: Urls.rejectOrder,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let commonResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let cmResponse = commonResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if cmResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: cmResponse.message!)
                        self.btnBackPressed()
                        
                    } else {
                        AlertHelper.shared.showAlert(message: cmResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    func getOrderDetail() {
        
        guard !orderId.isEmpty else { return }
        
        let param = [
            Parameter.orderId : orderId
        ]
        
        Networking.request(
            url: Urls.orderDetail,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let orderDetailResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: OrderDetailApiResponse.self)
                    
                    guard let odResponse = orderDetailResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    
                    
                    if odResponse.status == StatusCode.success.rawValue {
                        
                        guard let data = odResponse.data else { return }
                        
                        self.orderDetailData = data.first ?? nil
                        
                        self.setupData()
                        
                    } else {
                        AlertHelper.shared.showAlert(message: odResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
        
    }
    
    func acceptOrder() {
        
        let param = [
            Parameter.orderId: orderId
        ]
        
        Networking.request(
            url: Urls.acceptOrder,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let commonResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let cmResponse = commonResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if cmResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: cmResponse.message!, duration: .normal) { [self] in
                            
                            getOrderDetail()
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: cmResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
        
    }
    
    func returnConfirmOrder() {
        
        let param = [
            Parameter.orderId: orderId
        ]
        
        Networking.request(
            url: Urls.confirmReturnOrder,
            method: .post,
            headers: nil,
            defaultHeader: true,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let returnOrderResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CommonApiResponse.self)
                    
                    guard let roResponse = returnOrderResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if roResponse.status == StatusCode.success.rawValue {
                        
                        AlertHelper.shared.showToast(message: roResponse.message!, duration: .normal) {
                            self.getOrderDetail()
                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: roResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
        }
        
    }
    
}
