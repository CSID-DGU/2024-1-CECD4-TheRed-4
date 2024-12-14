//
//  NewScenarioBottomCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 10/29/24.
//

import Foundation
import UIKit
import RxSwift

final class NewScenarioFooterCollectionViewCell: UICollectionViewCell {
    static let id = "NewScenarioFooterCollectionViewCell"
    
    let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    } ()
    
    let textlabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "매매 수량"
        return label
    } ()
    
    let amountCheckButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
        return button
    } ()
    
    let amountlabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "수량"
        return label
    } ()
    
    let amountInput: UITextField = {
        let textField = UITextField(frame: CGRect())
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightView = paddingView
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
    
    let amount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "주"
        return label
    } ()
    
    let rateCheckButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
        return button
    } ()
    
    let ratelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "예수금 비율"
        return label
    } ()
    
    let rateInput: UITextField = {
        let textField = UITextField(frame: CGRect())
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightView = paddingView
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
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    let rate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "%"
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(box)
        box.addSubview(textlabel)
       
        box.addSubview(amountCheckButton)
        box.addSubview(amountlabel)
        box.addSubview(amountInput)
        box.addSubview(amount)
        
        box.addSubview(rateCheckButton)
        box.addSubview(ratelabel)
        box.addSubview(rateInput)
        box.addSubview(rate)
        
        self.addSubview(confirmButton)
        
        
        
        box.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.leading.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        textlabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
        }
        
        amountCheckButton.snp.makeConstraints { make in
            make.leading.equalTo(textlabel.snp.leading)
            make.top.equalTo(textlabel.snp.bottom).offset(10)
        }
        
        amountlabel.snp.makeConstraints { make in
            make.leading.equalTo(amountCheckButton.snp.trailing).offset(5)
            make.centerY.equalTo(amountCheckButton.snp.centerY)
        }
        
        amountInput.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.trailing.equalTo(amount.snp.leading).offset(-10)
            make.centerY.equalTo(amountCheckButton.snp.centerY)
        }
        
        amount.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(amountCheckButton.snp.centerY)
        }
        
        rateCheckButton.snp.makeConstraints { make in
            make.leading.equalTo(amountCheckButton.snp.leading)
            make.top.equalTo(amountCheckButton.snp.bottom).offset(10)
        }
        
        ratelabel.snp.makeConstraints { make in
            make.leading.equalTo(rateCheckButton.snp.trailing).offset(5)
            make.centerY.equalTo(rateCheckButton.snp.centerY)
        }
        
        rateInput.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.trailing.equalTo(rate.snp.leading).offset(-10)
            make.centerY.equalTo(rateCheckButton.snp.centerY)
        }
        
        rate.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(rateCheckButton.snp.centerY)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalToSuperview().dividedBy(3)
            make.centerX.equalToSuperview()
            make.top.equalTo(box.snp.bottom).offset(10)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    public func setLabel(viewModel: NewScenarioViewModel) {
        amountInput.rx.text.orEmpty
            .subscribe(onNext: { text in
                viewModel.tradeQuantity = Int(text) ?? 0
            })
            .disposed(by: disposeBag)
        
        rateInput.rx.text.orEmpty
            .subscribe(onNext: { text in
                viewModel.tradeRate = Int(text) ?? 0
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
