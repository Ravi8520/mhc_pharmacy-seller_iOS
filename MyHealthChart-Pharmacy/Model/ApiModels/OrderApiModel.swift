//
//  OrderApiModel.swift
//  My Health Chart-Pharmacy
//
//  Created by Freebird App Studio LLP on 10/12/21.
//

import Foundation

struct DashboardCountApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : DashboardCountDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(DashboardCountDataApiResponse.self, forKey: .data)
    }
    
}
struct DashboardCountDataApiResponse : Codable {
    let todayEarning : String?
    let thisMonthEarning : String?
    let todayTotalDelivery : Int?
    let todayCompleteDelivery: Int?
    let todayTotalInternalDelivery : Int?
    let todayCompleteInternalDelivery : Int?
    let totalInternalDelivery : Int?
    let todayTotalLogisticDelivery : Int?
    let todayCompleteLogisticDelivery : Int?
    let remainingLogisticDelivery: Int?
    let upcomingOrders : Int?
    let acceptedOrders : Int?
    let readyForPickupOrders : Int?
    let outForDeliveryOrders : Int?
    let completedOrders : Int?
    let manualDeliveryPendingOrders : Int?
    let manualDeliveryCompleteOrders : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case todayEarning = "todayEarning"
        case thisMonthEarning = "thisMonthEarning"
        case todayTotalDelivery = "todayTotalDelivery"
        case todayCompleteDelivery = "todayCompleteDelivery"
        case todayTotalInternalDelivery = "todayTotalInternalDelivery"
        case todayCompleteInternalDelivery = "todayCompleteInternalDelivery"
        case totalInternalDelivery = "totalInternalDelivery"
        case todayTotalLogisticDelivery = "todayTotalLogisticDelivery"
        case todayCompleteLogisticDelivery = "todayCompleteLogisticDelivery"
        case remainingLogisticDelivery = "remainingLogisticDelivery"
        case upcomingOrders = "upcomingOrders"
        case acceptedOrders = "acceptedOrders"
        case readyForPickupOrders = "readyForPickupOrders"
        case outForDeliveryOrders = "outForDeliveryOrders"
        case completedOrders = "completedOrders"
        case manualDeliveryPendingOrders = "manualDeliveryPendingOrders"
        case manualDeliveryCompleteOrders = "manualDeliveryCompleteOrders"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        todayEarning = try values.decodeIfPresent(String.self, forKey: .todayEarning)
        thisMonthEarning = try values.decodeIfPresent(String.self, forKey: .thisMonthEarning)
        todayTotalDelivery = try values.decodeIfPresent(Int.self, forKey: .todayTotalDelivery)
        todayTotalInternalDelivery = try values.decodeIfPresent(Int.self, forKey: .todayTotalInternalDelivery)
        todayCompleteInternalDelivery = try values.decodeIfPresent(Int.self, forKey: .todayCompleteInternalDelivery)
        totalInternalDelivery = try values.decodeIfPresent(Int.self, forKey: .totalInternalDelivery)
        todayTotalLogisticDelivery = try values.decodeIfPresent(Int.self, forKey: .todayTotalLogisticDelivery)
        todayCompleteLogisticDelivery = try values.decodeIfPresent(Int.self, forKey: .todayCompleteLogisticDelivery)
        remainingLogisticDelivery = try values.decodeIfPresent(Int.self, forKey: .remainingLogisticDelivery)
        upcomingOrders = try values.decodeIfPresent(Int.self, forKey: .upcomingOrders)
        acceptedOrders = try values.decodeIfPresent(Int.self, forKey: .acceptedOrders)
        readyForPickupOrders = try values.decodeIfPresent(Int.self, forKey: .readyForPickupOrders)
        outForDeliveryOrders = try values.decodeIfPresent(Int.self, forKey: .outForDeliveryOrders)
        completedOrders = try values.decodeIfPresent(Int.self, forKey: .completedOrders)
        todayCompleteDelivery = try values.decodeIfPresent(Int.self, forKey: .todayCompleteDelivery)
        manualDeliveryPendingOrders = try values.decodeIfPresent(Int.self, forKey: .manualDeliveryPendingOrders)
        manualDeliveryCompleteOrders = try values.decodeIfPresent(Int.self, forKey: .manualDeliveryCompleteOrders)

    }
    
}

struct CommonOrderApiReponse : Codable {
    let status : Int?
    let message : String?
    let data : CommonOrderDataApiReponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(CommonOrderDataApiReponse.self, forKey: .data)
    }
    
}
struct CommonOrderDataApiReponse : Codable {
    let totalPage : Int?
    let content : [CommonOrderContentApiReponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([CommonOrderContentApiReponse].self, forKey: .content)
    }
    
}
struct CommonOrderContentApiReponse : Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let receiveTime : String?
    let userType : String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case receiveTime = "receiveTime"
        case userType = "userType"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        receiveTime = try values.decodeIfPresent(String.self, forKey: .receiveTime)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
    }
    
}

struct ActiveDeliveryBoyApiReponse : Codable {
    let status : Int?
    let message : String?
    let data : [ActiveDeliveryBoyDataApiReponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([ActiveDeliveryBoyDataApiReponse].self, forKey: .data)
    }
    
}
struct ActiveDeliveryBoyDataApiReponse : Codable {
    let id : String?
    let deliveryBoyname : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case deliveryBoyname = "deliveryBoyname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        deliveryBoyname = try values.decodeIfPresent(String.self, forKey: .deliveryBoyname)
    }
    
}

struct ReadyForPickupOrderApiResponse: Codable {
    let status : Int?
    let message : String?
    let data : ReadyForPickupOrderDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ReadyForPickupOrderDataApiResponse.self, forKey: .data)
    }
}
struct ReadyForPickupOrderDataApiResponse: Codable {
    let totalPage : Int?
    let content : [ReadyForPickupContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([ReadyForPickupContentApiResponse].self, forKey: .content)
    }
}
struct ReadyForPickupContentApiResponse: Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let assignTime : String?
    let isLogisticDelivery: String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case assignTime = "assignTime"
        case isLogisticDelivery = "isLogisticDelivery"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        assignTime = try values.decodeIfPresent(String.self, forKey: .assignTime)
        isLogisticDelivery = try values.decodeIfPresent(String.self, forKey: .isLogisticDelivery)
    }
}

struct OutForDeliveryOrderApiResponse: Codable {
    let status : Int?
    let message : String?
    let data : OutForDeliveryOrderDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(OutForDeliveryOrderDataApiResponse.self, forKey: .data)
    }
}
struct OutForDeliveryOrderDataApiResponse: Codable {
    let totalPage : Int?
    let content : [OutForDeliveryContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([OutForDeliveryContentApiResponse].self, forKey: .content)
    }
}
struct OutForDeliveryContentApiResponse: Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let pickupTime : String?
    let deliveryBoyname: String?
    let isLogisticDelivery: String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case pickupTime = "pickupTime"
        case deliveryBoyname = "deliveryBoyname"
        case isLogisticDelivery = "isLogisticDelivery"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        pickupTime = try values.decodeIfPresent(String.self, forKey: .pickupTime)
        deliveryBoyname = try values.decodeIfPresent(String.self, forKey: .deliveryBoyname)
        isLogisticDelivery = try values.decodeIfPresent(String.self, forKey: .isLogisticDelivery)
    }
}

struct CompleteOrderApiResponse: Codable {
    let status : Int?
    let message : String?
    let data : CompleteOrderDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(CompleteOrderDataApiResponse.self, forKey: .data)
    }
}
struct CompleteOrderDataApiResponse: Codable {
    let totalPage : Int?
    let content : [CompleteOrderContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([CompleteOrderContentApiResponse].self, forKey: .content)
    }
}
struct CompleteOrderContentApiResponse: Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let deliveryTime : String?
    let deliveryBoyname: String?
    let rating: String?
    let deliveryType: String?
        
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case deliveryTime = "deliveryTime"
        case deliveryBoyname = "deliveryBoyname"
        case rating = "rating"
        case deliveryType = "isLogisticDelivery"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        deliveryTime = try values.decodeIfPresent(String.self, forKey: .deliveryTime)
        deliveryBoyname = try values.decodeIfPresent(String.self, forKey: .deliveryBoyname)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        deliveryType = try values.decodeIfPresent(String.self, forKey: .deliveryType)
    }
}

struct RejectReasonApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : [RejectReasonDataApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([RejectReasonDataApiResponse].self, forKey: .data)
    }
    
}
struct RejectReasonDataApiResponse : Codable {
    let id : Int?
    let reason : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case reason = "reason"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
    }
    
}

struct RejectOrderApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : RejectOrderDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(RejectOrderDataApiResponse.self, forKey: .data)
    }
    
}
struct RejectOrderDataApiResponse : Codable {
    let totalPage : Int?
    let content : [RejectOrderContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([RejectOrderContentApiResponse].self, forKey: .content)
    }
    
}
struct RejectOrderContentApiResponse : Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let rejectReason : String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case rejectReason = "rejectReason"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        rejectReason = try values.decodeIfPresent(String.self, forKey: .rejectReason)
    }
    
}

struct CancelOrderApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : CancelOrderDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(CancelOrderDataApiResponse.self, forKey: .data)
    }
    
}
struct CancelOrderDataApiResponse : Codable {
    let totalPage : Int?
    let content : [CancelOrderContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([CancelOrderContentApiResponse].self, forKey: .content)
    }
    
}
struct CancelOrderContentApiResponse : Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let cancelledReason : String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case cancelledReason = "cancelledReason"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        cancelledReason = try values.decodeIfPresent(String.self, forKey: .cancelledReason)
    }
    
}

struct ManualOrderApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : ManualOrderDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ManualOrderDataApiResponse.self, forKey: .data)
    }
    
}

struct ManualOrderDataApiResponse : Codable {
    let totalPage : Int?
    let content : [ManualOrderContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([ManualOrderContentApiResponse].self, forKey: .content)
    }
    
}

struct ManualOrderContentApiResponse : Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let createTime : String?
    let createdBy : String?
    let cancelTime : String?
    let pickupTime : String?

    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case createTime = "createTime"
        case createdBy = "created_by"
        case cancelTime = "cancelTime"
        case pickupTime = "pickupTime"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        createTime = try values.decodeIfPresent(String.self, forKey: .createTime)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
        cancelTime = try values.decodeIfPresent(String.self, forKey: .cancelTime)
        pickupTime = try values.decodeIfPresent(String.self, forKey: .pickupTime)

    }
    
}


struct ReturnOrderApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : ReturnOrderDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ReturnOrderDataApiResponse.self, forKey: .data)
    }
    
}
struct ReturnOrderDataApiResponse : Codable {
    let totalPage : Int?
    let content : [ReturnOrderContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([ReturnOrderContentApiResponse].self, forKey: .content)
    }
    
}
struct ReturnOrderContentApiResponse : Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let deliveryTime : String?
    let deliveryBoyname : String?
    let returnConfirmDate : String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case deliveryTime = "deliveryTime"
        case deliveryBoyname = "deliveryBoyname"
        case returnConfirmDate = "returnConfirmDate"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        deliveryTime = try values.decodeIfPresent(String.self, forKey: .deliveryTime)
        deliveryBoyname = try values.decodeIfPresent(String.self, forKey: .deliveryBoyname)
        returnConfirmDate = try values.decodeIfPresent(String.self, forKey: .returnConfirmDate)
    }
    
}

struct OrderReportListApiReponse : Codable {
    let status : Int?
    let message : String?
    let data : OrderReportListDataApiReponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(OrderReportListDataApiReponse.self, forKey: .data)
    }
    
}
struct OrderReportListDataApiReponse : Codable {
    let totalPage : Int?
    let content : [OrderReportListContentApiReponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([OrderReportListContentApiReponse].self, forKey: .content)
    }
    
}
struct OrderReportListContentApiReponse : Codable {
    let orderId : String?
    let orderNo : String?
    let customerName : String?
    let deliveryTime : String?
    let deliveryBoyname : String?
    let rating : String?
    let deliveryType : String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderNo = "orderNo"
        case customerName = "customerName"
        case deliveryTime = "deliveryTime"
        case deliveryBoyname = "deliveryBoyname"
        case rating = "rating"
        case deliveryType = "deliveryType"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderNo = try values.decodeIfPresent(String.self, forKey: .orderNo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        deliveryTime = try values.decodeIfPresent(String.self, forKey: .deliveryTime)
        deliveryBoyname = try values.decodeIfPresent(String.self, forKey: .deliveryBoyname)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        deliveryType = try values.decodeIfPresent(String.self, forKey: .deliveryType)
    }
    
}

struct IncomeReportApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : IncomeReportDataApiResponse?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(IncomeReportDataApiResponse.self, forKey: .data)
    }
    
}
struct IncomeReportDataApiResponse : Codable {
    let totalEarning : String?
    let content : [IncomeReportYearViseContent]?

    enum CodingKeys: String, CodingKey {

        case totalEarning = "totalEarning"
        case content = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalEarning = try values.decodeIfPresent(String.self, forKey: .totalEarning)
        content = try values.decodeIfPresent([IncomeReportYearViseContent].self, forKey: .content)
    }
    
}

struct IncomeReportYearViseContent : Codable {
    let year : String?
    let incomeReport : [IncomeReportContentApiResponse]?

    enum CodingKeys: String, CodingKey {

        case year = "year"
        case incomeReport = "incomeReport"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        year = try values.decodeIfPresent(String.self, forKey: .year)
        incomeReport = try values.decodeIfPresent([IncomeReportContentApiResponse].self, forKey: .incomeReport)
    }

}

struct IncomeReportContentApiResponse : Codable {
    let id : String?
    let orderAmt : String?
    let orderCount : String?
    let date : String?
    let year : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case orderAmt = "orderAmt"
        case orderCount = "orderCount"
        case date = "date"
        case year = "year"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        orderAmt = try values.decodeIfPresent(String.self, forKey: .orderAmt)
        orderCount = try values.decodeIfPresent(String.self, forKey: .orderCount)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        year = try values.decodeIfPresent(String.self, forKey: .year)
    }
}

struct OrderFeedBackApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : OrderFeedBackDataApiResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(OrderFeedBackDataApiResponse.self, forKey: .data)
    }
    
}
struct OrderFeedBackDataApiResponse : Codable {
    let totalPage : Int?
    let content : [OrderFeedBackContentApiResponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalPage = "totalPage"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        content = try values.decodeIfPresent([OrderFeedBackContentApiResponse].self, forKey: .content)
    }
    
}
struct OrderFeedBackContentApiResponse : Codable {
    let orderId : String?
    let customerName : String?
    let orderNumber : String?
    let orderStatus : String?
    let rating : String?
    let date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case customerName = "customerName"
        case orderNumber = "orderNumber"
        case orderStatus = "orderStatus"
        case rating = "rating"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        orderNumber = try values.decodeIfPresent(String.self, forKey: .orderNumber)
        orderStatus = try values.decodeIfPresent(String.self, forKey: .orderStatus)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        date = try values.decodeIfPresent(String.self, forKey: .date)
    }
    
}

