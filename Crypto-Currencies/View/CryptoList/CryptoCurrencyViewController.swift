//
//  CryptoCurrencyViewController.swift
//  Crypto-Currencies
//

import UIKit
import CryptoAPI
import RealmSwift
import SnapKit

class CryptoCurrencyViewController: UIViewController {
    var crypto: Crypto!
    var dataSource: CryptoCurrenciesDataSource!
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    // MARK: - Setup View
    private func setupView() {
        
        self.view.backgroundColor = .white
        setupNavigationBar()
        
        setupCryptoApi()
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        setupTablewView()
    }
    
    private func setupCryptoApi() {
        crypto = Crypto(delegate: self)
        let _ = crypto.connect()
        
        let coins = crypto.getAllCoins()
        DataManager.shared.saveCoins(coins: coins)
    }
    
    private func setupNavigationBar() {
        self.title = "Market"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTablewView() {
        dataSource = CryptoCurrenciesDataSource(currencies: crypto.getAllCoins(), viewController: self)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.separatorStyle = .none
        tableView.register(CryptoCurrencyTableViewCell.self, forCellReuseIdentifier: CryptoCurrencyTableViewCell.identifier)
        tableView.reloadData()
    }
}

// MARK: CryptoDelegate
extension CryptoCurrencyViewController: CryptoDelegate {
    
    func cryptoAPIDidConnect() {
        
    }
    
    func cryptoAPIDidUpdateCoin(_ coin: CryptoAPI.Coin) {
        DispatchQueue.main.async {
        DataManager.shared.saveOrUpdatePrice(coins: [coin])
        NotificationCenter.default.post(name: UpdateCellPrice, object: nil, userInfo: ["coin" : coin])
        }
    }
    
    func cryptoAPIDidDisconnect() {
        
    }
}
