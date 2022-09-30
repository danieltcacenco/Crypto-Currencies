//
//  CryptoCurrenciesViewModel.swift
//  Crypto-Currencies
//

import Foundation
import CryptoAPI

final class CryptoCurrenciesViewModel {
    
    func saveCurrency(coins: [Coin]) {
        coins.forEach { coin in
            if DataManager.shared.checkForNewPriceHasFound(coin: coin) {
                DataManager.shared.saveCurrency(coin: coin)
            }
        }
    }
}
