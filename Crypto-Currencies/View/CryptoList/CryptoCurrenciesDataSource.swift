//
//  CryptoCurrenciesDataSource.swift
//  Crypto-Currencies
//

import UIKit
import CryptoAPI

final class CryptoCurrenciesDataSource: NSObject {
    private var currencies: [Coin]
    private var coin: Coin?
    private var viewController: UIViewController
    
    private let cellHeight = 130.0
    
    init(currencies: [Coin], viewController: UIViewController) {
        self.currencies = currencies
        self.viewController = viewController
    }
}

extension CryptoCurrenciesDataSource: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCurrencyTableViewCell.identifier, for: indexPath) as? CryptoCurrencyTableViewCell else { return UITableViewCell() }
        let coin = currencies[indexPath.row]
        cell.setup(coin)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = currencies[indexPath.row]
        let detailVC = DetailCryptoViewController(coin: coin)
        self.viewController.present(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}
