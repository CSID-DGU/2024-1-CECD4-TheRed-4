//
//  AutoTradeSelectCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/8/24.
//

import Foundation
import UIKit
import SnapKit

final class AutoTradeSelectCollectionViewCell: UICollectionViewCell {
    static let id = "AutoTradeSelectCollectionViewCell"
    
    private let conditionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "시나리오 이름"
        return label
    } ()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .customBlack
        label.text = ""
        return label
    } ()
    
    private let titleTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "조건"
        return label
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .customBlack
        label.text = ""
        return label
    } ()
    
    private let countTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "수량"
        return label
    } ()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .customBlack
        label.text = ""
        return label
    } ()
    
    private let priceTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "수익률"
        return label
    } ()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .customBlack
        label.text = ""
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 2
        self.layer.borderColor = UIColor.customBlue.cgColor
        self.layer.borderWidth = 1
        
        self.addSubview(conditionTextLabel)
        self.addSubview(priceTextLabel)
        
        self.addSubview(conditionLabel)
        self.addSubview(priceLabel)
        
        conditionTextLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }
        
        priceTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(conditionTextLabel.snp.bottom).offset(10)
            make.leading.equalTo(conditionTextLabel.snp.leading)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTextLabel.snp.bottom).offset(10)
            make.leading.equalTo(priceTextLabel.snp.leading)
        }
    }
    
    public func configure(condition:String, rate:Float) {
        conditionLabel.text = condition
    
        priceLabel.text = String(rate) + "%"
        if (rate > 0) {
            priceLabel.text = "+" + String(rate) + "%"//String(rate) + "%"
            //priceLabel.textColor = .customRed
        }
        else if (rate < 0)
        {
            //priceLabel.textColor = .customBlue
        }
        if (rate == 0)
        {
            self.backgroundColor = .background
            self.layer.borderColor = UIColor.background.cgColor
        }
        priceLabel.text = "+" + String(0) + "%"//String(rate) + "%"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
