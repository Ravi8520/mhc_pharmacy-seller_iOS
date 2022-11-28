//
//  NetworkManager.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import Foundation
import Alamofire

class Networking: NSObject {
    
    static func request(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders? = nil,
        defaultHeader: Bool = false,
        param: [String:Any]?,
        fileData: [FileData]?,
        isActivityIndicatorActive: Bool = true,
        isActivityIndicatorUserInteractionAllow: Bool,
        Completion completion: @escaping (Swift.Result<Data?,Error>) -> Void
    ) {
        
        if !Networking.isConnectedToInternet() {
            AlertHelper.shared.showAlert(message: Strings.noNetworkError)
            return
        }
        
        if let _ = fileData {
            
            if fileData!.count > 1 {
                
                makeNetworkRequest(
                    url: url,
                    method: method,
                    headers: headers,
                    defaultHeader: defaultHeader,
                    param: param,
                    fileData: fileData!,
                    isActivityIndicatorActive: isActivityIndicatorActive,
                    isActivityIndicatorUserInteractionAllow: isActivityIndicatorUserInteractionAllow) { response in
                    
                    switch response {
                        case .success(let data):
                            completion(.success(data))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
                
                
            } else {
                
                makeNetworkRequest(
                    url: url,
                    method: method,
                    headers: headers,
                    defaultHeader: defaultHeader,
                    param: param,
                    fileData: fileData!.first!,
                    isActivityIndicatorActive: isActivityIndicatorActive,
                    isActivityIndicatorUserInteractionAllow: isActivityIndicatorUserInteractionAllow) { response in
                    
                    switch response {
                        case .success(let data):
                            completion(.success(data))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            }
            
        } else {
            
            makeNetworkRequest(
                url: url,
                method: method,
                headers: headers,
                defaultHeader: defaultHeader,
                param: param,
                isActivityIndicatorActive: isActivityIndicatorActive,
                isActivityIndicatorUserInteractionAllow: isActivityIndicatorUserInteractionAllow) { response in
                
                switch response {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
    
    static func requestNew(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders? = nil,
        defaultHeader: Bool = false,
        param: [String:Any]?,
        isActivityIndicatorActive: Bool = true,
        isActivityIndicatorUserInteractionAllow: Bool,
        Completion completion: @escaping (Swift.Result<Data?,Error>) -> Void
    ) {
        
        if !Networking.isConnectedToInternet() {
            AlertHelper.shared.showAlert(message: Strings.noNetworkError)
            return
        }
        
        makeNetworkRequestNew(
            url: url,
            method: method,
            headers: headers,
            defaultHeader: defaultHeader,
            param: param,
            isActivityIndicatorActive: isActivityIndicatorActive,
            isActivityIndicatorUserInteractionAllow: isActivityIndicatorUserInteractionAllow) { response in
                
                switch response {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    static func makeNetworkRequestForCreateAccount(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders? = nil,
        defaultHeader: Bool = false,
        param: [String:Any]?,
        partnerShipDeed: [FileData]?,
        drugLicence: [FileData],
        adharCardFront: FileData,
        adharCardBack: FileData?,
        panCard: FileData,
        ownerPhoto: FileData,
        isActivityIndicatorActive: Bool = true,
        isActivityIndicatorUserInteractionAllow: Bool,
        Completion completion: @escaping (Swift.Result<Data?,Error>) -> Void
    ) {
        
        if isActivityIndicatorActive {
            LoadingIndicator.showLoadingView(isUserInteractionAllow: isActivityIndicatorUserInteractionAllow)
        }
        
        var token = ""
        
        let header: HTTPHeaders?
        
        if headers != nil || defaultHeader {
            if let tkn = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.apiToken) as? String {
                token = "\(tkn)"
            }
        }
        
        if defaultHeader {
            header = [
                HTTPHeaderConstant.authorization: token,
                HTTPHeaderConstant.accept: HTTPHeaderConstant.jsonContentType
            ]
        } else {
            header = headers
        }
        
        Log.print("URL::== \(url)")
        Log.print("Method::== \(method.rawValue)")
        Log.print("Header::== \(header ?? [:])")
        Log.print("Params::== \(param ?? [:])")
        
        
        var object : Any?
        var encryptedParams : [String : Any]?
        
        if let _ = param {
            object = NetworkHelper.getJSONString(object: param!)!
            encryptedParams = ["data": Encryption.shared.encryptData(data: object as! String) ?? ""] as [String:Any]
            
            Log.print("Encrypted Params::== \(encryptedParams!)")
            
        }
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in encryptedParams! {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            Log.d("Multipart File Data (ParterShipDeed)::== \(partnerShipDeed ?? [])")
            
            // Partnership deed upload
            if let deed = partnerShipDeed {
                for file in deed {
                    Log.d("Multipart File Data (ParterShipDeed)::== \(file)")
                    multipartFormData.append(
                        file.data,
                        withName: "\(file.key)",
                        fileName: "\(Date().timeIntervalSince1970).\(file.mimeType.fileExtension)",
                        mimeType: file.mimeType.rawValue
                    )
                }
            }
            
            // Drug licence upload
            for licence in drugLicence {
                Log.d("Multipart File Data (drugLicence)::== \(licence)")
                multipartFormData.append(
                    licence.data,
                    withName: "\(licence.key)",
                    fileName: "\(Date().timeIntervalSince1970).\(licence.mimeType.fileExtension)",
                    mimeType: licence.mimeType.rawValue
                )
            }
            
            // Adharcard upload
            
            Log.d("Multipart File Data (adhar card front)::== \(adharCardFront)")
            
            multipartFormData.append(
                adharCardFront.data,
                withName: "\(adharCardFront.key)",
                fileName: "\(Date().timeIntervalSince1970).\(adharCardFront.mimeType.fileExtension)",
                mimeType: adharCardFront.mimeType.rawValue
            )
            
            if let adharBack = adharCardBack {
                Log.d("Multipart File Data (adhar card back)::== \(adharBack)")
                multipartFormData.append(
                    adharBack.data,
                    withName: "\(adharBack.key)",
                    fileName: "\(Date().timeIntervalSince1970).\(adharBack.mimeType.fileExtension)",
                    mimeType: adharBack.mimeType.rawValue
                )
            }
            
            
            // Pan card upload
            Log.d("Multipart File Data (pan card)::== \(panCard)")
            
            multipartFormData.append(
                panCard.data,
                withName: panCard.key,
                fileName: "\(Date().timeIntervalSince1970).\(panCard.mimeType.fileExtension)",
                mimeType: panCard.mimeType.rawValue
            )
            
            // Owner photo upload
            Log.d("Multipart File Data (ownerPhoto)::== \(ownerPhoto)")
            
            multipartFormData.append(
                ownerPhoto.data,
                withName: ownerPhoto.key,
                fileName: "\(Date().timeIntervalSince1970).\(ownerPhoto.mimeType.fileExtension)",
                mimeType: ownerPhoto.mimeType.rawValue
            )
            
        }, usingThreshold: UInt64.init(),
                         to: url,
                         method: method,
                         headers: header,
                         encodingCompletion: {
            
            encodingResult in
            
            switch encodingResult {
                    
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        let statusCode = response.response?.statusCode ?? 501
                        
                        Log.print("Header Status Code:: \(statusCode)")
                        
                        if statusCode == StatusCode.internalServerError.rawValue {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            Log.e(String(data: response.data!, encoding: .utf8)!)
                            
                            completion(.failure(CustomError.serverError))
                            return
                        }
                        
                        guard let jsonData = response.data else {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            completion(.failure(CustomError.missinJsonData))
                            return
                        }
                        
                        let encryptedString = String(data: jsonData, encoding: .utf8)
                        
                        Log.print("Encrypted response:=========:: \(encryptedString ?? CustomError.missinJsonData.localizedDescription)")
                        
                        let decryptedString = Encryption.shared.decryptData(data: encryptedString!)
                        
                        Log.print("Decrypted Response:-=== \(decryptedString ?? CustomError.missinJsonData.localizedDescription)")
                    
                        let decryptedJsonData = decryptedString!.data(using: .utf8)
                        
                        do {
                            
                            let data = try JSONDecoder().decode(CommonApiResponse.self, from: decryptedJsonData!)
                            
                            if data.status == StatusCode.unauthorised.rawValue {
                                
                                if isActivityIndicatorActive {
                                    LoadingIndicator.hideLoadingView()
                                }
                                
                                AlertHelper.shared.showAlert(
                                    message: data.message!) { action in
                                        
                                        Helper.shared.setLogout()
                                    }
                                return
                            }
                            
                        } catch  {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            Log.e("CommonApiResponse parsing error:- \(error)")
                            completion(.failure(CustomError.missinJsonData))
                            return
                        }
                        
                        if isActivityIndicatorActive {
                            LoadingIndicator.hideLoadingView()
                        }
                        
                        completion(.success(decryptedJsonData!))
                        
                    }
                    
                case .failure(let error):
                    
                    if isActivityIndicatorActive {
                        LoadingIndicator.hideLoadingView()
                    }
                    
                    Log.e("Networking error:- \(error)")
                    completion(.failure(CustomError.serverError))
            }
        })
        
        
    }
    
    
    /// Multipart file upload method
    private static func makeNetworkRequest(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders? = nil,
        defaultHeader: Bool = false,
        param: [String:Any]?,
        fileData: FileData,
        isActivityIndicatorActive: Bool = true,
        isActivityIndicatorUserInteractionAllow: Bool,
        Completion completion: @escaping (Swift.Result<Data?,Error>) -> Void
    ) {
        
        if isActivityIndicatorActive {
            LoadingIndicator.showLoadingView(isUserInteractionAllow: isActivityIndicatorUserInteractionAllow)
        }
        
        var token = ""
        
        let header: HTTPHeaders?
        
        if headers != nil || defaultHeader {
            if let tkn = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.apiToken) as? String {
                token = "\(tkn)"
            }
        }
        
        if defaultHeader {
            header = [
                HTTPHeaderConstant.authorization: token,
                HTTPHeaderConstant.accept: HTTPHeaderConstant.jsonContentType
            ]
        } else {
            header = headers
        }
        
        Log.print("URL::== \(url)")
        Log.print("Method::== \(method.rawValue)")
        Log.print("Header::== \(header ?? [:])")
        Log.print("Params::== \(param ?? [:])")
        
        
        var object : Any?
        var encryptedParams : [String : Any]?
        
        if let _ = param {
            object = NetworkHelper.getJSONString(object: param!)!
            encryptedParams = ["data": Encryption.shared.encryptData(data: object as! String) ?? ""] as [String:Any]
            
            Log.print("Encrypted Params::== \(encryptedParams!)")
            
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in encryptedParams! {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            Log.d("Multipart File Data::== \(fileData)")
            multipartFormData.append(fileData.data, withName: fileData.key, fileName: "\(Date().timeIntervalSince1970).\(fileData.mimeType.fileExtension)", mimeType: fileData.mimeType.rawValue)
            
        }, usingThreshold: UInt64.init(),
        to: url,
        method: method,
        headers: header,
        encodingCompletion: {
            
            encodingResult in
            
            switch encodingResult {
                
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        let statusCode = response.response?.statusCode ?? 501
                        
                        Log.print("Header Status Code:: \(statusCode)")
                        
                        if statusCode == StatusCode.internalServerError.rawValue {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            Log.e(String(data: response.data!, encoding: .utf8)!)
                            
                            completion(.failure(CustomError.serverError))
                            return
                        }
                        
                        guard let jsonData = response.data else {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            completion(.failure(CustomError.missinJsonData))
                            return
                        }
                        
                        let encryptedString = String(data: jsonData, encoding: .utf8)
                        
                        Log.print("Encrypted response:=========:: \(encryptedString ?? CustomError.missinJsonData.localizedDescription)")
                        
                        let decryptedString = Encryption.shared.decryptData(data: encryptedString!)
                        
                        Log.print("Decrypted Response:-=== \(decryptedString ?? CustomError.missinJsonData.localizedDescription)")
                    
                        let decryptedJsonData = decryptedString!.data(using: .utf8)
                        
                        do {
                            
                            let data = try JSONDecoder().decode(CommonApiResponse.self, from: decryptedJsonData!)
                            
                            if data.status == StatusCode.unauthorised.rawValue {
                            
                                if isActivityIndicatorActive {
                                    LoadingIndicator.hideLoadingView()
                                }
                                
                                AlertHelper.shared.showAlert(
                                    message: data.message!) { action in
                                    
                                    Helper.shared.setLogout()
                                }
                                return
                            }
                            
                        } catch  {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            Log.e("CommonApiResponse parsing error:- \(error)")
                            completion(.failure(CustomError.missinJsonData))
                            return
                        }
                        
                        if isActivityIndicatorActive {
                            LoadingIndicator.hideLoadingView()
                        }
                        
                        completion(.success(decryptedJsonData!))
                        
                    }
                    
                case .failure(let error):
                    
                    if isActivityIndicatorActive {
                        LoadingIndicator.hideLoadingView()
                    }
                    
                    Log.e("Networking error:- \(error)")
                    completion(.failure(CustomError.serverError))
            }
        })
    }
    
    /// Multipart file array upload method
    private static func makeNetworkRequest(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders? = nil,
        defaultHeader: Bool = false,
        param: [String:Any]?,
        fileData: [FileData],
        isActivityIndicatorActive: Bool = true,
        isActivityIndicatorUserInteractionAllow: Bool,
        Completion completion: @escaping (Swift.Result<Data?,Error>) -> Void
    ) {
        
        if isActivityIndicatorActive {
            LoadingIndicator.showLoadingView(isUserInteractionAllow: isActivityIndicatorUserInteractionAllow)
        }
        
        var token = ""
        
        let header: HTTPHeaders?
        
        if headers != nil || defaultHeader {
            if let tkn = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.apiToken) as? String {
                token = "\(tkn)"
            }
        }
        
        if defaultHeader {
            header = [
                HTTPHeaderConstant.authorization: token,
                HTTPHeaderConstant.accept: HTTPHeaderConstant.jsonContentType
            ]
        } else {
            header = headers
        }
        
        Log.print("URL::== \(url)")
        Log.print("Method::== \(method.rawValue)")
        Log.print("Header::== \(header ?? [:])")
        Log.print("Params::== \(param ?? [:])")
        
        
        var object : Any?
        var encryptedParams : [String : Any]?
        
        if let _ = param {
            object = NetworkHelper.getJSONString(object: param!)!
            encryptedParams = ["data": Encryption.shared.encryptData(data: object as! String) ?? ""] as [String:Any]
            
            Log.print("Encrypted Params::== \(encryptedParams!)")
            
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in encryptedParams! {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            for file in fileData {
                Log.d("Multipart File Data::== \(file)")
                multipartFormData.append(file.data, withName: "\(file.key)", fileName: "\(Date().timeIntervalSince1970).\(file.mimeType.fileExtension)", mimeType: file.mimeType.rawValue)
            }
        
        }, usingThreshold: UInt64.init(),
        to: url,
        method: method,
        headers: header,
        encodingCompletion: {
            
            encodingResult in
            
            switch encodingResult {
                
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        let statusCode = response.response?.statusCode ?? 501
                        
                        Log.print("Header Status Code:: \(statusCode)")
                        
                        if statusCode == StatusCode.internalServerError.rawValue {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            Log.e(String(data: response.data!, encoding: .utf8)!)
                            
                            completion(.failure(CustomError.serverError))
                            return
                        }
                        
                        guard let jsonData = response.data else {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            completion(.failure(CustomError.missinJsonData))
                            return
                        }
                        
                        let encryptedString = String(data: jsonData, encoding: .utf8)
                        
                        Log.print("Encrypted response:=========:: \(encryptedString ?? CustomError.missinJsonData.localizedDescription)")
                        
                        let decryptedString = Encryption.shared.decryptData(data: encryptedString!)
                        
                        Log.print("Decrypted Response:-=== \(decryptedString ?? CustomError.missinJsonData.localizedDescription)")
                    
                        let decryptedJsonData = decryptedString!.data(using: .utf8)
                        
                        do {
                            
                            let data = try JSONDecoder().decode(CommonApiResponse.self, from: decryptedJsonData!)
                            
                            if data.status == StatusCode.unauthorised.rawValue {
                                
                                if isActivityIndicatorActive {
                                    LoadingIndicator.hideLoadingView()
                                }
                                
                                AlertHelper.shared.showAlert(
                                    message: data.message!) { action in
                                    
                                    Helper.shared.setLogout()
                                }
                                return
                            }
                            
                        } catch  {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            Log.e("CommonApiResponse parsing error:- \(error)")
                            completion(.failure(CustomError.missinJsonData))
                            return
                        }
                        
                        if isActivityIndicatorActive {
                            LoadingIndicator.hideLoadingView()
                        }
                        
                        completion(.success(decryptedJsonData!))
                        
                    }
                    
                case .failure(let error):
                    
                    if isActivityIndicatorActive {
                        LoadingIndicator.hideLoadingView()
                    }
                    
                    Log.e("Networking error:- \(error)")
                    completion(.failure(CustomError.serverError))
            }
        })
    }
    
    
    /// Regular network request method
    private static func makeNetworkRequest(
        
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders? = nil,
        defaultHeader: Bool = false,
        param: [String : Any]?,
        isActivityIndicatorActive: Bool = true,
        isActivityIndicatorUserInteractionAllow: Bool,
        Completion completion: @escaping (Swift.Result<Data?,Error>) -> Void
    ) {
        
        if isActivityIndicatorActive {
            LoadingIndicator.showLoadingView(isUserInteractionAllow: isActivityIndicatorUserInteractionAllow)
        }
        
        var token = ""
        
        let header: HTTPHeaders?
        
        if headers != nil || defaultHeader {
            if let tkn = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.apiToken) as? String {
                token = "\(tkn)"
            }
        }
        
        if defaultHeader {
            header = [
                HTTPHeaderConstant.authorization: token,
                HTTPHeaderConstant.accept: HTTPHeaderConstant.jsonContentType
            ]
        } else {
            header = headers
        }
        
        Log.print("URL::== \(url)")
        Log.print("Method::== \(method.rawValue)")
        Log.print("Header::== \(header ?? [:])")
        Log.print("Params::== \(param ?? [:])")
        
        
        var object : Any?
        var encryptedParams : [String : Any]?
        
        if let _ = param {
            object = NetworkHelper.getJSONString(object: param!)!
            encryptedParams = ["data": Encryption.shared.encryptData(data: object as! String) ?? ""] as [String:Any]
            
            Log.print("Encrypted Params::== \(encryptedParams!)")
        }
        
        Alamofire.request(
            
            url,
            method: method,
            parameters: encryptedParams,
            encoding: URLEncoding.default,
            headers: header).responseData { (responseData) in
            
                switch responseData.result {
                    
                    case .success(_):
                        
                        let statusCode = responseData.response?.statusCode ?? 501
                        
                        Log.print("Header Status Code:: \(statusCode)")
                        
                        if statusCode == StatusCode.internalServerError.rawValue {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            Log.e(String(data: responseData.data!, encoding: .utf8)!)
                            
                            completion(.failure(CustomError.serverError))
                            
                            return
                        }
                        
                        guard let jsonData = responseData.data else {
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            completion(.failure(CustomError.missinJsonData))
                            return
                        }
                        
                        let encryptedString = String(data: jsonData, encoding: .utf8)
                        
                        Log.print("Encrypted response:=========:: \(encryptedString ?? CustomError.missinJsonData.localizedDescription)")
                        
                        let decryptedString = Encryption.shared.decryptData(data: encryptedString!)
                        
                        Log.print("Decrypted Response:-=== \(decryptedString ?? CustomError.missinJsonData.localizedDescription)")
                        
                        let decryptedJsonData = decryptedString!.data(using: .utf8)
                        
                        do {
                            
                            let data = try JSONDecoder().decode(CommonApiResponse.self, from: decryptedJsonData!)
                            
                            if data.status == StatusCode.unauthorised.rawValue {
                                
                                if isActivityIndicatorActive {
                                    LoadingIndicator.hideLoadingView()
                                }
                                
                                AlertHelper.shared.showAlert(
                                    message: data.message!) { action in
                                    
                                    Helper.shared.setLogout()
                                }
                                return
                            }
                            
                        } catch  {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            Log.e("CommonApiResponse parsing error:- \(error)")
                            completion(.failure(CustomError.missinJsonData))
                            return
                        }
                        
                        if isActivityIndicatorActive {
                            LoadingIndicator.hideLoadingView()
                        }
                        
                        completion(.success(decryptedJsonData!))
                        
                    case .failure(let error):
                        
                        if isActivityIndicatorActive {
                            LoadingIndicator.hideLoadingView()
                        }
                        
                        Log.e("Networking error:- \(error)")
                        completion(.failure(CustomError.serverError))
                }
            }
    }
    
    private static func makeNetworkRequestNew(
        
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders? = nil,
        defaultHeader: Bool = false,
        param: [String : Any]?,
        isActivityIndicatorActive: Bool = true,
        isActivityIndicatorUserInteractionAllow: Bool,
        Completion completion: @escaping (Swift.Result<Data?,Error>) -> Void
    ) {
        
        if isActivityIndicatorActive {
            LoadingIndicator.showLoadingView(isUserInteractionAllow: isActivityIndicatorUserInteractionAllow)
        }
        
        var token = ""
        
        let header: HTTPHeaders?
        
        if headers != nil || defaultHeader {
            if let tkn = UserDefaultHelper.shared.getUserData(key: UserDefaultHelper.keys.apiToken) as? String {
                token = "\(tkn)"
            }
        }
        
        if defaultHeader {
            header = [
                HTTPHeaderConstant.authorization: token,
                HTTPHeaderConstant.accept: HTTPHeaderConstant.jsonContentType
            ]
        } else {
            header = headers
        }
        
        Log.print("URL::== \(url)")
        Log.print("Method::== \(method.rawValue)")
        Log.print("Header::== \(header ?? [:])")
        Log.print("Params::== \(param ?? [:])")
        
        Alamofire.request(
            
            url,
            method: method,
            parameters: param,
            encoding: URLEncoding.default,
            headers: header).responseData { (responseData) in
                
                switch responseData.result {
                    
                case .success(_):
                    
                    let statusCode = responseData.response?.statusCode ?? 501
                    
                    Log.print("Header Status Code:: \(statusCode)")
                    
                    if statusCode == StatusCode.internalServerError.rawValue {
                        
                        if isActivityIndicatorActive {
                            LoadingIndicator.hideLoadingView()
                        }
                        
                        Log.e(String(data: responseData.data!, encoding: .utf8)!)
                        
                        completion(.failure(CustomError.serverError))
                        
                        return
                    }
                    
                    guard let jsonData = responseData.data else {
                        if isActivityIndicatorActive {
                            LoadingIndicator.hideLoadingView()
                        }
                        completion(.failure(CustomError.missinJsonData))
                        return
                    }
                    
                    do {
                        let data = try JSONDecoder().decode(CommonApiResponse.self, from: jsonData)
                        
                        if data.status == StatusCode.unauthorised.rawValue {
                            
                            if isActivityIndicatorActive {
                                LoadingIndicator.hideLoadingView()
                            }
                            
                            AlertHelper.shared.showAlert(
                                message: data.message!) { action in
                                    
                                    Helper.shared.setLogout()
                                }
                            return
                        }
                        
                    } catch  {
                        
                        if isActivityIndicatorActive {
                            LoadingIndicator.hideLoadingView()
                        }
                        
                        Log.e("CommonApiResponse parsing error:- \(error)")
                        completion(.failure(CustomError.missinJsonData))
                        return
                    }
                    
                    if isActivityIndicatorActive {
                        LoadingIndicator.hideLoadingView()
                    }
                    
                    completion(.success(jsonData))
                    
                case .failure(let error):
                    
                    if isActivityIndicatorActive {
                        LoadingIndicator.hideLoadingView()
                    }
                    
                    Log.e("Networking error:- \(error)")
                    completion(.failure(CustomError.serverError))
                }
            }
    }
    
    static func remoteResource(
        at stringUrl: String,
        isOneOf types: [MimeTypes],
        completion: @escaping ((Bool) -> Void)) {
            
            guard !stringUrl.isEmpty else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            let url = URL(string: stringUrl)
            
            guard url != nil else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "HEAD"
            
            let task = URLSession.shared.dataTask(
                with: request
            ) { (data, response, error) in
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == StatusCode.success.rawValue,
                      let mimeType = response.mimeType else {
                          
                          DispatchQueue.main.async {
                              completion(false)
                          }
                          return
                      }
                
                if types.map({ $0.rawValue }).contains(mimeType) {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
            task.resume()
    }
    
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
}
