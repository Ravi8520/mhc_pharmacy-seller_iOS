//
//  ArithMeticExtension.swift
//  My Health Chart-Pharmacy
//
//  Created by Freebird App Studio LLP on 15/12/21.
//

import Foundation

protocol NumericType: Comparable {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
    init(_ v: Int)
}

extension Double  : NumericType {}
extension Int     : NumericType {}
extension Float   : NumericType {}
//extension /       : NumericType {}

