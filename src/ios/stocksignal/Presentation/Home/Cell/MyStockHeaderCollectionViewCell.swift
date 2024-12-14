//
//  MyStockHeaderCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/5/24.
//

import Foundation
import UIKit
import SnapKit

final class MyStockHeaderCollectionViewCell: UICollectionViewCell {
    static let id = "MyStockHeaderCollectionViewCell"
    
    let uiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = CGColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 6, height: 6)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        return view
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "MY STOCK"
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
    
    private let horizontalBox: UIView = {
        let box = UIView(frame: CGRect())
        return box
    } ()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0원"
        label.textAlignment = NSTextAlignment.center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    } ()
    
    private let earningRateLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0%"
        label.textAlignment = NSTextAlignment.center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    } ()
    
    private let cashLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 1원"
        label.textAlignment = NSTextAlignment.center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .customBlack.withAlphaComponent(0.75)
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(uiView)
        
        uiView.snp.makeConstraints { make in 
            make.edges.equalToSuperview()
        }
        
        uiView.addSubview(timeLabel)
        uiView.addSubview(topLabel)
        uiView.addSubview(horizontalBox)
        uiView.addSubview(cashLabel)
        horizontalBox.addSubview(balanceLabel)
        horizontalBox.addSubview(earningRateLabel)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
        }
        
        horizontalBox.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        earningRateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(balanceLabel.snp.trailing).offset(10)
        }
        
        cashLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
    }
    
    public func configure(time: String, balance: Int, PL: Int, cash: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        timeLabel.text = "\(time) 기준"
        balanceLabel.text = (formatter.string(from: NSNumber(value: balance)) ?? "0") + "원"
        
        let earningRate = Float(PL) / Float(balance) * 100
        
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
        
        cashLabel.text = (formatter.string(from: NSNumber(value: cash)) ?? "0") + " / " + (formatter.string(from: NSNumber(value: balance)) ?? "0") + "원"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
