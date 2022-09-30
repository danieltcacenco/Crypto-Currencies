//
//  CryptoCurrencyViewController.swift
//  Crypto-Currencies
//

import UIKit
import CryptoAPI
import RealmSwift
import SnapKit

final class CryptoCurrencyViewController: UIViewController {
    // MARK - Parameters
    private var crypto: Crypto!
    private var dataSource: CryptoCurrenciesDataSource!
    private var viewModel = CryptoCurrenciesViewModel()
    
    // MARK: - Properties
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    
    // MARK: - Setup View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
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
        viewModel.saveCurrency(coins: coins)
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
            self.viewModel.saveCurrency(coins: [coin])
            NotificationCenter.default.post(name: UpdateCellPrice, object: nil, userInfo: ["coin" : coin])
        }
    }
    
    func cryptoAPIDidDisconnect() {
        
    }
}
