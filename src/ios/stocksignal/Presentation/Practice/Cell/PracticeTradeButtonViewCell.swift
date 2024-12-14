//
//  PracticeTradeButtonViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 11/25/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class PracticeTradeButtonViewCell: UIView {
    static let id = "PracticeTradeButtonViewCell"
    
    let centerView: UIView = {
        let view = UIView()
        return view
    } ()
    
    let askingButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택해서 거래하기", for: .normal)
        button.setTitleColor(.customBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    let instantButton: UIButton = {
        let button = UIButton()
        button.setTitle("즉시 거래하기", for: .normal)
        button.setTitleColor(.customBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(centerView)
        self.addSubview(askingButton)
        self.addSubview(instantButton)
        
        self.backgroundColor = .background
        
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(1)
        }
        
        askingButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(centerView.snp.leading)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(45)
            
            
        }
        
        instantButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(centerView.snp.trailing)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(45)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
