//
//  BuyModalViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/14/24.
//

import Foundation
import UIKit
import RxSwift

class InstantModalViewController: UIViewController {
    static let id = "InstantModalViewController"
    
    private let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .customRed.withAlphaComponent(0.15)
        return view
    } ()
    
    private let sellButton: UIButton = {
        let button = UIButton()
        button.setTitle("SELL", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        return button
    } ()
    
    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("BUY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.customRed.withAlphaComponent(0.8)
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        return button
    } ()
    
    private let priceView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "즉시 거래가"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    } ()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 원"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    } ()
    
    private let quantityView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let quantityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "수량"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    } ()
    
    private let quantityInput: UITextField = {
        let textField = UITextField(frame: CGRect())
        textField.placeholder = "몇 주 살까요?"
        textField.keyboardType = .decimalPad
        textField.textColor = .black
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 22)
        
        return textField
    } ()
    
    private let availableQuantityLabel: UILabel = {
        let label = UILabel()
        label.text = "구매가능 0원 / 최대 0주"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.customRed.withAlphaComponent(0.8)
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        return button
    } ()
    
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(colorView)
        
        colorView.addSubview(sellButton)
        colorView.addSubview(buyButton)
        colorView.addSubview(priceView)
        colorView.addSubview(quantityView)
        colorView.addSubview(confirmButton)
        
        priceView.addSubview(priceTitleLabel)
        priceView.addSubview(currentPriceLabel)
        
        quantityView.addSubview(quantityTitleLabel)
        quantityView.addSubview(quantityInput)
        quantityView.addSubview(availableQuantityLabel)
        
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sellButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(25)
            make.height.equalTo(45)
            make.width.equalToSuperview().dividedBy(2.3)
        }
        
        buyButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(45)
            make.width.equalToSuperview().dividedBy(2.3)
        }
        
        priceView.snp.makeConstraints { make in
            make.top.equalTo(sellButton.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(100)
        }
        
        quantityView.snp.makeConstraints { make in
            make.top.equalTo(priceView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(120)
        }
        
        priceTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        currentPriceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        quantityTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        quantityInput.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        availableQuantityLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(quantityView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(50)
        }
    }
    
    override func viewDidLoad() {
        
        setUI()
        bindViewModel()
        setButton()
        
        self.cash = self.getCash()
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        self.availableQuantityLabel.text = "구매가능 " + (formatter.string(from: NSNumber(value: self.cash)) ?? "0") + "원 / 최대 " + (formatter.string(from: NSNumber(value: self.cash / self.currentPrice)) ?? "0") + "주"
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel: StockDetailViewModel
    
    private let currentPrice: Int
    private let stockName: String
    private var stockCode: String = ""
    private var buySellIndex: Int = 1
    private var cash: Int
    private var quantity: Int
    
    init(currentPrice: Int, stockName: String, quantity:Int, viewModel: StockDetailViewModel) {
        self.currentPrice = currentPrice
        self.stockName = stockName
        self.viewModel = viewModel
        self.cash = 0
        self.quantity = quantity
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        currentPriceLabel.text = (formatter.string(from: NSNumber(value: currentPrice)) ?? "0") + " 원"
        super.init(nibName: nil, bundle: nil)
    }
    
    private func setButton() {
        
        
        sellButton.rx.tap.bind {[weak self] _ in
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            self?.buySellIndex = 0
            
            self?.colorView.backgroundColor = .customBlue.withAlphaComponent(0.15)
            
            self?.sellButton.setTitleColor(.white, for: .normal)
            self?.sellButton.backgroundColor = .customBlue.withAlphaComponent(0.8)
            
            self?.buyButton.setTitleColor(.darkGray, for: .normal)
            self?.buyButton.backgroundColor = .white
            
            self?.quantityInput.placeholder = "몇 주 팔까요?"
            
            self?.availableQuantityLabel.text = "판매가능 최대 " + (formatter.string(from: NSNumber(value: self!.quantity)) ?? "0") + " 주"
            
            self?.confirmButton.backgroundColor = .customBlue.withAlphaComponent(0.8)
            self?.confirmButton.setTitle("판매하기", for: .normal)
        }.disposed(by: disposeBag)
        
        buyButton.rx.tap.bind {[weak self] _ in
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            self?.buySellIndex = 1
            
            self?.colorView.backgroundColor = .customRed.withAlphaComponent(0.15)
            
            self?.sellButton.setTitleColor(.darkGray, for: .normal)
            self?.sellButton.backgroundColor = .white
            
            self?.buyButton.setTitleColor(.white, for: .normal)
            self?.buyButton.backgroundColor = .customRed.withAlphaComponent(0.8)
            
            self?.quantityInput.placeholder = "몇 주 살까요?"
            
            self?.availableQuantityLabel.text = "구매가능 " + (formatter.string(from: NSNumber(value: self!.cash)) ?? "0") + "원 / 최대 " + (formatter.string(from: NSNumber(value: self!.cash / self!.currentPrice)) ?? "0") + "주"
            
            self?.confirmButton.backgroundColor = .customRed.withAlphaComponent(0.8)
            self?.confirmButton.setTitle("구매하기", for: .normal)
        }.disposed(by: disposeBag)
        
        confirmButton.rx.tap.bind {[weak self] _ in
            self?.viewModel.quantity = Int(self?.quantityInput.text ?? "0") ?? 0
            if (self?.buySellIndex == 0) {
                let out = self?.viewModel.sellStock(stockCode: self!.stockCode, orderType: "JIJUNG", price: self!.currentPrice)
                
                out?.observeOn(MainScheduler.instance).bind { out in
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    
                    let viewController = TradeCompleteModalViewController(type: "판매 완료!", condition: "\(self!.currentPrice)원 \(String(self!.quantityInput.text!))주 ")
                    viewController.modalPresentationStyle = .overFullScreen
                    self?.present(viewController, animated: false)
                    
                    self?.quantity = self!.quantity - self!.viewModel.quantity
                    self?.cash = self!.cash + self!.viewModel.quantity * self!.currentPrice
                    
                    self?.availableQuantityLabel.text = "판매가능 최대 " + (formatter.string(from: NSNumber(value: self!.quantity)) ?? "0") + " 주"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak viewController, weak self] in
                        viewController?.dismiss(animated: false) {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }.disposed(by: self!.disposeBag)
            }
            else if (self?.buySellIndex == 1) {
                let out = self?.viewModel.buyStock(stockCode: self!.stockCode, orderType: "JIJUNG", price: self!.currentPrice)
                
                out?.observeOn(MainScheduler.instance).bind { out in
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    
                    let viewController = TradeCompleteModalViewController(type: "구매 완료!", condition: "\(self!.currentPrice)원 \(String(self!.quantityInput.text!))주 ")
                    viewController.modalPresentationStyle = .overFullScreen
                    self?.present(viewController, animated: false)
                    
                    self?.quantity = self!.quantity + self!.viewModel.quantity
                    self?.cash = self!.cash - self!.viewModel.quantity * self!.currentPrice
                    
                    self?.availableQuantityLabel.text = "구매가능 " + (formatter.string(from: NSNumber(value: self!.cash)) ?? "0") + "원 / 최대 " + (formatter.string(from: NSNumber(value: self!.cash / self!.currentPrice)) ?? "0") + "주"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak viewController, weak self] in
                        viewController?.dismiss(animated: false) {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }.disposed(by: self!.disposeBag)
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let out = viewModel.getCode(stockName: self.stockName)
        
        out.bind {[weak self] out in
            self?.stockCode = out.data.companyCode
        }.disposed(by: disposeBag)
    }
    
    private func getCash() -> Int {
        // Keychain에서 cash를 가져오는 쿼리
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "cash", // cash의 키
            kSecAttrService: "StockSignal",
            kSecReturnData: true,    // 데이터를 반환하도록 설정
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)

        if status == errSecSuccess {
            if let data = item as? Data,
               let cashString = String(data: data, encoding: .utf8),
               let cash = Int(cashString) {
                // Int로 변환 성공
                return cash
            } else {
                print("Keychain에서 데이터를 불러왔으나 변환 실패")
                return 0
            }
        } else {
            print("Keychain에서 데이터를 불러오는 데 실패: \(status)")
            return 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
