//
//  LedgerStatementAPIModel.swift
//  My Health Chart-Pharmacy
//
//  Created by Miral vadher on 27/05/22.
//

import Foundation

struct LdgerStatementApiMOdel : Codable {
    let status : Int?
    let message : String?
    let total_amount :String?
    let num_of_order :String?
    let totalPage : Int?
    let data : [UnpidlDataApiResponse]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case total_amount = "total_amount"
        case num_of_order = "num_of_order"
        case totalPage = "totalPage"
        case data = "data"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        num_of_order = try values.decodeIfPresent(String.self, forKey: .num_of_order)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        data = try values.decodeIfPresent([UnpidlDataApiResponse].self, forKey: .data)
    }

}

struct UnpidlDataApiResponse : Codable {
    let order_id : String?
    let order_number : String?
    let customer_name : String?
    let deliver_datetime : String?
    let order_amount : String?

    enum CodingKeys: String, CodingKey {

        case order_id = "order_id"
        case order_number = "order_number"
        case customer_name = "customer_name"
        case deliver_datetime = "deliver_datetime"
        case order_amount = "order_amount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        order_number = try values.decodeIfPresent(String.self, forKey: .order_number)
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        deliver_datetime = try values.decodeIfPresent(String.self, forKey: .deliver_datetime)
        order_amount = try values.decodeIfPresent(String.self, forKey: .order_amount)
    }

}
