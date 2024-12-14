//
//  NewScenarioStandardCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 10/29/24.
//

import Foundation

import Foundation
import UIKit

final class NewScenarioStandardCollectionViewCell: UICollectionViewCell {
    static let id = "NewScenarioStandardCollectionViewCell"
    
    let rateButton: UIButton = {
        let button = UIButton()
        button.setTitle("수익률 기준", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = UIColor.customBlue
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    let priceButton: UIButton = {
        let button = UIButton()
        button.setTitle("목표가 기준", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    let tradingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Trading 매도", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(rateButton)
        self.addSubview(priceButton)
        self.addSubview(tradingButton)
        
        rateButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalToSuperview().dividedBy(3.3)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalTo(priceButton.snp.leading).offset(-10)
        }
        
        priceButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalToSuperview().dividedBy(4)
            make.centerX.equalToSuperview()
        }
        
        tradingButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalToSuperview().dividedBy(4)
            make.leading.equalTo(priceButton.snp.trailing).offset(-10)
            make.trailing.equalToSuperview().offset(-25)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
