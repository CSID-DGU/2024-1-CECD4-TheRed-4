//
//  NewScenarioTradingCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/10/24.
//

import Foundation
import UIKit
import RxSwift

final class NewScenarioBuyTradingCollectionViewCell: UICollectionViewCell {
    static let id = "NewScenarioBuyTradingCollectionViewCell"
    
    let upCheckButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
        return button
    } ()
    
    let uplabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "주가가"
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
    
    let uplabel1: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customRed
        label.text = "상승하여"
        return label
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
    
    let uplabel2: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "이상이었다가"
        return label
    } ()
    
    let upInput2: UITextField = {
        let textField = UITextField(frame: CGRect())
       
        let leftView = UILabel()
        leftView.font = UIFont.systemFont(ofSize: 12)
        leftView.text = " -"
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
    
    let uplabel3: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlue
        label.text = "하락 시"
        return label
    } ()
    
    let up: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "주문실행"
        return label
    } ()
    
    let downCheckButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
        return button
    } ()
    
    let downlabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "주가가"
        return label
    } ()
    
    let downInput: UITextField = {
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
    
    let downlabel1: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customRed
        label.text = "상승하여"
        return label
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
    
    let downlabel2: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "이상이었다가"
        return label
    } ()
    
    let downInput2: UITextField = {
        let textField = UITextField(frame: CGRect())
       
        let leftView = UILabel()
        leftView.font = UIFont.systemFont(ofSize: 12)
        leftView.text = " -"
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
    
    let downlabel3: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlue
        label.text = "하락 시"
        return label
    } ()
    
    let down: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "주문실행"
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(upCheckButton)
        self.addSubview(uplabel)
        self.addSubview(upInput)
        self.addSubview(uplabel1)
        self.addSubview(upPrice)
        self.addSubview(uplabel2)
        self.addSubview(upInput2)
        self.addSubview(uplabel3)
        self.addSubview(up)
        
        self.addSubview(downCheckButton)
        self.addSubview(downlabel)
        self.addSubview(downInput)
        self.addSubview(downlabel1)
        self.addSubview(downPrice)
        self.addSubview(downlabel2)
        self.addSubview(downInput2)
        self.addSubview(downlabel3)
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
            make.width.equalTo(85)
            make.leading.equalTo(uplabel.snp.trailing).offset(10)
            make.centerY.equalTo(upCheckButton.snp.centerY)
        }
        
        uplabel1.snp.makeConstraints { make in
            make.leading.equalTo(upInput.snp.trailing).offset(5)
            make.centerY.equalTo(upCheckButton.snp.centerY)
        }
        
        upPrice.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.height.equalTo(upInput.snp.height)
            make.top.equalTo(upInput.snp.bottom).offset(10)
            make.leading.equalTo(upInput.snp.leading)
        }
        
        uplabel2.snp.makeConstraints { make in
            make.leading.equalTo(upPrice.snp.trailing).offset(5)
            make.centerY.equalTo(upPrice.snp.centerY)
        }
        
        upInput2.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.top.equalTo(upPrice.snp.bottom).offset(10)
            make.leading.equalTo(upInput.snp.leading)
        }
        
        uplabel3.snp.makeConstraints { make in
            make.leading.equalTo(upInput2.snp.trailing).offset(5)
            make.centerY.equalTo(upInput2.snp.centerY)
        }
        
        up.snp.makeConstraints { make in
            make.leading.equalTo(uplabel3.snp.trailing).offset(5)
            make.centerY.equalTo(upInput2.snp.centerY)
        }
        
        downCheckButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(upInput2.snp.bottom).offset(20)
        }
        
        downlabel.snp.makeConstraints { make in
            make.leading.equalTo(downCheckButton.snp.trailing).offset(5)
            make.centerY.equalTo(downCheckButton.snp.centerY)
        }
        
        downInput.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.leading.equalTo(downlabel.snp.trailing).offset(10)
            make.centerY.equalTo(downCheckButton.snp.centerY)
        }
        
        downlabel1.snp.makeConstraints { make in
            make.leading.equalTo(downInput.snp.trailing).offset(5)
            make.centerY.equalTo(downCheckButton.snp.centerY)
        }
        
        downPrice.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.height.equalTo(downInput.snp.height)
            make.top.equalTo(downInput.snp.bottom).offset(10)
            make.leading.equalTo(downInput.snp.leading)
        }
        
        downlabel2.snp.makeConstraints { make in
            make.leading.equalTo(downPrice.snp.trailing).offset(5)
            make.centerY.equalTo(downPrice.snp.centerY)
        }
        
        downInput2.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.top.equalTo(downPrice.snp.bottom).offset(10)
            make.leading.equalTo(downInput.snp.leading)
        }
        
        downlabel3.snp.makeConstraints { make in
            make.leading.equalTo(downInput2.snp.trailing).offset(5)
            make.centerY.equalTo(downInput2.snp.centerY)
        }
        
        down.snp.makeConstraints { make in
            make.leading.equalTo(downlabel3.snp.trailing).offset(5)
            make.centerY.equalTo(downInput2.snp.centerY)
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
                
                viewModel.targetPrice_buy_trade_up1 = expectPrice
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
                
                viewModel.targetPrice_buy_trade_down2 = expectPrice
                self.downPrice.text = String(expectPrice) + " 원"
            })
            .disposed(by: disposeBag)
        
        upInput2.rx.text.orEmpty
            .subscribe(onNext: { text in
                let i = Int(text) ?? 0
                
                let unit = Float(viewModel.getUnit(price: currentPrice))
                let rate = 1 - Float(i) / 100
                let price = Float(currentPrice) * rate
                
                let expectPrice = Int(floor( price / unit ) * unit)
                
                viewModel.targetPrice_buy_trade_down1 = expectPrice
            })
            .disposed(by: disposeBag)
        
        downInput2.rx.text.orEmpty
            .subscribe(onNext: { text in
                let i = Int(text) ?? 0
                
                let unit = Float(viewModel.getUnit(price: currentPrice))
                let rate = 1 - Float(i) / 100
                let price = Float(currentPrice) * rate
                
                let expectPrice = Int(floor( price / unit ) * unit)
                
                viewModel.targetPrice_buy_trade_up2 = expectPrice
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
