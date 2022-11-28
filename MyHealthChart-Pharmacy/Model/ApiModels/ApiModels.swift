//
//  ApiModels.swift
//  My Health Chart-Pharmacy
//
//  Created by Freebird App Studio LLP on 15/12/21.
//

import Foundation

struct PackageListApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : [PackageListDataApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([PackageListDataApiResponse].self, forKey: .data)
    }
    
}
struct PackageListDataApiResponse : Codable {
    let id : Int?
    let noOfDelivery : Int?
    let packageName : String?
    let packageAmt : Int?
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case noOfDelivery = "noOfDelivery"
        case packageName = "packageName"
        case packageAmt = "packageAmt"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        noOfDelivery = try values.decodeIfPresent(Int.self, forKey: .noOfDelivery)
        packageName = try values.decodeIfPresent(String.self, forKey: .packageName)
        packageAmt = try values.decodeIfPresent(Int.self, forKey: .packageAmt)
        date = try values.decodeIfPresent(String.self, forKey: .date)
    }
    
}

struct ReferralUsersApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : ReferralUsersDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ReferralUsersDataApiResponse.self, forKey: .data)
    }
    
}
struct ReferralUsersDataApiResponse : Codable {
    let totalPage : Int?
    let content : [ReferralUsersContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([ReferralUsersContentApiResponse].self, forKey: .content)
    }
    
}
struct ReferralUsersContentApiResponse : Codable {
    let id : Int?
    let userName : String?
    let date : String?
    let profile_image : String?
    let profile : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case userName = "userName"
        case date = "date"
        case profile_image = "profile_image"
        case profile = "profile"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
        profile = try values.decodeIfPresent(String.self, forKey: .profile)
    }
    
}
