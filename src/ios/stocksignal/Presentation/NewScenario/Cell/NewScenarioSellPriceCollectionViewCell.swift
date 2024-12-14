//
//  NewScenarioSellPriceCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 10/29/24.
//

import Foundation
import UIKit
import RxSwift

final class NewScenarioSellPriceCollectionViewCell: UICollectionViewCell {
    static let id = "NewScenarioSellPriceCollectionViewCell"
    
    let upCheckButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
        return button
    } ()
    
    let uplabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "이익 실현 목표"
        return label
    } ()
    
    let uplabel2: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "주가가"
        return label
    } ()
    
    let uplabel3: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .customRed
        label.text = "상승하여"
        return label
    } ()
    
    let upInput: UITextField = {
        let textField = UITextField(frame: CGRect())
        
        let rightView = UILabel()
        rightView.font = UIFont.systemFont(ofSize: 18)
        rightView.text = "원 "
        rightView.textColor = .gray
        rightView.textAlignment = .center
 
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
    
    let up: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "도달 시"
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
        label.text = "손실 제한 목표"
        return label
    } ()
    
    let downlabel2: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "주가가"
        return label
    } ()
    
    let downlabel3: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .customBlue
        label.text = "하락하여"
        return label
    } ()
    
    let downInput: UITextField = {
        let textField = UITextField(frame: CGRect())
        
        let rightView = UILabel()
        rightView.font = UIFont.systemFont(ofSize: 18)
        rightView.text = "원 "
        rightView.textColor = .gray
        rightView.textAlignment = .center

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
    
    let down: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .customBlack.withAlphaComponent(0.5)
        label.text = "도달 시"
        return label
    } ()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(upCheckButton)
        self.addSubview(uplabel)
        self.addSubview(uplabel2)
        self.addSubview(uplabel3)
        self.addSubview(upInput)
        self.addSubview(up)
        
        self.addSubview(downCheckButton)
        self.addSubview(downlabel)
        self.addSubview(downlabel2)
        self.addSubview(downlabel3)
        self.addSubview(downInput)
        self.addSubview(down)
        
        upCheckButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        uplabel.snp.makeConstraints { make in
            make.leading.equalTo(upCheckButton.snp.trailing).offset(5)
            make.top.equalTo(upCheckButton.snp.top)
        }
        
        uplabel2.snp.makeConstraints { make in
            make.leading.equalTo(uplabel.snp.leading)
            make.top.equalTo(uplabel.snp.bottom).offset(5)
        }
        
        uplabel3.snp.makeConstraints { make in
            make.leading.equalTo(uplabel2.snp.trailing).offset(5)
            make.centerY.equalTo(uplabel2.snp.centerY)
        }
        upInput.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.leading.equalTo(uplabel3.snp.trailing).offset(10)
            make.centerY.equalTo(uplabel2.snp.centerY)
        }
        
        up.snp.makeConstraints { make in
            make.leading.equalTo(upInput.snp.trailing).offset(10)
            make.centerY.equalTo(uplabel2.snp.centerY)
        }
        
        downCheckButton.snp.makeConstraints { make in
            make.leading.equalTo(upCheckButton.snp.leading)
            make.top.equalTo(uplabel2.snp.bottom).offset(25)
        }
        
        downlabel.snp.makeConstraints { make in
            make.leading.equalTo(downCheckButton.snp.trailing).offset(5)
            make.top.equalTo(downCheckButton.snp.top)
        }
        
        downlabel2.snp.makeConstraints { make in
            make.top.equalTo(downlabel.snp.bottom).offset(10)
            make.leading.equalTo(downlabel.snp.leading)
        }
        
        downlabel3.snp.makeConstraints { make in
            make.leading.equalTo(downlabel2.snp.trailing).offset(5)
            make.centerY.equalTo(downlabel2.snp.centerY)
        }
        
        downInput.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.leading.equalTo(downlabel3.snp.trailing).offset(10)
            make.centerY.equalTo(downlabel2.snp.centerY)
        }
        
        
        down.snp.makeConstraints { make in
            make.leading.equalTo(downInput.snp.trailing).offset(10)
            make.centerY.equalTo(downlabel2.snp.centerY)
        }
        
    }
    
    private let disposeBag = DisposeBag()
    
    public func setLabel(viewModel: NewScenarioViewModel) {
        upInput.rx.text.orEmpty
            .subscribe(onNext: { text in
                viewModel.targetPrice_sell_price_up = Int(text) ?? 0
            })
            .disposed(by: disposeBag)
        
        downInput.rx.text.orEmpty
            .subscribe(onNext: { text in
                viewModel.targetPrice_sell_price_down = Int(text) ?? 0
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
