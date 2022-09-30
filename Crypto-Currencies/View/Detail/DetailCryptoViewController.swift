//
//  DetailCryptoViewController.swift
//  Crypto-Currencies
//

import UIKit
import Charts
import CryptoAPI

final class DetailCryptoViewController: UIViewController {

    private var coin: Coin
    
    // MARK: - Properties
    private var chartView = CandleStickChartView()
    
    private let icon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    
    // MARK: Init
    init(coin: Coin) {
        self.coin = coin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupView
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        
        let data = CandleChartData(dataSet: prepareCandleCharData())
        chartView.data = data
        let url = URL(string: coin.imageUrl ?? "")
        icon.kf.setImage(with: url)
        nameLabel.text = coin.name
    }
    
    // MARK: - Chart Prepare
    private func prepareCandleCharData() -> CandleChartDataSet {
        let currencies = DataManager.shared.getCurrenciesBy(coin.code)
        let count = currencies.count > 30 ? 30 : currencies.count
        
        let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in
            let mult = 30.0 + 1.0
            let val = Double(currencies[i].price + mult)
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
            let open = Double(arc4random_uniform(6) + 1)
            let close = Double(arc4random_uniform(6) + 1)
            
            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open:val + open , close:  val + close)
        }
        
        let set1 = CandleChartDataSet(entries: yVals1, label: "")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .blue
        set1.decreasingFilled = true
        set1.increasingColor = .blue
        set1.increasingFilled = false
        set1.neutralColor = .blue
        
        return set1
    }
}

// MARK: - Add Subviews
extension DetailCryptoViewController {
    private func addSubviews() {
        let views = [icon, nameLabel, chartView]
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
}

// MARK: - Setup Constraints
extension DetailCryptoViewController {
    private func setupConstraints() {
        icon.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(icon.snp.bottom).offset(10)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
    }
}
