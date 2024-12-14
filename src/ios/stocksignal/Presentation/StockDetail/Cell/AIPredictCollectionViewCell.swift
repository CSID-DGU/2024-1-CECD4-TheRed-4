//
//  AIPredictCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/6/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class AIPredictCollectionViewCell: UICollectionViewCell {
    static let id = "AIPredictCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AI Predict"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .cyan
//        
//        self.addSubview(titleLabel)
//        
//        titleLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
    }
    
    public func configure() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

