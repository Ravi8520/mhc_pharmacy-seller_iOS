//
//  PharmacyDetailsApiExtension.swift
//  My Health Chart-Pharmacy
//
//  Created by Jatan Ambasana on 03/12/21.
//

import UIKit

extension PharmacyDetailsVC {
    
    func getCountryList() {
        
        Networking.request(
            url: Urls.countryList,
            method: .get,
            headers: nil,
            defaultHeader: false,
            param: nil,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
                
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let countryResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CountryListApiResponse.self)
                    
                    guard let coResponse = countryResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if coResponse.status == StatusCode.success.rawValue {
                        
                        countryData.removeAll()
                        countryData.append(contentsOf: coResponse.data ?? [])
                        
//                        for country in countryData {
//                            if country.countryName!.lowercased().contains("india") {
//                                textfieldCountry.text = country.countryName
//                                selectedCountryId = country.id!
//                                break
//                            }
//                        }
                        
                    } else {
                        AlertHelper.shared.showAlert(message: coResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    func getStateList() {
        
        let param = [
            Parameter.countryId: selectedCountryId
        ]
        
        Networking.request(
            url: Urls.stateList,
            method: .post,
            headers: nil,
            defaultHeader: false,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let stateResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: StateListApiResponse.self)
                    
                    guard let stResponse = stateResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if stResponse.status == StatusCode.success.rawValue {
                        
                        stateData.removeAll()
                        stateData.append(contentsOf: stResponse.data ?? [])
                        
                    } else {
                        AlertHelper.shared.showAlert(message: stResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    func getCityList() {
        
        let param = [
            Parameter.stateId: selectedStateId
        ]
        
        Networking.request(
            url: Urls.cityList,
            method: .post,
            headers: nil,
            defaultHeader: false,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let cityResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: CityListApiResponse.self)
                    
                    guard let ctResponse = cityResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if ctResponse.status == StatusCode.success.rawValue {
                        
                        cityData.removeAll()
                        cityData.append(contentsOf: ctResponse.data ?? [])
                        
                    } else {
                        AlertHelper.shared.showAlert(message: ctResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
    func getPincodeList() {
        
        let param = [
            "cityId": selectedCityId
        ]
        
        Networking.request(
            url: Urls.pincodeList,
            method: .post,
            headers: nil,
            defaultHeader: false,
            param: param,
            fileData: nil,
            isActivityIndicatorActive: true,
            isActivityIndicatorUserInteractionAllow: false
        ) { [self] response in
            
            switch response {
                    
                case .success(let data):
                    
                    guard let jsonData = data else {
                        AlertHelper.shared.showAlert(message: CustomError.missinJsonData.localizedDescription)
                        return
                    }
                    
                    let pincodeResponse = NetworkHelper.decodeJsonData(data: jsonData, decodeWith: PincodeListApiResponse.self)
                    
                    guard let pcResponse = pincodeResponse else {
                        AlertHelper.shared.showAlert(message: CustomError.invalidJsonData.localizedDescription)
                        return
                    }
                    
                    if pcResponse.status == StatusCode.success.rawValue {
                        
                        pincodeData.removeAll()
                        pincodeData.append(contentsOf: pcResponse.data ?? [])
                        
                    } else {
                        AlertHelper.shared.showAlert(message: pcResponse.message!)
                    }
                    
                case .failure(let error):
                    AlertHelper.shared.showAlert(message: error.localizedDescription)
                    Log.e(error.localizedDescription)
            }
            
        }
        
    }
    
}
