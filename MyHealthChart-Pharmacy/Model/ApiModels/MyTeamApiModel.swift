//
//  MyTeamApiModel.swift
//  My Health Chart-Pharmacy
//
//  Created by Freebird App Studio LLP on 09/12/21.
//

import Foundation

struct MyTeamListApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : [MyTeamListDataApiResponse]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([MyTeamListDataApiResponse].self, forKey: .data)
    }

}
struct MyTeamListDataApiResponse : Codable {
    let id : Int?
    let name : String?
    let userType : String?
    let userStatus : String?
    let orderCount : String?
    let mobileNo : String?
    let isActive : String?
    let profile_image : String?
    let profile : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case userType = "userType"
        case userStatus = "userStatus"
        case orderCount = "orderCount"
        case mobileNo = "mobileNo"
        case isActive = "isActive"
        case profile_image = "profile_image"
        case profile = "profile"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        userStatus = try values.decodeIfPresent(String.self, forKey: .userStatus)
        orderCount = try values.decodeIfPresent(String.self, forKey: .orderCount)
        mobileNo = try values.decodeIfPresent(String.self, forKey: .mobileNo)
        isActive = try values.decodeIfPresent(String.self, forKey: .isActive)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
        profile = try values.decodeIfPresent(String.self, forKey: .profile)
    }

}

struct MyTeamDetailApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : [MyTeamDetailDataApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([MyTeamDetailDataApiResponse].self, forKey: .data)
    }
    
}
struct MyTeamDetailDataApiResponse : Codable {
    let id : Int?
    let name : String?
    let userType : String?
    let userStatus : String?
    let orderCount : String?
    let email : String?
    let mobileNo : String?
    let isActive : String?
    let blockNo : String?
    let streetName : String?
    let landmark : String?
    let pincode : String?
    let profile_image : String?
    let profile : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case userType = "userType"
        case userStatus = "userStatus"
        case orderCount = "orderCount"
        case email = "email"
        case mobileNo = "mobileNo"
        case isActive = "isActive"
        case blockNo = "blockNo"
        case streetName = "streetName"
        case landmark = "landmark"
        case pincode = "pincode"
        case profile_image = "profile_image"
        case profile = "profile"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        userStatus = try values.decodeIfPresent(String.self, forKey: .userStatus)
        orderCount = try values.decodeIfPresent(String.self, forKey: .orderCount)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        mobileNo = try values.decodeIfPresent(String.self, forKey: .mobileNo)
        isActive = try values.decodeIfPresent(String.self, forKey: .isActive)
        blockNo = try values.decodeIfPresent(String.self, forKey: .blockNo)
        streetName = try values.decodeIfPresent(String.self, forKey: .streetName)
        landmark = try values.decodeIfPresent(String.self, forKey: .landmark)
        pincode = try values.decodeIfPresent(String.self, forKey: .pincode)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
        profile = try values.decodeIfPresent(String.self, forKey: .profile)
    }
    
}

struct SellerProfileApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : MyTeamDetailDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(MyTeamDetailDataApiResponse.self, forKey: .data)
    }
    
}
