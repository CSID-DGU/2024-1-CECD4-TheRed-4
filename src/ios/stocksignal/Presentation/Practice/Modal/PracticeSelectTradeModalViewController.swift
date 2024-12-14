//
//  PracticeSelectTradeModalViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/25/24.
//

import Foundation
import UIKit
import RxSwift

class PracticeSelectTradeModalViewController: UIViewController {
    static let id = "PracticeSelectTradeModalViewController"
    
    private let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
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
        label.text = "현재가"
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
    
    private let askingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let askingBuyLabel: UILabel = {
        let label = UILabel()
        label.text = "구매 가능 개수"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    } ()
    
    private let askingSellLabel: UILabel = {
        let label = UILabel()
        label.text = "판매 가능 개수"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    } ()
    
    private let askingTopLabel: UILabel = {
        let label = UILabel()
        label.text = "상한가"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .customRed
        return label
    } ()
    
    private let askingBottomLabel: UILabel = {
        let label = UILabel()
        label.text = "하한가"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .customBlue
        return label
    } ()
    
    private let askingScrollView = UIScrollView()
    
    let label1 = AskingPriceViewCell()
    let label2 = AskingPriceViewCell()
    let label3 = AskingPriceViewCell()
    let label4 = AskingPriceViewCell()
    let label5 = AskingPriceViewCell()
    let label6 = AskingPriceViewCell()
    let label7 = AskingPriceViewCell()
    let label8 = AskingPriceViewCell()
    let label9 = AskingPriceViewCell()
    let label10 = AskingPriceViewCell()
    let label11 = AskingPriceViewCell()
    let label12 = AskingPriceViewCell()
    let label13 = AskingPriceViewCell()
    let label14 = AskingPriceViewCell()
    let label15 = AskingPriceViewCell()
    let label16 = AskingPriceViewCell()
    let label17 = AskingPriceViewCell()
    let label18 = AskingPriceViewCell()
    let label19 = AskingPriceViewCell()
    let label20 = AskingPriceViewCell()
    let label21 = AskingPriceViewCell()
    
    
    private func setLabel() {
        
        askingScrollView.addSubview(label1)
        askingScrollView.addSubview(label2)
        askingScrollView.addSubview(label3)
        askingScrollView.addSubview(label4)
        askingScrollView.addSubview(label5)
        askingScrollView.addSubview(label6)
        askingScrollView.addSubview(label7)
        askingScrollView.addSubview(label8)
        askingScrollView.addSubview(label9)
        askingScrollView.addSubview(label10)
        askingScrollView.addSubview(label11)
        askingScrollView.addSubview(label12)
        askingScrollView.addSubview(label13)
        askingScrollView.addSubview(label14)
        askingScrollView.addSubview(label15)
        askingScrollView.addSubview(label16)
        askingScrollView.addSubview(label17)
        askingScrollView.addSubview(label18)
        askingScrollView.addSubview(label19)
        askingScrollView.addSubview(label20)
        askingScrollView.addSubview(label21)
        
        label1.configure(buy: "10000", price: String(self.currentPrice + 1000), sell: "")
        label1.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label2.configure(buy: "10000", price: String(self.currentPrice + 900), sell: "")
        label2.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label1.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label3.configure(buy: "10000", price: String(self.currentPrice + 800), sell: "")
        label3.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label2.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label4.configure(buy: "10000", price: String(self.currentPrice + 700), sell: "")
        label4.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label3.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label5.configure(buy: "10000", price: String(self.currentPrice + 600), sell: "")
        label5.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label4.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label6.configure(buy: "10000", price: String(self.currentPrice + 500), sell: "")
        label6.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label5.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label7.configure(buy: "10000", price: String(self.currentPrice + 400), sell: "")
        label7.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label6.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label8.configure(buy: "10000", price: String(self.currentPrice + 300), sell: "")
        label8.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label7.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label9.configure(buy: "10000", price: String(self.currentPrice + 200), sell: "")
        label9.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label8.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label10.configure(buy: "10000", price: String(self.currentPrice + 100), sell: "")
        label10.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label9.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label11.configure(buy: "", price: String(self.currentPrice), sell: "")
        label11.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label10.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label12.configure(buy: "", price: String(self.currentPrice - 100), sell: "10000")
        label12.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label11.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label13.configure(buy: "", price: String(self.currentPrice - 200), sell: "10000")
        label13.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label12.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label14.configure(buy: "", price: String(self.currentPrice - 300), sell: "10000")
        label14.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label13.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label15.configure(buy: "", price: String(self.currentPrice - 400), sell: "10000")
        label15.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label14.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label16.configure(buy: "", price: String(self.currentPrice - 500), sell: "10000")
        label16.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label15.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label17.configure(buy: "", price: String(self.currentPrice - 600), sell: "10000")
        label17.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label16.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label18.configure(buy: "", price: String(self.currentPrice - 700), sell: "10000")
        label18.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label17.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label19.configure(buy: "", price: String(self.currentPrice - 800), sell: "10000")
        label19.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label18.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label20.configure(buy: "", price: String(self.currentPrice - 900), sell: "10000")
        label20.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label19.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        label21.configure(buy: "", price: String(self.currentPrice - 1000), sell: "10000")
        label21.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(label20.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalTo(askingScrollView.snp.bottom)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        label1.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice + 1000)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice + 1000)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label2.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice + 900)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice + 900)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label3.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice + 800)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice + 800)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label4.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice + 700)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice + 700)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label5.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice + 600)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice + 600)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label6.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice + 500)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice + 500)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label7.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice + 400)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice + 400)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label8.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice + 300)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice + 300)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label9.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice + 200)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice + 200)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label10.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice + 100)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice + 100)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label11.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label12.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice - 100)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice - 100)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label13.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice - 200)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice - 200)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label14.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice - 300)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice - 300)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label15.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice - 400)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice - 400)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label16.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice - 500)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice - 500)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label17.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice - 600)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice - 600)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label18.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice - 700)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice - 700)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label19.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice - 800)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice - 800)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label20.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice - 900)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice - 900)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
        
        label21.rx.tap.bind {[weak self] in
            self?.trade(price: self!.currentPrice - 1000)
            //self?.currentPriceLabel.text = (formatter.string(from: NSNumber(value: self!.currentPrice - 1000)) ?? "0") + " 원"
        }.disposed(by: disposeBag)
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(colorView)
        
        colorView.addSubview(priceView)
        //colorView.addSubview(quantityView)
        colorView.addSubview(askingView)
        
        priceView.addSubview(priceTitleLabel)
        priceView.addSubview(currentPriceLabel)
        
//        quantityView.addSubview(quantityTitleLabel)
//        quantityView.addSubview(quantityInput)
//        quantityView.addSubview(availableQuantityLabel)
        
        askingView.addSubview(askingBuyLabel)
        askingView.addSubview(askingSellLabel)
        askingView.addSubview(askingTopLabel)
        askingView.addSubview(askingBottomLabel)
        askingView.addSubview(askingScrollView)
        
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        priceView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(100)
        }
        
//        quantityView.snp.makeConstraints { make in
//            make.top.equalTo(priceView.snp.bottom).offset(15)
//            make.leading.equalToSuperview().offset(25)
//            make.trailing.equalToSuperview().offset(-25)
//            make.height.equalTo(120)
//        }
        
        askingView.snp.makeConstraints { make in
            make.top.equalTo(priceView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(550)
        }
        
        priceTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        currentPriceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
//        quantityTitleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(10)
//            make.leading.equalToSuperview().offset(10)
//        }
//        
//        quantityInput.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.centerX.equalToSuperview()
//        }
//        
//        availableQuantityLabel.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().offset(-10)
//            make.leading.equalToSuperview().offset(10)
//        }
        
        askingBuyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        askingSellLabel.snp.makeConstraints { make in
            make.top.equalTo(askingBuyLabel.snp.top)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }

        askingTopLabel.snp.makeConstraints { make in
            make.top.equalTo(askingBuyLabel.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        askingBottomLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        askingScrollView.snp.makeConstraints { make in
            make.top.equalTo(askingTopLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.bottom.equalTo(askingBottomLabel.snp.top).offset(-10)
            make.centerY.equalToSuperview()
            
        }
        
    }
    
    override func viewDidLoad() {
        
        setUI()
        bindViewModel()
        setButton()
        setLabel()
    }
    
    private let disposeBag = DisposeBag()
    private var viewModel = PracticeViewModel()
    
    private let currentPrice: Int
    private var buySellIndex: Int = 1
    
    init(currentPrice: Int, viewModel: PracticeViewModel) {
        self.currentPrice = currentPrice
        self.viewModel = viewModel
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        currentPriceLabel.text = (formatter.string(from: NSNumber(value: currentPrice)) ?? "0") + " 원"
        super.init(nibName: nil, bundle: nil)
    }
    
    private func setButton() {
        
    
    }
    
    private func bindViewModel() {

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func trade(price:Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let viewController = PracticeInstantModalViewController(currentPrice: price, viewModel: self.viewModel)
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        viewController.onDismiss = {[weak self] in
            let temp = "구매가능 " + (formatter.string(from: NSNumber(value: self!.viewModel.accountCash)) ?? "0") + "원 / 최대 " + (formatter.string(from: NSNumber(value: self!.viewModel.accountCash / self!.currentPrice)) ?? "0") + "주"
            self?.availableQuantityLabel.text = temp
        }
        
        self.present(viewController, animated: true)
    }
}
