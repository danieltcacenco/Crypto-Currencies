//
//  DataManager.swift
//  Crypto-Currencies
//

import UIKit
import RealmSwift
import CryptoAPI

final class DataManager: NSObject {
    
    static let shared = DataManager()
    
    private let realm = try! Realm()
    
    
    func getAllCurrencyies() -> [Currency] {
        let currencies = realm.objects(Currency.self)
        return Array(currencies)
    }
    
    // MARK: - Save
    func saveCurrency(coin: Coin) {
        let currency = Currency()
        currency.code = coin.code
        currency.price = coin.price
        currency.date = Date()
        
        try! realm.write {
            realm.add(currency)
        }
    }
    
    // MARK: - UpdatePrice
    func checkForNewPriceHasFound(coin: Coin) -> Bool{
        var newPriceHasFound = false
        let currencies = realm.objects(Currency.self).filter("code contains '\(coin.code)' AND price == %@", coin.price)
        newPriceHasFound = currencies.isEmpty
        return newPriceHasFound
    }
    
    // MARK: - Min price
    func findMinPrice(_ coin: Coin) -> String {
        let currencies = realm.objects(Currency.self).filter("code contains '\(coin.code)'")
        
        if currencies.count > 1 {
            let minCurrency =  currencies.sorted(by: { $0.price < $1.price}).first
            return String.formatNumberWithDolar(number: minCurrency?.price)
        }
        return ""
    }
    
    // MARK: - Max price
    func findMaxPrice(_ coin: Coin) -> String {
        let currencies = realm.objects(Currency.self).filter("code contains '\(coin.code)'")
        
        if currencies.count > 1 {
            let maxCurrency =  currencies.sorted(by: { $0.price > $1.price}).first
            return String.formatNumberWithDolar(number: maxCurrency?.price)
        }
        
        return ""
    }
    
    // MARK: - Last price
    func getLastPriceBy(_ code: String) -> Double {
        let currencies = realm.objects(Currency.self).filter("code contains '\(code)'")
        return currencies.last?.price ?? 0
    }
    
    // MARK: - Filter by code
    func getCurrenciesBy(_ code: String) -> [Currency] {
        let currencies = realm.objects(Currency.self).filter("code contains '\(code)'")
        return Array(currencies)
    }
}
