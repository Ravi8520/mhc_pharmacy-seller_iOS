//
//  PaidDataModel.swift
//  My Health Chart-Pharmacy
//
//  Created by Miral vadher on 27/05/22.
//

import Foundation
struct PaidOrderAPIResponse : Codable {
    let status : Int?
    let message : String?
    
    let data : [paidDataList]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([paidDataList].self, forKey: .data)
    }

}
struct paidDataList : Codable {
    let payment_date : String?
    let transaction_no : String?
    let total_amount : String?
    let order_data : [OrderData]?

    enum CodingKeys: String, CodingKey {

        case payment_date = "payment_date"
        case transaction_no = "transaction_no"
        case total_amount = "total_amount"
        case order_data = "order_data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        payment_date = try values.decodeIfPresent(String.self, forKey: .payment_date)
        transaction_no = try values.decodeIfPresent(String.self, forKey: .transaction_no)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        order_data = try values.decodeIfPresent([OrderData].self, forKey: .order_data)
        
    }

}
struct OrderData : Codable {
    let transaction_no : String?
    let order_id : String?
    let order_number : String?
    let deliver_datetime : String?
    let order_amount : String?
    let customer_name : String?
    let delivery_boy : String?
    let rating : String?

    enum CodingKeys: String, CodingKey {

        
        case transaction_no = "transaction_no"
        case order_id = "order_id"
        case order_number = "order_number"
        case deliver_datetime = "deliver_datetime"
        case order_amount = "order_amount"
        case customer_name = "customer_name"
        case delivery_boy = "delivery_boy"
        case rating = "rating"
        
       
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transaction_no = try values.decodeIfPresent(String.self, forKey: .transaction_no)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        order_number = try values.decodeIfPresent(String.self, forKey: .order_number)
        deliver_datetime = try values.decodeIfPresent(String.self, forKey: .deliver_datetime)
        order_amount = try values.decodeIfPresent(String.self, forKey: .order_amount)
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        delivery_boy = try values.decodeIfPresent(String.self, forKey: .delivery_boy)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        
    }

}
