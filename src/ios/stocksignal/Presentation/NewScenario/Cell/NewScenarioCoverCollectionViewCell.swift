//
//  NewScenarioCoverUICollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 10/31/24.
//

import Foundation
import UIKit

final class NewScenarioCoverCollectionViewCell: UICollectionViewCell {
    static let id = "NewScenarioCoverCollectionViewCell"
    
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    let conditionDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("조건 삭제", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        return button
    } ()
    
    let conditionLabel1: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    let conditionLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .customBlue
        return label
    } ()
    
    let conditionLabel3: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    let conditionLabel4: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    let conditionLabel5: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    let additionalLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .customRed
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .background
        
        self.addSubview(conditionLabel)
        self.addSubview(conditionDeleteButton)
        self.addSubview(conditionLabel1)
        self.addSubview(conditionLabel2)
        self.addSubview(conditionLabel3)
        self.addSubview(conditionLabel4)
        self.addSubview(conditionLabel5)
        self.addSubview(additionalLabel)
        
        conditionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(10)
        }
        
        conditionDeleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        conditionLabel1.snp.makeConstraints { make in
            make.top.equalTo(conditionLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        conditionLabel2.snp.makeConstraints { make in
            make.top.equalTo(conditionLabel1.snp.top)
            make.leading.equalTo(conditionLabel1.snp.trailing).offset(10)
        }
        
        conditionLabel3.snp.makeConstraints { make in
            make.top.equalTo(conditionLabel1.snp.top)
            make.leading.equalTo(conditionLabel2.snp.trailing).offset(10)
        }
        
        conditionLabel4.snp.makeConstraints { make in
            make.top.equalTo(conditionLabel1.snp.top)
            make.leading.equalTo(conditionLabel3.snp.trailing).offset(10)
        }
        
        conditionLabel5.snp.makeConstraints { make in
            make.top.equalTo(conditionLabel1.snp.top)
            make.leading.equalTo(conditionLabel4.snp.trailing).offset(10)
        }
    }
    
    public func configure(item: Condition)
    {
        
        conditionLabel.text = item.buysellType
        
        switch item.methodType {
        case "RATE":
            if (item.targetPrice2 == 0)
            {
                conditionLabel1.text = "상승률"
                let rate = 0
                conditionLabel2.textColor = .customRed
                conditionLabel2.text = String(Int(0)) + "%"
                conditionLabel3.text = String(item.targetPrice1) + "원 이상일 시"
            }
            else if (item.targetPrice1 == 0)
            {
                conditionLabel1.text = "하락률"
                let rate = 0
                conditionLabel2.text = String(Int(rate)) + "%"
                conditionLabel3.text = String(item.targetPrice2) + "원 이하일 시"
            }
        case "PRICE":
            if (item.targetPrice2 == 0)
            {
                conditionLabel1.text = "주가가"
                conditionLabel2.textColor = .customRed
                conditionLabel2.text = "상승하여"
                conditionLabel3.text = String(item.targetPrice1) + "원 이상일 시"
            }
            else if (item.targetPrice1 == 0)
            {
                conditionLabel1.text = "주가가"
                conditionLabel2.text = "하락하여"
                conditionLabel3.text = String(item.targetPrice2) + "원 이하일 시"
            }
        case "TRADING":
            if (item.targetPrice2 == 0)
            {
                conditionLabel1.text = "주가가 상승하여"
                conditionLabel2.textColor = .customRed
                conditionLabel2.text = String(item.targetPrice1) + "원 이상이었다가"
                conditionLabel3.text = "하락하여"
                additionalLabel.text = String(item.targetPrice2) + "원 도달 시"
                additionalLabel.textColor = .customBlue
                
                conditionLabel3.snp.remakeConstraints { make in
                    make.trailing.equalTo(conditionLabel1.snp.trailing)
                    make.top.equalTo(conditionLabel1.snp.bottom).offset(15)
                }
                
                additionalLabel.snp.makeConstraints { make in
                    make.centerY.equalTo(conditionLabel3.snp.centerY)
                    make.leading.equalTo(conditionLabel3.snp.trailing).offset(10)
                }
                
                conditionLabel4.snp.remakeConstraints { make in
                    make.centerY.equalTo(conditionLabel3.snp.centerY)
                    make.leading.equalTo(additionalLabel.snp.trailing).offset(10)
                }
                
                conditionLabel5.snp.remakeConstraints { make in
                    make.centerY.equalTo(conditionLabel3.snp.centerY)
                    make.leading.equalTo(conditionLabel4.snp.trailing).offset(10)
                }
                
            }
            else if (item.targetPrice1 == 0)
            {
                conditionLabel1.text = "주가가 하락하여"
                conditionLabel2.text = String(item.targetPrice1) + "원 이하였다가"
                conditionLabel3.text = "상승하여"
                additionalLabel.text = String(item.targetPrice2) + "원 도달 시"
                
                conditionLabel3.snp.remakeConstraints { make in
                    make.trailing.equalTo(conditionLabel1.snp.trailing)
                    make.top.equalTo(conditionLabel1.snp.bottom).offset(15)
                }
                
                additionalLabel.snp.makeConstraints { make in
                    make.centerY.equalTo(conditionLabel3.snp.centerY)
                    make.leading.equalTo(conditionLabel3.snp.trailing).offset(10)
                }
                
                conditionLabel4.snp.remakeConstraints { make in
                    make.centerY.equalTo(conditionLabel3.snp.centerY)
                    make.leading.equalTo(additionalLabel.snp.trailing).offset(10)
                }
                
                conditionLabel5.snp.remakeConstraints { make in
                    make.centerY.equalTo(conditionLabel3.snp.centerY)
                    make.leading.equalTo(conditionLabel4.snp.trailing).offset(10)
                }
            }
        default:
            print("default")
        }
        
        conditionLabel4.text = String(item.quantity) + " 주"
        
        switch item.buysellType {
        case "BUY":
            conditionLabel5.text = "매수"
        case "SELL":
            conditionLabel5.text = "매도"
        default:
            print("default")
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
