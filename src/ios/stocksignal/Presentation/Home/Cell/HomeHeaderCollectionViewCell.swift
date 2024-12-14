//
//  HomeHeaderCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
//

import Foundation
import UIKit
import SnapKit

final class HomeHeaderCollectionViewCell: UICollectionViewCell {
    static let id = "HomeHeaderCollectionViewCell"
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "주식 현황 요약"
        label.textAlignment = NSTextAlignment.center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    } ()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "24.09.03 14:33 기준"
        label.textAlignment = NSTextAlignment.center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    } ()
    
    public let mystockButton: UIButton = {
        let button = UIButton()
        button.setTitle("MY STOCK >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(topLabel)
        self.addSubview(timeLabel)
        self.addSubview(mystockButton)
        
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        mystockButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    public func configure(time: String) {
        timeLabel.text = "\(time) 기준"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
