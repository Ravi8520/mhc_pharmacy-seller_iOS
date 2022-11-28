//
//  DashboardApiModel.swift
//  My Health Chart-Pharmacy
//
//  Created by Freebird App Studio LLP on 14/12/21.
//

import Foundation

struct EarningApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : EarningDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(EarningDataApiResponse.self, forKey: .data)
    }
    
}
struct EarningDataApiResponse : Codable {
    let totalPage : Int?
    let totalOrder : Int?
    let totalIncome : String?
    let content : [EarningContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case totalOrder = "totalOrder"
        case totalIncome = "totalIncome"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        totalOrder = try values.decodeIfPresent(Int.self, forKey: .totalOrder)
        totalIncome = try values.decodeIfPresent(String.self, forKey: .totalIncome)
        content = try values.decodeIfPresent([EarningContentApiResponse].self, forKey: .content)
    }
    
}
struct EarningContentApiResponse : Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let orderTime : String?
    let deliveryBoyname : String?
    let orderAmt : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case orderTime = "orderTime"
        case deliveryBoyname = "deliveryBoyname"
        case orderAmt = "orderAmt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        orderTime = try values.decodeIfPresent(String.self, forKey: .orderTime)
        deliveryBoyname = try values.decodeIfPresent(String.self, forKey: .deliveryBoyname)
        orderAmt = try values.decodeIfPresent(Double.self, forKey: .orderAmt)
    }
    
}

struct TodayPendingOrderApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : TodayPendingOrderDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(TodayPendingOrderDataApiResponse.self, forKey: .data)
    }
    
}
struct TodayPendingOrderDataApiResponse : Codable {
    let totalPage : Int?
    let content : [TodayPendingOrderContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([TodayPendingOrderContentApiResponse].self, forKey: .content)
    }
    
}
struct TodayPendingOrderContentApiResponse : Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let orderTime : String?
    let deliveryBoyname : String?
    let orderStatus : String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case orderTime = "orderTime"
        case deliveryBoyname = "deliveryBoyname"
        case orderStatus = "orderStatus"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        orderTime = try values.decodeIfPresent(String.self, forKey: .orderTime)
        deliveryBoyname = try values.decodeIfPresent(String.self, forKey: .deliveryBoyname)
        orderStatus = try values.decodeIfPresent(String.self, forKey: .orderStatus)
    }
    
}

struct DeliveryApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : DeliveryDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(DeliveryDataApiResponse.self, forKey: .data)
    }
    
}
struct DeliveryDataApiResponse : Codable {
    let totalPage : Int?
    let content : [DeliveryContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([DeliveryContentApiResponse].self, forKey: .content)
    }
    
}
struct DeliveryContentApiResponse : Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let deliveryTime : String?
    let deliveryBoyname : String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case deliveryTime = "deliveryTime"
        case deliveryBoyname = "deliveryBoyname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        deliveryTime = try values.decodeIfPresent(String.self, forKey: .deliveryTime)
        deliveryBoyname = try values.decodeIfPresent(String.self, forKey: .deliveryBoyname)
    }
    
}

struct NotificationApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : NotificationDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(NotificationDataApiResponse.self, forKey: .data)
    }
    
}
struct NotificationDataApiResponse : Codable {
    let totalPage : Int?
    let content : [NotificationContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([NotificationContentApiResponse].self, forKey: .content)
    }
    
}
struct NotificationContentApiResponse : Codable {
    let id : Int?
    let title : String?
    let subtitle : String?
    let orderId : Int?
    let created_date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case subtitle = "subtitle"
        case orderId = "orderId"
        case created_date = "created_date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
        orderId = try values.decodeIfPresent(Int.self, forKey: .orderId)
        created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
    }
    
}
