//
//  Enums.swift
//  My Pharmacy
//
//  Created by iOS Dev on 31/12/20.
//  Copyright © 2020 iOS Dev. All rights reserved.
//

import UIKit

enum AppMode {
    case development
    case production
    case productionAndLogs
}

enum ScreenType {
    case login
    case resetPassword
    case changePassword
    case deliveryCharge
    case callHistory
    case upcomingOrder
    case notification
    case acceptOrder
    case outForDelivery
    case completeOrder
    case returnOrderPaid
    case returnOrderFree
    case cancelOrder
    case rejectedOrder
    case assignOrder
    case reassignOrder
}

enum OrderStatus: String {
    
    case upcoming
    case accepted
    case readyforpickup
    case outfordelivery
    case completed
    case rejected
    case cancelled
    case returned
    
    var serverString: String {
        switch self {
            case .upcoming:
                return "new"
            case .accepted:
                return "accept"
            case .readyforpickup:
                return "assign"
            case .outfordelivery:
                return "pickup"
            case .completed:
                return "complete"
            case .rejected:
                return "reject"
            case .cancelled:
                return "cancel"
            case .returned:
                return "incomplete"
        }
    }
    
    var displayString: String {
        switch self {
            case .upcoming:
                return "Upcoming"
            case .accepted:
                return "Accepted"
            case .readyforpickup:
                return "Ready for pickup"
            case .outfordelivery:
                return "Out for delivery"
            case .completed:
                return "Completed"
            case .rejected:
                return "Rejected"
            case .cancelled:
                return "Cancelled"
            case .returned:
                return "Return"
        }
    }
    
}

enum DeliveryType: String {
    
    case internald
    case external
    case both

    var serverString: String {
        switch self {
            case .internald:
                return "internal"
            case .external:
                return "external"
            case .both:
                return "both"
        }
    }
    
    var displayString: String {
        switch self {
            case .internald:
                return "Internal"
            case .external:
                return "Logistic"
            case .both:
                return ""
        }
    }
    
}

enum OrderTypes {
    case asPerPrescription
    case fullOrder(String)
    case selectedItem
    case manualOrder
    
    var detailDisplayString: String {
        get {
            switch self {
                case .asPerPrescription,
                        .fullOrder(_),
                        .selectedItem :
                    
                    return "Prescription"
                    
                case .manualOrder:
                    
                    return "Manual"
            }
        }
    }
    
    var appDisplayString: String {
        get {
            switch self {
                case .asPerPrescription:
                    return "As per prescription"
                case .fullOrder(let days):
                    return "Full order for \(days) days"
                case .selectedItem:
                    return "Selected items"
                case .manualOrder:
                    return "Manual Order"
            }
        }
    }
    
    var serverString: String {
        get {
            switch self {
                case .asPerPrescription:
                    return "as_per_prescription"
                case .fullOrder(_):
                    return "full_order"
                case .selectedItem:
                    return "selected_item"
                case .manualOrder:
                    return "manual_order"
            }
        }
    }
    
}

enum ExternalDeliveryInitiateBy: String {
    case customer
    case pharmacy
    case seller
}

enum UserType: String {
    case seller
    case deliveryBoy
    case pharmacy
    
    var serverString: String {
        
        switch self {
            case .seller:
                return "seller"
            case .deliveryBoy:
                return "delivery_boy"
            case .pharmacy:
                return "pharmacy"
        }
    }
}
