//
//  StockDetailHeaderCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/6/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class StockDetailHeaderCollectionViewCell: UICollectionViewCell {
    static let id = "StockDetailHeaderCollectionViewCell"
    
    private var currentPrice: Int = 0
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 37.5
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 0.1
        image.contentMode = .scaleAspectFit
        return image
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    } ()
    
    private let earningRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.addSubview(image)
        self.addSubview(titleLabel)
        self.addSubview(earningRateLabel)
        
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(75)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(image.snp.bottom).offset(5)
        }
        
        earningRateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
    
    public func configure(title: String, earningRate: Float, currentPrice:Int, ImageUrl: String ) {
        self.currentPrice = currentPrice
        titleLabel.text = title
        earningRateLabel.text = String(earningRate)
        image.kf.setImage(with: URL(string: "https://drive.google.com/thumbnail?id=" + ImageUrl))
        
        if earningRate == 0 {
            earningRateLabel.textColor = .black
            earningRateLabel.text = "0%"
        }
        else if earningRate > 0 {
            earningRateLabel.textColor = .red
            earningRateLabel.text = String(format: "+%.2f%%", earningRate)
        }
        else {
            earningRateLabel.textColor = .blue
            earningRateLabel.text = String(format: "%.2f%%", earningRate)
        }
    }
    
    public func practiceConfigure(title: String, earningRate: Float, currentPrice:Int) {
        self.currentPrice = currentPrice
        titleLabel.text = title
        earningRateLabel.text = String(earningRate)
        
        if let originalImage = UIImage(named: "STOCK SIGNAL") {
            let newSize = CGSize(width: 50, height: 30) // 원하는 크기
            let renderer = UIGraphicsImageRenderer(size: newSize)
            
            let resizedImage = renderer.image { _ in
                originalImage.draw(in: CGRect(origin: .zero, size: newSize))
            }
            
            image.image = resizedImage
            image.contentMode = .center // 이미지를 중앙에 고정
        }
        
        if earningRate == 0 {
            earningRateLabel.textColor = .black
            earningRateLabel.text = "0%"
        }
        else if earningRate > 0 {
            earningRateLabel.textColor = .red
            earningRateLabel.text = String(format: "+%.2f%%", earningRate)
        }
        else {
            earningRateLabel.textColor = .blue
            earningRateLabel.text = String(format: "%.2f%%", earningRate)
        }
    }
    
    public func setRate(openPrice: Int) {
        let earningRate = Float(self.currentPrice - openPrice) / Float(openPrice) * 100
        
        if earningRate == 0 {
            earningRateLabel.textColor = .black
            earningRateLabel.text = "0%"
        }
        else if earningRate > 0 {
            earningRateLabel.textColor = .red
            earningRateLabel.text = String(format: "+%.2f%%", earningRate)
        }
        else {
            earningRateLabel.textColor = .blue
            earningRateLabel.text = String(format: "%.2f%%", earningRate)
        }
    }
    
    public func setRateSync(currentPrice: Int) {
        let earningRate = Float(currentPrice - self.currentPrice) / Float(self.currentPrice) * 100
        
        if earningRate == 0 {
            earningRateLabel.textColor = .black
            earningRateLabel.text = "0%"
        }
        else if earningRate > 0 {
            earningRateLabel.textColor = .red
            earningRateLabel.text = String(format: "+%.2f%%", earningRate)
        }
        else {
            earningRateLabel.textColor = .blue
            earningRateLabel.text = String(format: "%.2f%%", earningRate)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
