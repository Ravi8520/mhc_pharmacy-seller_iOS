import Foundation

struct ManualOrderDetailsApiResponse : Codable {
    let status : Int?
    let message : String?
    let data : [ManualOrderDetailDataApiResponse]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([ManualOrderDetailDataApiResponse].self, forKey: .data)
    }

}

struct ManualOrderDetailDataApiResponse : Codable {
    let order_id : Int?
    let order_number : String?
    let name : String?
    let address : String?
    let ordertime : [Ordertime]?
    let order_amount : Int?
    let mobile_number : String?

    enum CodingKeys: String, CodingKey {

        case order_id = "order_id"
        case order_number = "order_number"
        case name = "name"
        case address = "address"
        case ordertime = "ordertime"
        case order_amount = "order_amount"
        case mobile_number = "mobile_number"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        order_number = try values.decodeIfPresent(String.self, forKey: .order_number)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        ordertime = try values.decodeIfPresent([Ordertime].self, forKey: .ordertime)
        order_amount = try values.decodeIfPresent(Int.self, forKey: .order_amount)
        mobile_number = try values.decodeIfPresent(String.self, forKey: .mobile_number)
    }

}
struct Ordertime : Codable {
    let slug : String?
    let title : String?
    let date : String?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case title = "title"
        case date = "date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        date = try values.decodeIfPresent(String.self, forKey: .date)
    }

}

struct OrderDetailApiResponse : Codable {
	let status : Int?
	let message : String?
	let data : [OrderDetailDataApiResponse]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case message = "message"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		data = try values.decodeIfPresent([OrderDetailDataApiResponse].self, forKey: .data)
	}

}
struct OrderDetailDataApiResponse : Codable {
    let order_id : String?
    let order_number : String?
    let prescription_image : [OrderDetailPrescriptionImageApiResponse]?
    let manual_order : [OrderDetailManualOrderApiResponse]?
    let invoice : [OrderDetailImagesApiResponse]?
    let rating : String?
    let order_note : String?
    let order_type : String?
    let total_days : String?
    let reminder_days : String?
    let customer_name : String?
    let mobile_number : String?
    let location : OrderDetailLocationApiResponse?
    let order_assign_to : String?
    let deliver_to : String?
    let accept_date : String?
    let prescription_name : String?
    let deliver_date : String?
    let assign_date : String?
    let cancel_reason : String?
    let return_reason : String?
    let reject_reason : String?
    let return_date : String?
    
    let return_confirm_date : String?
    let return_confirm_type : String?
    let return_confirm_name : String?
    
    let order_amount : String?
    let delivery_type : String?
    let pickup_images : [OrderDetailImagesApiResponse]?
    let pickup_date : String?
    let drop_images : [OrderDetailImagesApiResponse]?
    let drop_date : String?
    let reject_date : String?
    let cancel_date : String?
    let received_date : String?
    let order_status : String?
    let external_delivery_initiatedby : String?
    let order_time : String?
    let leaveWithNeighbour : String?
    let payment_details : payment_detailsResponce?
    
    enum CodingKeys: String, CodingKey {
        
        case order_id = "order_id"
        case order_number = "order_number"
        case prescription_image = "prescription_image"
        case manual_order = "manual_order"
        case invoice = "invoice"
        case rating = "rating"
        case order_note = "order_note"
        case order_type = "order_type"
        case total_days = "total_days"
        case reminder_days = "reminder_days"
        case customer_name = "customer_name"
        case mobile_number = "mobile_number"
        case location = "locaton"
        case order_assign_to = "order_assign_to"
        case deliver_to = "deliver_to"
        case accept_date = "accept_date"
        case prescription_name = "prescription_name"
        case deliver_date = "deliver_date"
        case assign_date = "assign_date"
        case cancel_reason = "cancel_reason"
        case return_reason = "return_reason"
        case reject_reason = "reject_reason"
        case return_date = "return_date"
        
        case return_confirm_date = "return_confirm_date"
        case return_confirm_type = "return_confirm_type"
        case return_confirm_name = "return_confirm_name"
        
        case order_amount = "order_amount"
        case delivery_type = "delivery_type"
        case pickup_images = "pickup_images"
        case pickup_date = "pickup_date"
        case drop_images = "drop_images"
        case drop_date = "drop_date"
        case reject_date = "reject_date"
        case cancel_date = "cancel_date"
        case received_date = "received_date"
        case order_status = "order_status"
        case external_delivery_initiatedby = "external_delivery_initiatedby"
        case order_time = "order_time"
        case leaveWithNeighbour = "leaveWithNeighbour"
        case payment_details = "payment_details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        order_number = try values.decodeIfPresent(String.self, forKey: .order_number)
        prescription_image = try values.decodeIfPresent([OrderDetailPrescriptionImageApiResponse].self, forKey: .prescription_image)
        manual_order = try values.decodeIfPresent([OrderDetailManualOrderApiResponse].self, forKey: .manual_order)
        invoice = try values.decodeIfPresent([OrderDetailImagesApiResponse].self, forKey: .invoice)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        order_note = try values.decodeIfPresent(String.self, forKey: .order_note)
        order_type = try values.decodeIfPresent(String.self, forKey: .order_type)
        total_days = try values.decodeIfPresent(String.self, forKey: .total_days)
        reminder_days = try values.decodeIfPresent(String.self, forKey: .reminder_days)
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        mobile_number = try values.decodeIfPresent(String.self, forKey: .mobile_number)
        location = try values.decodeIfPresent(OrderDetailLocationApiResponse.self, forKey: .location)
        order_assign_to = try values.decodeIfPresent(String.self, forKey: .order_assign_to)
        deliver_to = try values.decodeIfPresent(String.self, forKey: .deliver_to)
        accept_date = try values.decodeIfPresent(String.self, forKey: .accept_date)
        deliver_date = try values.decodeIfPresent(String.self, forKey: .deliver_date)
        assign_date = try values.decodeIfPresent(String.self, forKey: .assign_date)
        cancel_reason = try values.decodeIfPresent(String.self, forKey: .cancel_reason)
        return_reason = try values.decodeIfPresent(String.self, forKey: .return_reason)
        reject_reason = try values.decodeIfPresent(String.self, forKey: .reject_reason)
        return_date = try values.decodeIfPresent(String.self, forKey: .return_date)
        return_confirm_type = try values.decodeIfPresent(String.self, forKey: .return_confirm_type)
        return_confirm_name = try values.decodeIfPresent(String.self, forKey: .return_confirm_name)
        return_confirm_date = try values.decodeIfPresent(String.self, forKey: .return_confirm_date)
        order_amount = try values.decodeIfPresent(String.self, forKey: .order_amount)
        delivery_type = try values.decodeIfPresent(String.self, forKey: .delivery_type)
        prescription_name = try values.decodeIfPresent(String.self, forKey: .prescription_name)
        pickup_images = try values.decodeIfPresent([OrderDetailImagesApiResponse].self, forKey: .pickup_images)
        pickup_date = try values.decodeIfPresent(String.self, forKey: .pickup_date)
        drop_images = try values.decodeIfPresent([OrderDetailImagesApiResponse].self, forKey: .drop_images)
        drop_date = try values.decodeIfPresent(String.self, forKey: .drop_date)
        reject_date = try values.decodeIfPresent(String.self, forKey: .reject_date)
        cancel_date = try values.decodeIfPresent(String.self, forKey: .cancel_date)
        received_date = try values.decodeIfPresent(String.self, forKey: .received_date)
        order_status = try values.decodeIfPresent(String.self, forKey: .order_status)
        external_delivery_initiatedby = try values.decodeIfPresent(String.self, forKey: .external_delivery_initiatedby)
        order_time = try values.decodeIfPresent(String.self, forKey: .order_time)
        leaveWithNeighbour = try values.decodeIfPresent(String.self, forKey: .leaveWithNeighbour)
        payment_details = try values.decodeIfPresent(payment_detailsResponce.self, forKey:.payment_details)
    }
}

struct payment_detailsResponce : Codable {
    let date : String?
    let reference_no : String?
    let amount : String?
    
    enum CodingKeys: String, CodingKey {
        
        case date = "date"
        case reference_no = "reference_no"
        case amount = "amount"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        reference_no = try values.decodeIfPresent(String.self, forKey: .reference_no)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
    }
    
}

struct OrderDetailPrescriptionImageApiResponse : Codable {
    let id : Int?
    let image : String?
    let mimetype : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case image = "image"
        case mimetype = "mimetype"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        mimetype = try values.decodeIfPresent(String.self, forKey: .mimetype)
    }
    
}
struct OrderDetailManualOrderApiResponse : Codable {
    let id : Int?
    let order_id : Int?
    let category_id : String?
    let category_name : String?
    let company_name : String?
    let product : String?
    let qty : Int?
    let type : String?
    let image : String?
    let date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case order_id = "order_id"
        case category_id = "category_id"
        case category_name = "category_name"
        case company_name = "company_name"
        case product = "product"
        case qty = "qty"
        case type = "type"
        case image = "image"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
        category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
        company_name = try values.decodeIfPresent(String.self, forKey: .company_name)
        product = try values.decodeIfPresent(String.self, forKey: .product)
        qty = try values.decodeIfPresent(Int.self, forKey: .qty)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        date = try values.decodeIfPresent(String.self, forKey: .date)
    }
    
}
struct OrderDetailLocationApiResponse : Codable {
    let address_id : Int?
    let user_id : Int?
    let locality : String?
    let address : String?
    let name : String?
    let mobileno : String?
    let blockno : String?
    let streetname : String?
    let city : String?
    let pincode : String?
    let latitude : Double?
    let longitude : Double?
    let landmark : String?
    
    enum CodingKeys: String, CodingKey {
        
        case address_id = "address_id"
        case user_id = "user_id"
        case locality = "locality"
        case address = "address"
        case name = "name"
        case mobileno = "mobileno"
        case blockno = "blockno"
        case streetname = "streetname"
        case city = "city"
        case pincode = "pincode"
        case latitude = "latitude"
        case longitude = "longitude"
        case landmark = "landmark"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address_id = try values.decodeIfPresent(Int.self, forKey: .address_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        locality = try values.decodeIfPresent(String.self, forKey: .locality)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        mobileno = try values.decodeIfPresent(String.self, forKey: .mobileno)
        blockno = try values.decodeIfPresent(String.self, forKey: .blockno)
        streetname = try values.decodeIfPresent(String.self, forKey: .streetname)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        pincode = try values.decodeIfPresent(String.self, forKey: .pincode)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        landmark = try values.decodeIfPresent(String.self, forKey: .landmark)
    }
    
}
struct OrderDetailImagesApiResponse : Codable {
    let id : Int?
    let image : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case image = "image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }
    
}

struct DashBoardSearchApiReponse : Codable {
    let status : Int?
    let message : String?
    let data : [DashBoardSearchDataApiReponse]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([DashBoardSearchDataApiReponse].self, forKey: .data)
    }
    
}
struct DashBoardSearchDataApiReponse : Codable {
    
    let orderId : Int?
    let orderno : String?
    let customerName : String?
    let orderStatus : String?
    let receiveTime : String?
    let assignTime : String?
    let pickupTime : String?
    let deliveryboyname : String?
    let deliveredTime : String?
    let rating : String?
    let returnTime : String?
    let returnConfirmTime : String?
    let cancelledReason : String?
    let rejectedReason : String?
    let is_external_delivery : Int?
    let isLogisticDelivery : String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId = "orderId"
        case orderno = "orderno"
        case customerName = "customerName"
        case orderStatus = "orderStatus"
        case receiveTime = "receiveTime"
        case assignTime = "assignTime"
        case pickupTime = "pickupTime"
        case deliveryboyname = "deliveryboyname"
        case deliveredTime = "deliveredTime"
        case rating = "rating"
        case returnTime = "returnTime"
        case returnConfirmTime = "returnConfirmTime"
        case cancelledReason = "cancelledReason"
        case rejectedReason = "rejectedReason"
        case is_external_delivery = "is_external_delivery"
        case isLogisticDelivery = "isLogisticDelivery"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(Int.self, forKey: .orderId)
        orderno = try values.decodeIfPresent(String.self, forKey: .orderno)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        orderStatus = try values.decodeIfPresent(String.self, forKey: .orderStatus)
        receiveTime = try values.decodeIfPresent(String.self, forKey: .receiveTime)
        assignTime = try values.decodeIfPresent(String.self, forKey: .assignTime)
        pickupTime = try values.decodeIfPresent(String.self, forKey: .pickupTime)
        deliveryboyname = try values.decodeIfPresent(String.self, forKey: .deliveryboyname)
        deliveredTime = try values.decodeIfPresent(String.self, forKey: .deliveredTime)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        returnTime = try values.decodeIfPresent(String.self, forKey: .returnTime)
        returnConfirmTime = try values.decodeIfPresent(String.self, forKey: .returnConfirmTime)
        cancelledReason = try values.decodeIfPresent(String.self, forKey: .cancelledReason)
        rejectedReason = try values.decodeIfPresent(String.self, forKey: .rejectedReason)
        is_external_delivery = try values.decodeIfPresent(Int.self, forKey: .is_external_delivery)
        isLogisticDelivery = try values.decodeIfPresent(String.self, forKey: .isLogisticDelivery)
    }
    
}
