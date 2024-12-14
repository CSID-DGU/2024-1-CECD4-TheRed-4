//
//  StockDetailButtonCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/6/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class StockDetailButtonCollectionViewCell: UICollectionViewCell {
    static let id = "StockDetailButtonCollectionViewCell"
    
    public let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    } ()
    
    public let newsButton: UIButton = {
        let button = UIButton()
        button.setTitle("     뉴스     ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        return button
    } ()
    
    public let analysisButton: UIButton = {
        let button = UIButton()
        button.setTitle("     분석     ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.customBlue
        button.layer.cornerRadius = 15
        return button
    } ()
    
    public let aipredictButton: UIButton = {
        let button = UIButton()
        button.setTitle("   AI예측   ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        return button
    } ()
    
    public let autotradeButton: UIButton = {
        let button = UIButton()
        button.setTitle("  자동매매  ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        return button
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(box)
        self.addSubview(newsButton)
        self.addSubview(analysisButton)
        self.addSubview(aipredictButton)
        self.addSubview(autotradeButton)
        
        box.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(34)
            make.centerY.equalToSuperview()
        }
        newsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        analysisButton.snp.makeConstraints { make in
            make.leading.equalTo(newsButton.snp.trailing).offset(7)
            make.centerY.equalToSuperview()
        }
        
        aipredictButton.snp.makeConstraints { make in
            make.leading.equalTo(analysisButton.snp.trailing).offset(9)
            make.centerY.equalToSuperview()
        }
        
        autotradeButton.snp.makeConstraints { make in
            make.leading.equalTo(aipredictButton.snp.trailing).offset(7)
            make.centerY.equalToSuperview()
        }
    }
    
    public func configure( title: String, earningRate: Float, ImageUrl: String ) {
       
    }
    
    public func buttonSelect(index: Int) {
        newsButton.setTitleColor(.black, for: .normal)
        newsButton.backgroundColor = .white
        
        analysisButton.setTitleColor(.black, for: .normal)
        analysisButton.backgroundColor = .white
        
        aipredictButton.setTitleColor(.black, for: .normal)
        aipredictButton.backgroundColor = .white
        
        autotradeButton.setTitleColor(.black, for: .normal)
        autotradeButton.backgroundColor = .white
        
        switch index {
        case 0:
            newsButton.setTitleColor(.white, for: .normal)
            newsButton.backgroundColor = UIColor.customBlue
        case 1:
            analysisButton.setTitleColor(.white, for: .normal)
            analysisButton.backgroundColor = UIColor.customBlue
        case 2:
            aipredictButton.setTitleColor(.white, for: .normal)
            aipredictButton.backgroundColor = UIColor.customBlue
        case 3:
            autotradeButton.setTitleColor(.white, for: .normal)
            autotradeButton.backgroundColor = UIColor.customBlue
        default:
            print("default")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

