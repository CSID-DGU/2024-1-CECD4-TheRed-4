//
//  AnalysisCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/6/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class AnalysisCollectionViewCell: UICollectionViewCell {
    static let id = "AnalysisCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "분석"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    } ()
    
    private let startPriceTextLabel: UILabel = {
        let label = UILabel()
        label.text = "시작가"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let endPriceTextLabel: UILabel = {
        let label = UILabel()
        label.text = "종가"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()   
    
    private let tradeQuantityTextLabel: UILabel = {
        let label = UILabel()
        label.text = "거래량"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let tradePriceTextLabel: UILabel = {
        let label = UILabel()
        label.text = "거래대금"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let startPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 원"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    } ()
    
    private let endPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 원"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    } ()
    
    private let tradeQuantityLabel: UILabel = {
        let label = UILabel()
        label.text = "0 주"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    } ()
    
    private let tradePriceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 백만"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    } ()
    
    private let dayBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let dayPos: UIView = {
        let view = UIView()
        return view
    } ()
    
    private let dayPoint: UIView = {
        let view = UIView()
        view.backgroundColor = .customBlue
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let dayMaxTextLabel: UILabel = {
        let label = UILabel()
        label.text = "1일 최고가"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let dayMinTextLabel: UILabel = {
        let label = UILabel()
        label.text = "1일 최저가"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let dayMaxLabel: UILabel = {
        let label = UILabel()
        label.text = "0원"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let dayMinLabel: UILabel = {
        let label = UILabel()
        label.text = "0원"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let yearBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let yearPos: UIView = {
        let view = UIView()
        return view
    } ()
    
    private let yearPoint: UIView = {
        let view = UIView()
        view.backgroundColor = .customBlue
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let yearMaxTextLabel: UILabel = {
        let label = UILabel()
        label.text = "1년 최고가"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let yearMinTextLabel: UILabel = {
        let label = UILabel()
        label.text = "1년 최저가"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let yearMaxLabel: UILabel = {
        let label = UILabel()
        label.text = "0원"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let yearMinLabel: UILabel = {
        let label = UILabel()
        label.text = "0원"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(startPriceTextLabel)
        self.addSubview(endPriceTextLabel)
        self.addSubview(tradeQuantityTextLabel)
        self.addSubview(tradePriceTextLabel)
        
        self.addSubview(titleLabel)
        self.addSubview(startPriceLabel)
        self.addSubview(endPriceLabel)
        self.addSubview(tradeQuantityLabel)
        self.addSubview(tradePriceLabel)
        
        self.addSubview(dayBar)
        dayBar.addSubview(dayPos)
        dayBar.addSubview(dayPoint)
        self.addSubview(dayMinTextLabel)
        self.addSubview(dayMaxTextLabel)
        self.addSubview(dayMinLabel)
        self.addSubview(dayMaxLabel)
        
        self.addSubview(yearBar)
        yearBar.addSubview(yearPos)
        yearBar.addSubview(yearPoint)
        self.addSubview(yearMinTextLabel)
        self.addSubview(yearMaxTextLabel)
        self.addSubview(yearMinLabel)
        self.addSubview(yearMaxLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview()
        }
        
        startPriceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
        }
        
        startPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(startPriceTextLabel.snp.top)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        endPriceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(startPriceTextLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
        }
        
        endPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(endPriceTextLabel.snp.top)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        tradeQuantityTextLabel.snp.makeConstraints { make in
            make.top.equalTo(endPriceTextLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
        }
        
        tradeQuantityLabel.snp.makeConstraints { make in
            make.top.equalTo(tradeQuantityTextLabel.snp.top)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        tradePriceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(tradeQuantityTextLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
        }
        
        tradePriceLabel.snp.makeConstraints { make in
            make.top.equalTo(tradePriceTextLabel.snp.top)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        dayBar.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.top.equalTo(tradePriceTextLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        dayPos.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(10)
        }
        
        dayPoint.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(10)
            make.top.equalToSuperview()
            make.leading.equalTo(dayPos.snp.trailing)
        }
        
        dayMinTextLabel.snp.makeConstraints { make in
            make.top.equalTo(dayBar.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        
        dayMinLabel.snp.makeConstraints { make in
            make.top.equalTo(dayMinTextLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
        }
        
        dayMaxTextLabel.snp.makeConstraints { make in
            make.top.equalTo(dayBar.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
        }
        
        dayMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(dayMaxTextLabel.snp.bottom).offset(5)
            make.trailing.equalToSuperview()
        }
        
        yearBar.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.top.equalTo(dayMinLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        yearPos.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(10)
        }
        
        yearPoint.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(10)
            make.top.equalToSuperview()
            make.leading.equalTo(yearPos.snp.trailing)
        }
        
        yearMinTextLabel.snp.makeConstraints { make in
            make.top.equalTo(yearBar.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        
        yearMinLabel.snp.makeConstraints { make in
            make.top.equalTo(yearMinTextLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
        }
        
        yearMaxTextLabel.snp.makeConstraints { make in
            make.top.equalTo(yearBar.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
        }
        
        yearMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(yearMaxTextLabel.snp.bottom).offset(5)
            make.trailing.equalToSuperview()
        }
        
    }
    
    public func configure(stockName: String, currentPrice: Int, stockDetail: StockDetail) {
        
        titleLabel.text = stockName + " 분석"
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        startPriceLabel.text = (formatter.string(from: NSNumber(value: stockDetail.openPrice)) ?? "0") + "원"
        endPriceLabel.text = (formatter.string(from: NSNumber(value: stockDetail.closePrice)) ?? "0") + "원"
        tradeQuantityLabel.text = (formatter.string(from: NSNumber(value: stockDetail.tradingVolume)) ?? "0") + "주"
        tradePriceLabel.text = (formatter.string(from: NSNumber(value: stockDetail.tradingVolume * stockDetail.closePrice / 10000)) ?? "0") + "백만"
        dayMinLabel.text = (formatter.string(from: NSNumber(value: stockDetail.lowPrice)) ?? "0") + "원"
        dayMaxLabel.text = (formatter.string(from: NSNumber(value: stockDetail.highPrice)) ?? "0") + "원"
        yearMinLabel.text = (formatter.string(from: NSNumber(value: stockDetail.oneYearLowPrice)) ?? "0") + "원"
        yearMaxLabel.text = (formatter.string(from: NSNumber(value: stockDetail.oneYearHighPrice)) ?? "0") + "원"
        
        let width = Float(260)
        
        let dayPosition = Float(currentPrice - stockDetail.lowPrice) / Float(stockDetail.highPrice - stockDetail.lowPrice)
        let dayP = width * dayPosition
        
        let yearPosition = Float(currentPrice - stockDetail.oneYearLowPrice) / Float(stockDetail.oneYearHighPrice - stockDetail.oneYearLowPrice)
        let yearP = width * yearPosition
        
        dayPos.snp.updateConstraints { make in
            make.width.equalTo(dayP)
        }
        
        yearPos.snp.updateConstraints { make in
            make.width.equalTo(yearP)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

