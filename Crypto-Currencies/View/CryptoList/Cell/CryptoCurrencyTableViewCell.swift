//
//  CryptoCurrencyTableViewCell.swift
//  Crypto-Currencies
//

import UIKit
import Kingfisher
import CryptoAPI
import RealmSwift

public let UpdateCellPrice = Notification.Name("UpdateCellPrice")

class CryptoCurrencyTableViewCell: UITableViewCell {
  static let identifier = "CryptoCurrencyTableViewCell"
    
    var lastPrice: Double = 0
    
    var coin: Coin!
    
    // MARK: - Properties
    private let icon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private let nameCurrency: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    private let codeCurrencyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        return label
    }()
    
    private let minLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.text = "min:"
        label.font = .systemFont(ofSize: 8)
        return label
    }()
    
    private let minPriceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "$ 81.5343243243"
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let maxLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 8)
        label.text = "max:"
        return label
    }()
    
    private let maxPriceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "$ 81.53"
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let priceHolderView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.rounded(cornerRadius: 4)
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        selectionStyle = .none
        addSubviews()
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(_:)), name: UpdateCellPrice, object: nil)
    }
    
    // MARK: - Setup
    func setup(_ coin: Coin){
        let url = URL(string: coin.imageUrl ?? "")
        self.coin = coin
        icon.kf.setImage(with: url)
        nameCurrency.text = coin.name
        codeCurrencyLabel.text = coin.code
        priceLabel.text = "$ " + String(format: "%.6f", DataManager.shared.getLastPriceBy(coin.code))
        minPriceLabel.text = DataManager.shared.findMinPrice(coin)
        maxPriceLabel.text = DataManager.shared.findMaxPrice(coin)
    }
    
    // MARK: - Update Cell
    @objc func didUpdate(_ notification: Notification) {
         guard let object = notification.userInfo, let coin = object["coin"] as? Coin  else { return }
         
        if coin.code != self.coin.code {
            return
        }
         self.priceLabel.text = "$ " + String(format: "%.6f", coin.price)
         self.priceHolderView.alpha = 1.0
         self.priceLabel.textColor = .white
         UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
             self.priceHolderView.alpha = 0.0
             
         }, completion: {_ in
             self.priceLabel.textColor = .black
         })
         
             if self.lastPrice > coin.price {
                 self.priceHolderView.backgroundColor = UIColor.init(red: 106.0/255.0, green: 170/255.0, blue: 62/255.0, alpha: 1.0)
             }else if self.lastPrice < coin.price {
                 self.priceHolderView.backgroundColor =  UIColor.init(red: 170/255, green: 28/255, blue: 46/255, alpha: 1.0)
             }else {
                 self.priceHolderView.backgroundColor = .clear
             }
         
         lastPrice = coin.price
         minPriceLabel.text = DataManager.shared.findMinPrice(coin)
         maxPriceLabel.text = DataManager.shared.findMaxPrice(coin)
     }
}

// MARK: - Add Subviews
extension CryptoCurrencyTableViewCell {
    private func addSubviews() {
        let views = [icon, nameCurrency, codeCurrencyLabel, minLabel, minPriceLabel, maxLabel, maxPriceLabel, priceHolderView, priceLabel, separatorView]
        
        views.forEach { view in
            self.addSubview(view)
        }
    }
}

// MARK: - Setup Constraints
extension CryptoCurrencyTableViewCell {
    private func setupConstraints() {
        icon.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(20)
            make.height.width.equalTo(50)
        }
        
        nameCurrency.snp.makeConstraints { make in
            make.centerY.equalTo(icon)
            make.left.equalTo(icon.snp.right).offset(10)
        }
        
        codeCurrencyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon)
            make.left.equalTo(nameCurrency.snp.right).offset(10)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon)
            make.right.equalTo(self).offset(-20)
        }
        
        priceHolderView.snp.makeConstraints { make in
            make.top.left.equalTo(priceLabel).offset(-10)
            make.bottom.right.equalTo(priceLabel).offset(10)
        }
        
        minLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(10)
            make.bottom.equalTo(self).offset(-20)
        }
        
        minPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(minLabel.snp.right).offset(3)
            make.centerY.equalTo(minLabel)
        }
        
        maxLabel.snp.makeConstraints { make in
            make.centerY.equalTo(minLabel)
            make.left.equalTo(minPriceLabel.snp.right).offset(20)
        }
        
        maxPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(maxLabel.snp.right).offset(3)
            make.centerY.equalTo(maxLabel)
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self)
        }
    }
}
