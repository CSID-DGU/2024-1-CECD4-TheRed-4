//
//  StockCoverCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class StockCoverCollectionViewCell: UICollectionViewCell {
    static let id = "StockCoverCollectionViewCell"
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    } ()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 0.1
        image.contentMode = .scaleAspectFit
        return image
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    } ()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    } ()
    
    private let earningRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    } ()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(indexLabel)
        self.addSubview(image)
        self.addSubview(titleLabel)
        self.addSubview(priceLabel)
        self.addSubview(earningRateLabel)
        
        indexLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(25)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(indexLabel.snp.trailing).offset(0)
            make.width.height.equalTo(50)
        }
        
        earningRateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(image.snp.centerY)
            make.leading.equalTo(priceLabel.snp.trailing).offset(1)
            make.trailing.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(image.snp.centerY)
            make.trailing.equalTo(earningRateLabel.snp.leading).offset(-20)
            make.width.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(image.snp.centerY)
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.trailing.equalTo(priceLabel.snp.leading).offset(-10)
            make.width.equalTo(90)
        }
        
        indexLabel.snp.makeConstraints { make in
            make.centerY.equalTo(image.snp.centerY)
        }
        
        let border = CALayer()
        border.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.1)
        border.frame = CGRect(x: 0, y: self.frame.size.height - 3, width: self.frame.size.width, height: 3)
        self.layer.addSublayer(border)
    }
    
    public func configure( index: Int, title: String, price: Int, startPrice: Int, ImageUrl: String ) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        indexLabel.text = String(index)
        titleLabel.text = title
        priceLabel.text = formatter.string(from: NSNumber(value: price))
        image.kf.setImage(with: URL(string: "https://drive.google.com/thumbnail?id=" + ImageUrl))
        
        let earningRate = Float(price - startPrice) / Float(startPrice) * 100
        
        if earningRate == 0 {
            earningRateLabel.textColor = .black
            earningRateLabel.text = "0%"
        }
        else if earningRate > 0 {
            priceLabel.textColor = .customRed
            earningRateLabel.textColor = .customRed
            earningRateLabel.text = String(format: "+%.2f%%", earningRate)
        }
        else {
            priceLabel.textColor = .customBlue
            earningRateLabel.textColor = .customBlue
            earningRateLabel.text = String(format: "%.2f%%", earningRate)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
