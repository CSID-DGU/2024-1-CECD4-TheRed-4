//
//  NewScenarioButtonCollectionViewModel.swift
//  stocksignal
//
//  Created by 신예빈 on 9/10/24.
//

import Foundation
import UIKit

final class NewScenarioButtonCollectionViewCell: UICollectionViewCell {
    static let id = "NewScenarioButtonCollectionViewCell"
    
    let centerView: UIView = {
        let view = UIView()
        return view
    } ()
    
    
    let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("BUY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = UIColor.customBlue
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    let sellButton: UIButton = {
        let button = UIButton()
        button.setTitle("SELL", for: .normal)
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
        
        self.addSubview(centerView)
        self.addSubview(buyButton)
        self.addSubview(sellButton)
        
        centerView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.centerX.equalToSuperview()
        }
        
        buyButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalTo(centerView.snp.leading).offset(-5)
        }
        
        sellButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalToSuperview()
            make.leading.equalTo(centerView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-25)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
