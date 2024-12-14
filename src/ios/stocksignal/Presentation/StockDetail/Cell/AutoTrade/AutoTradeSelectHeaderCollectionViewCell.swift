//
//  AutoTradeSelectHeaderCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/8/24.
//

import Foundation
import UIKit
import SnapKit

final class AutoTradeSelectHeaderCollectionViewCell: UICollectionViewCell {
    static let id = "AutoTradeSelectHeaderCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.text = "시나리오"
        return label
    } ()
    
    public let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.customBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return button
    } ()
    
    public let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.customRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return button
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(plusButton)
        self.addSubview(minusButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        minusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(minusButton.snp.leading).offset(10)
        }
    }
    
    public func configure(title: String) {
        titleLabel.text = "\(title) 시나리오"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
