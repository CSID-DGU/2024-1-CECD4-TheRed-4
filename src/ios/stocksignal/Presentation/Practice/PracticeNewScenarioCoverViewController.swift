//
//  PracticeNewScenarioCoverViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/26/24.
//

import SnapKit
import RxSwift
import UIKit

fileprivate enum Section {
    case Condition
}

fileprivate enum Item: Hashable {
    case condition(Condition)
}

class PracticeNewScenarioCoverViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    private var viewModel = PracticeViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let disposeBag = DisposeBag()
//    lazy var collectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
//        collectionView.isScrollEnabled = false
//        collectionView.register(NewScenarioCoverCollectionViewCell.self, forCellWithReuseIdentifier: NewScenarioCoverCollectionViewCell.id)
//        return collectionView
//    } ()

    private let contentView: UIView = {
        let view = UIView()
        return view
    } ()
    
    private let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    } ()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "연습모드 시나리오"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .customBlue
        return label
    } ()
    
    private let header = StockDetailHeaderCollectionViewCell()
    
    private let chart = ChartCollectionViewCell()
    
    private let detailBox: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    } ()
    
    private let stockNameTextLabel: UILabel = {
        let label = UILabel()
        label.text = "조건명"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let quantityTextLabel: UILabel = {
        let label = UILabel()
        label.text = "수량"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let priceTextLabel: UILabel = {
        let label = UILabel()
        label.text = "매입가격"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let rateTextLabel: UILabel = {
        let label = UILabel()
        label.text = "수익률"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let stockNameLabel: UILabel = {
        let label = UILabel()
        label.text = "연습모드1"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let conditionBox: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    } ()
    
    private let conditionTitle: UILabel = {
        let label = UILabel()
        label.text = "매매 조건"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("  조건 추가  ", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.customRed
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    } ()
    
    private let adaptButton: UIButton = {
        let button = UIButton()
        button.setTitle("적용하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.customBlue
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    } ()
    
    private func setUI() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(box)
        box.addSubview(titleLabel)
        box.addSubview(header)
        box.addSubview(chart)
        box.addSubview(detailBox)
        detailBox.addSubview(stockNameTextLabel)
        detailBox.addSubview(quantityTextLabel)
        detailBox.addSubview(priceTextLabel)
        detailBox.addSubview(rateTextLabel)
        detailBox.addSubview(stockNameLabel)
        detailBox.addSubview(quantityLabel)
        detailBox.addSubview(priceLabel)
        detailBox.addSubview(rateLabel)
        
        contentView.addSubview(conditionBox)
        conditionBox.addSubview(conditionTitle)
        conditionBox.addSubview(addButton)
        //conditionBox.addSubview(collectionView)
        
        contentView.addSubview(deleteButton)
        contentView.addSubview(adaptButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        box.snp.makeConstraints { make in
            //make.width.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.bottom.equalTo(detailBox.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            //make.height.equalTo(600)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        header.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(150)
            make.centerX.equalToSuperview()
        }
        
        chart.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.height.equalTo(200)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        detailBox.snp.makeConstraints { make in
            make.top.equalTo(chart.snp.bottom)
            make.height.equalTo(80)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        stockNameTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        
        quantityTextLabel.snp.makeConstraints { make in
            make.top.equalTo(stockNameTextLabel.snp.top)
            make.leading.equalTo(stockNameTextLabel.snp.trailing).offset(30)
        }
        
        priceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(stockNameTextLabel.snp.top)
            make.trailing.equalTo(rateTextLabel.snp.leading).offset(-40)
        }
        
        rateTextLabel.snp.makeConstraints { make in
            make.top.equalTo(stockNameTextLabel.snp.top)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        stockNameLabel.snp.makeConstraints { make in
            make.top.equalTo(stockNameTextLabel.snp.bottom).offset(10)
            make.leading.equalTo(stockNameTextLabel.snp.leading)
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.top.equalTo(stockNameLabel.snp.top)
            make.leading.equalTo(quantityTextLabel.snp.leading)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(stockNameLabel.snp.top)
            make.leading.equalTo(priceTextLabel.snp.leading)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(stockNameLabel.snp.top)
            make.leading.equalTo(rateTextLabel.snp.leading)
        }
        
        conditionBox.snp.makeConstraints { make in
            make.top.equalTo(box.snp.bottom).offset(30)
            make.centerX.equalTo(box.snp.centerX)
            make.height.equalTo(320)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        conditionTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
//        collectionView.snp.makeConstraints { make in
//            make.top.equalTo(conditionTitle.snp.bottom).offset(20)
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.height.equalTo(260)
//        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(conditionBox.snp.bottom).offset(25)
            make.height.equalTo(40)
            make.width.equalToSuperview().dividedBy(3)
            make.leading.equalToSuperview().offset(60)
            make.bottom.equalToSuperview()
        }
        
        adaptButton.snp.makeConstraints { make in
            make.top.equalTo(conditionBox.snp.bottom).offset(25)
            make.height.equalTo(40)
            make.width.equalToSuperview().dividedBy(3)
            make.trailing.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview()
        }
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    init(viewModel: PracticeViewModel) {
        self.viewModel = viewModel
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        self.quantityLabel.text = (formatter.string(from: NSNumber(value: self.viewModel.quantity)) ?? "0")
        
        self.priceLabel.text = (formatter.string(from: NSNumber(value: self.viewModel.avgPrice)) ?? "0")
        
        let earnRate = Float(self.viewModel.accountCash + self.viewModel.quantity * self.viewModel.avgPrice - 100000000) / Float(100000000) * Float(100)
        
        self.rateLabel.text = String(format: "+%.2f%%", earnRate)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    override func viewDidLoad() {
        header.practiceConfigure(title: "연습모드", earningRate: 0, currentPrice: self.viewModel.openPrice)
        self.chart.practiceConfigure(items: Array(self.viewModel.getChart(index: self.viewModel.timeStamp)))
        self.header.setRateSync(currentPrice: self.viewModel.currentPrice)
        print(self.viewModel.currentPrice)
        print(self.viewModel.openPrice)
        setUI()
//        setDataSource()
//        bindViewModel()
        setButton()
    }
    
    private func setButton() {
        addButton.rx.tap.bind {[weak self] in
            //guard let self = self else { return }
            let viewController = PracticeNewScenarioViewController(scenarioId: nil, scenarioName: "연습모드1", stockName: "연습모드", currentPrice: self!.viewModel.currentPrice, quantity: 0, viewModel: self!.viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)

        }.disposed(by: self.disposeBag)
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
