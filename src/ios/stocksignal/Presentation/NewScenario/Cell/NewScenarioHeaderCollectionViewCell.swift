//
//  NewScenarioHeaderCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/10/24.
//

import Foundation
import UIKit

final class NewScenarioHeaderCollectionViewCell: UICollectionViewCell {
    static let id = "NewScenarioHeaderCollectionViewCell"
    
    private let TitleTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "종목명"
        return label
    } ()
    
    private let PriceTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "현재가"
        return label
    } ()
    
    private let QuantityTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "거래량"
        return label
    } ()
    
    private let TitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(1)
        label.text = ""
        return label
    } ()
    
    private let PriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(1)
        label.text = ""
        return label
    } ()
    
    private let QuantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(1)
        label.text = ""
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        
        self.addSubview(TitleTextLabel)
        self.addSubview(PriceTextLabel)
        self.addSubview(QuantityTextLabel)
        self.addSubview(TitleLabel)
        self.addSubview(PriceLabel)
        self.addSubview(QuantityLabel)
        
        TitleTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(30)
        }
        
        PriceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(TitleTextLabel)
            make.centerX.equalToSuperview()
        }
        
        QuantityTextLabel.snp.makeConstraints { make in
            make.top.equalTo(TitleTextLabel)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        TitleLabel.snp.makeConstraints { make in
            make.top.equalTo(TitleTextLabel.snp.bottom).offset(5)
            make.leading.equalTo(TitleTextLabel)
        }
        
        PriceLabel.snp.makeConstraints { make in
            make.top.equalTo(TitleLabel)
            make.leading.equalTo(PriceTextLabel)
        }
        
        QuantityLabel.snp.makeConstraints { make in
            make.top.equalTo(TitleLabel)
            make.leading.equalTo(QuantityTextLabel)
        }
    }
    
    public func configure(stockName: String, currentPrice: Int, quantity: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
    
        TitleLabel.text = stockName
        PriceLabel.text = (formatter.string(from: NSNumber(value: currentPrice)) ?? "0") + "원"
        QuantityLabel.text = (formatter.string(from: NSNumber(value: quantity)) ?? "0") + "주"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
