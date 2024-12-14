//
//  ScnarioNameModalViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/12/24.
//

import Foundation
import UIKit
import RxSwift

class ScenarioNameModalViewController: UIViewController {
    static let id = "ScenarioNameModalViewController"
    
    private let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "시나리오 이름 설정"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    let scenarioNameInput: UITextField = {
        let textField = UITextField(frame: CGRect())
        
        textField.textColor = .black
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.backgroundColor = .white
        
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        return textField
    } ()
    
    public let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("만들기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.customBlue
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        return button
    } ()
    
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        
        self.view.addSubview(box)
        box.addSubview(titleLabel)
        box.addSubview(scenarioNameInput)
        box.addSubview(cancelButton)
        box.addSubview(confirmButton)
        
        box.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(230)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        scenarioNameInput.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(scenarioNameInput.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(45)
            make.height.equalTo(40)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.top)
            make.trailing.equalToSuperview().offset(-45)
            make.height.equalTo(40)
            make.width.equalToSuperview().dividedBy(3)
        }
    }
    
    private let stockName: String
    private let earningRate: Float
    private let currentPrice: Int
    private let imageUrl: String
    private let tradeQuantity: Int
    
    init(stockName:String, earningRate:Float, currentPrice:Int, imageUrl:String, tradeQuantity: Int) {
        self.stockName = stockName
        self.earningRate = earningRate
        self.currentPrice = currentPrice
        self.imageUrl = imageUrl
        self.tradeQuantity = tradeQuantity
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        setUI()
        bindViewModel()
        setButton()
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func bindViewModel() {

    
    }
    
    private func setButton() {
        confirmButton.rx.tap.bind {[weak self] _ in
            let viewController = NewScenarioCoverViewController(scenarioID: nil, scenarioName:self!.scenarioNameInput.text!  ,stockName: self!.stockName, earningRate: self!.earningRate, currentPrice: self!.currentPrice, imageUrl: self!.imageUrl, tradeQuantity: self!.tradeQuantity, quantity: nil, avgPrice: nil, totalEarnRate: nil)
            
            self?.navigationController?.pushViewController(viewController, animated: true)
            
            
        }.disposed(by: disposeBag)
        
        cancelButton.rx.tap.bind {[weak self] _ in
            self?.dismiss(animated: false)
        }.disposed(by: disposeBag)
    
    }
    
        var onDismiss: (() -> Void)?
    
        override func viewDidDisappear(_ animated: Bool) {
            onDismiss?()
    //        super.viewDidDisappear(animated)
    //        if self.isBeingDismissed {
    //
    //        }
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
