//
//  Currency.swift
//  Crypto-Currencies
//

import Foundation
import RealmSwift

class Currency: Object {
    @Persisted var code: String
    @Persisted var price: Double
    @Persisted var date: Date
}
