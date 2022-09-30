//
//  DataManager.swift
//  Crypto-Currencies
//

import UIKit
import RealmSwift
import CryptoAPI

class DataManager: NSObject {
    
    static let shared = DataManager()
    
    // MARK: - Save
    func saveCoins(coins: [Coin]) {
        do {
            let realm = try Realm()
            let currency = realm.objects(Currency.self)
            
            if currency.isEmpty {
                coins.forEach { coin in
                    let currency = Currency()
                    currency.code = coin.code
                    currency.price = coin.price
                    currency.date = Date()
                    
                    try! realm.write {
                        realm.add(currency)
                    }
                }
            } else {
                saveOrUpdatePrice(coins: coins)
            }
        }catch {}
    }
    
    // MARK: - UpdatePrice
    func saveOrUpdatePrice(coins: [Coin]) {
        coins.forEach { coin in
            
            
            var newPriceHasFound = false
            do {
                let realm = try Realm()
                let currencies = realm.objects(Currency.self).filter("code contains '\(coin.code)' AND price == %@", coin.price)
                
                newPriceHasFound = currencies.isEmpty
                
                if newPriceHasFound {
                    let currency = Currency()
                    currency.code = coin.code
                    currency.price = coin.price
                    currency.date = Date()
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(currency)
                    }
                }
            } catch {}
            
            
        }
    }
    
    // MARK: - Min price
    func findMinPrice(_ coin: Coin) -> String {
        do {
            let realm = try Realm()
            let currencies = realm.objects(Currency.self).filter("code contains '\(coin.code)'")
            
            if currencies.count > 1 {
                let minCurrency =  currencies.sorted(by: { $0.price < $1.price}).first
                return "$ " + String(format: "%.6f", minCurrency?.price ?? 0 )
            }
            
           return ""
        }catch {}
        return ""
    }
    
    // MARK: - Max price
    func findMaxPrice(_ coin: Coin) -> String {
        do {
            let realm = try Realm()
            let currencies = realm.objects(Currency.self).filter("code contains '\(coin.code)'")
            
            if currencies.count > 1 {
                let minCurrency =  currencies.sorted(by: { $0.price > $1.price}).first
                return "$ " + String(format: "%.6f",minCurrency?.price ?? 0)
            }
            
           return ""
        }catch {}
        return ""
    }
    
    // MARK: - Last price
    func getLastPriceBy(_ code: String) -> Double {
        do {
            let realm = try Realm()
            let currencies = realm.objects(Currency.self).filter("code contains '\(code)'")
            
            return currencies.last?.price ?? 0
            
        }catch {}
        return 0
    }
    
    // MARK: - Filter by code
    func getCurrenciesBy(_ code: String) -> [Currency] {
        do {
            let realm = try Realm()
            let currencies = realm.objects(Currency.self).filter("code contains '\(code)'")
            
            return Array(currencies)
            
        }catch {}
        
        return []
    }
}
