//
//  NewScenarioSellEarningCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 10/29/24.
//

import Foundation

import Foundation
import UIKit
import RxSwift

final class NewScenarioSellEarningCollectionViewCell: UICollectionViewCell {
    static let id = "NewScenarioSellEarningCollectionViewCell"
    
    let upCheckButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
        return button
    } ()
    
    let uplabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "수익률"
        return label
    } ()
    
    let upInput: UITextField = {
        let textField = UITextField(frame: CGRect())
       
        let leftView = UILabel()
        leftView.font = UIFont.systemFont(ofSize: 12)
        leftView.text = " +"
        leftView.textColor = .gray
        leftView.textAlignment = .center
        
        let rightView = UILabel()
        rightView.font = UIFont.systemFont(ofSize: 12)
        rightView.text = " % "
        rightView.textColor = .gray
        rightView.textAlignment = .center
        
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.rightView = rightView
        textField.rightViewMode = .always
        
        textField.keyboardType = .numberPad
        textField.placeholder = "0"
        textField.textColor = .black
        textField.textAlignment = .right
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.backgroundColor = .white
        
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        return textField
    } ()
    
    let upPrice: UILabel = {
        let label = UILabel()
        
        label.text = "원"
        label.textColor = .gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .white
        
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        return label
    } ()
    
    let up: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .customRed
        label.text = "이상"
        return label
    } ()
    
    let downCheckButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
        return button
    } ()
    
    let downlabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "손실률"
        return label
    } ()
    
    let downInput: UITextField = {
        let textField = UITextField(frame: CGRect())
        
        let leftView = UILabel()
        leftView.font = UIFont.systemFont(ofSize: 12)
        leftView.text = " -"
        leftView.textColor = .gray
        leftView.textAlignment = .center
        
        let rightView = UILabel()
        rightView.font = UIFont.systemFont(ofSize: 12)
        rightView.text = "% "
        rightView.textColor = .gray
        rightView.textAlignment = .center
        
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.rightView = rightView
        textField.rightViewMode = .always
        
        textField.keyboardType = .numberPad
        textField.placeholder = "0"
        textField.textColor = .black
        textField.textAlignment = .right
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.backgroundColor = .white
        
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        return textField
    } ()
    
    let downPrice: UILabel = {
        let label = UILabel()
        
        label.text = "원"
        label.textColor = .gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .white
        
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        return label
    } ()
    
    let down: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .customBlue
        label.text = "이하"
        return label
    } ()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(upCheckButton)
        self.addSubview(uplabel)
        self.addSubview(upInput)
        self.addSubview(upPrice)
        self.addSubview(up)
        
        self.addSubview(downCheckButton)
        self.addSubview(downlabel)
        self.addSubview(downInput)
        self.addSubview(downPrice)
        self.addSubview(down)
        
        upCheckButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        uplabel.snp.makeConstraints { make in
            make.leading.equalTo(upCheckButton.snp.trailing).offset(5)
            make.centerY.equalTo(upCheckButton.snp.centerY)
        }
        
        upInput.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.trailing.equalTo(upPrice.snp.leading).offset(-5)
            make.centerY.equalTo(upCheckButton.snp.centerY)
        }
        
        upPrice.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(upInput.snp.height)
            make.trailing.equalTo(up.snp.leading).offset(-5)
            make.centerY.equalTo(upCheckButton.snp.centerY)
        }
        
        up.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(0)
            make.centerY.equalTo(upCheckButton.snp.centerY)
        }
        
        downCheckButton.snp.makeConstraints { make in
            make.leading.equalTo(upCheckButton.snp.leading)
            make.top.equalTo(upCheckButton.snp.bottom).offset(10)
        }
        
        downlabel.snp.makeConstraints { make in
            make.leading.equalTo(downCheckButton.snp.trailing).offset(5)
            make.centerY.equalTo(downCheckButton.snp.centerY)
        }
        
        downInput.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.trailing.equalTo(downPrice.snp.leading).offset(-5)
            make.centerY.equalTo(downCheckButton.snp.centerY)
        }
        
        downPrice.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(downInput.snp.height)
            make.trailing.equalTo(down.snp.leading).offset(-5)
            make.centerY.equalTo(downCheckButton.snp.centerY)
        }
        
        down.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(0)
            make.centerY.equalTo(downCheckButton.snp.centerY)
        }
        
    }
    
    private let disposeBag = DisposeBag()
    
    public func setLabel(currentPrice:Int, viewModel: NewScenarioViewModel) {
        upInput.rx.text.orEmpty
            .subscribe(onNext: { text in
                let i = Int(text) ?? 0
                
                let unit = Float(viewModel.getUnit(price: currentPrice))
                let rate = 1 + Float(i) / 100
                let price = Float(currentPrice) * rate
                
                let expectPrice = Int(ceil( price / unit ) * unit)
                
                viewModel.targetPrice_sell_rate_up = expectPrice
                self.upPrice.text = String(expectPrice) + " 원"
            })
            .disposed(by: disposeBag)
        
        downInput.rx.text.orEmpty
            .subscribe(onNext: { text in
                let i = Int(text) ?? 0
                
                let unit = Float(viewModel.getUnit(price: currentPrice))
                let rate = 1 - Float(i) / 100
                let price = Float(currentPrice) * rate
                
                let expectPrice = Int(floor( price / unit ) * unit)
                
                viewModel.targetPrice_sell_rate_down = expectPrice
                self.downPrice.text = String(expectPrice) + " 원"
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
