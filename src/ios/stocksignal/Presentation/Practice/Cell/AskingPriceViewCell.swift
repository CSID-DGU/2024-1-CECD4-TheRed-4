//
//  AskingPriceViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 11/25/24.
//

import Foundation
import UIKit

class AskingPriceViewCell: UIButton {
    static let id = "AskingPriceViewCell"
    
    let buyLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customRed
        return label
    } ()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack
        return label
    } ()
    
    let sellLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlue
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(buyLabel)
        self.addSubview(priceLabel)
        self.addSubview(sellLabel)
        
        buyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        sellLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalToSuperview()
        }
    }
    
    public func configure(buy:String, price:String, sell:String) {
        buyLabel.text = buy
        priceLabel.text = price
        sellLabel.text = sell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
