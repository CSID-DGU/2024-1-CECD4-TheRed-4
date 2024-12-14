//
//  AutoTradeSelectButtonCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/8/24.
//

import Foundation
import UIKit
import SnapKit

final class AutoTradeSelectButtonCollectionViewCell: UICollectionViewCell {
    static let id = "AutoTradeSelectButtonCollectionViewCell"
    
    public let button: UIButton = {
        let button = UIButton()
        button.setTitle("적용하기", for: .normal)
        button.backgroundColor = .customBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return button
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(176)
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
