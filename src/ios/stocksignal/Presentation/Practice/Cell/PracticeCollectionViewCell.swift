//
//  PracticeCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 11/24/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import RxSwift

final class PracticeCollectionViewCell: UICollectionViewCell {
    static let id = "PracticeCollectionViewCell"
    
    public let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.2)
        button.layer.cornerRadius = 5
        return button
    } ()
    
    public let continueButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forward"), for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.2)
        button.layer.cornerRadius = 5
        return button
    } ()
    
    public let stopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.2)
        button.layer.cornerRadius = 5
        return button
    } ()
    
    public let endButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forwardEnd"), for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.2)
        button.layer.cornerRadius = 5
        return button
    } ()
    
    private let rateTextLabel: UILabel = {
        let label = UILabel()
        label.text = "수익률"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let accountTextLabel: UILabel = {
        let label = UILabel()
        label.text = "잔고"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let avgPriceTextLabel: UILabel = {
        let label = UILabel()
        label.text = "평균구매가"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let quantityTextLabel: UILabel = {
        let label = UILabel()
        label.text = "보유량"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.75)
        return label
    } ()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "100,000,000 / 100,000,000 원"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.75)
        return label
    } ()
    
    private let avgPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 원"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.75)
        return label
    } ()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "0 주"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.75)
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(nextButton)
        self.addSubview(continueButton)
        self.addSubview(stopButton)
        self.addSubview(endButton)
        
        self.addSubview(rateTextLabel)
        self.addSubview(accountTextLabel)
        self.addSubview(quantityTextLabel)
        self.addSubview(avgPriceTextLabel)
        self.addSubview(rateLabel)
        self.addSubview(accountLabel)
        self.addSubview(avgPriceLabel)
        self.addSubview(quantityLabel)
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
            make.width.equalToSuperview().dividedBy(4.5)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.equalTo(nextButton.snp.trailing).offset(10)
            make.top.equalTo(nextButton.snp.top)
            make.height.equalTo(30)
            make.width.equalToSuperview().dividedBy(4.5)
        }
        
        stopButton.snp.makeConstraints { make in
            make.leading.equalTo(continueButton.snp.trailing).offset(10)
            make.top.equalTo(nextButton.snp.top)
            make.height.equalTo(30)
            make.width.equalToSuperview().dividedBy(4.5)
        }
        
        endButton.snp.makeConstraints { make in
            make.leading.equalTo(stopButton.snp.trailing).offset(10)
            make.top.equalTo(nextButton.snp.top)
            make.height.equalTo(30)
            make.width.equalToSuperview().dividedBy(4.5)
        }
        
        rateTextLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(30)
        }
        
        accountTextLabel.snp.makeConstraints { make in
            make.top.equalTo(rateTextLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(30)
        }
        
        avgPriceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(accountLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(30)
        }
        
        quantityTextLabel.snp.makeConstraints { make in
            make.top.equalTo(avgPriceTextLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(30)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(accountTextLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        avgPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(accountLabel.snp.bottom).offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.top.equalTo(avgPriceTextLabel.snp.bottom).offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        setButton()
    }
    
    private var viewModel = PracticeViewModel()
    private let disposeBag = DisposeBag()
    private var isContinue = false
    
    public func configure(viewModel: PracticeViewModel) {
        self.viewModel = viewModel
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButton() {
        nextButton.rx.tap.bind {[weak self] _ in
            self?.updateUI()
        }.disposed(by: disposeBag)
    }
    
    public func updateUI() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        let totalAccount = self.viewModel.accountCash + self.viewModel.currentPrice * self.viewModel.quantity
        let earnRate = Float(totalAccount - 100000000) / 100000000 * 100
        
        if earnRate == 0 {
            rateLabel.textColor = .black
            rateLabel.text = "0%"
        }
        else if earnRate > 0 {
            rateLabel.textColor = .red
            rateLabel.text = String(format: "+%.2f%%", earnRate)
        }
        else {
            rateLabel.textColor = .blue
            rateLabel.text = String(format: "%.2f%%", earnRate)
        }
        
        accountLabel.text = (formatter.string(from: NSNumber(value: self.viewModel.accountCash)) ?? "0") + " / " + (formatter.string(from: NSNumber(value: totalAccount)) ?? "0") + " 원"
        avgPriceLabel.text = (formatter.string(from: NSNumber(value: self.viewModel.avgPrice)) ?? "0") + "원"
        quantityLabel.text = (formatter.string(from: NSNumber(value: self.viewModel.quantity)) ?? "0") + "주"
    
        
    }
}

