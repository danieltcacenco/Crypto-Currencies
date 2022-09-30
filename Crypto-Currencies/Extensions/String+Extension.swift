//
//  String+Extension.swift
//  Crypto-Currencies
//

import Foundation

extension String {
    static func formatNumberWithDolar(number: Double?) -> String{
        return "$ " + String(format: "%.6f", number ?? 0 )
    }
}
