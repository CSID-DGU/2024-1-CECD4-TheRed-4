//
//  RankItemCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 11/11/24.
//

import Foundation
import UIKit

final class RankItemCollectionViewCell: UICollectionViewCell {
    static let id = "RankItemCollectionViewCell"
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customBlack.withAlphaComponent(0.7)
        return label
    } ()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customBlack.withAlphaComponent(0.7)
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(indexLabel)
        self.addSubview(companyNameLabel)
        
        indexLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
        
        companyNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(indexLabel.snp.trailing)
            make.centerY.equalTo(indexLabel.snp.centerY)

        }
    }
    
    public func configure(index:Int, companyName:String){
        indexLabel.text = String(index) + "."
        companyNameLabel.text = companyName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
