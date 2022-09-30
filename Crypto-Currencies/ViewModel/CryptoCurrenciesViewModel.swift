//
//  CryptoCurrenciesViewModel.swift
//  Crypto-Currencies
//

import Foundation
import CryptoAPI

class CryptoCurrenciesViewModel {
    
    func saveCurrency(coins: [Coin]) {
        let currencies = DataManager.shared.getAllCurrencyies()
            coins.forEach { coin in
                if DataManager.shared.checkForNewPriceHasFound(coin: coin) {
                    DataManager.shared.saveCurrency(coin: coin)
                }
            }
    }
    
}
