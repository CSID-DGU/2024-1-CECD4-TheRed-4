//
//  NewScenarioCoverViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 10/31/24.
//

import UIKit
import SnapKit
import RxSwift

fileprivate enum Section {
    case Condition
}

fileprivate enum Item: Hashable {
    case condition(Condition)
}

class NewScenarioCoverViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    private let viewModel = NewScenarioViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let disposeBag = DisposeBag()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.isScrollEnabled = false
        collectionView.register(NewScenarioCoverCollectionViewCell.self, forCellWithReuseIdentifier: NewScenarioCoverCollectionViewCell.id)
        return collectionView
    } ()

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
        label.text = "시나리오"
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
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    } ()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
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
    
    private let addConditionTrigger = PublishSubject<Void>()
    private let deleteCondition1Trigger = PublishSubject<Void>()
    private let deleteCondition2Trigger = PublishSubject<Void>()
    private let deleteTrScenarioigger = PublishSubject<Void>()
    
    private let scenarioID: Int?
    private let scenarioName: String
    private let stockName: String
    private let earningRate: Float
    private let currentPrice: Int
    private let imageUrl: String
    private let tradeQuantity:Int
    
    private let quantity: Int?
    private let avgPrice: Int?
    private let totalEarnRate: Float?
    
    init(scenarioID:Int?, scenarioName:String, stockName: String, earningRate: Float, currentPrice:Int, imageUrl: String, tradeQuantity: Int, quantity: Int?, avgPrice: Int?, totalEarnRate: Float?) {
        self.scenarioID = scenarioID
        self.scenarioName = scenarioName
        self.titleLabel.text = scenarioName
        self.stockName = stockName
        self.earningRate = earningRate
        self.currentPrice = currentPrice
        self.imageUrl = imageUrl
        self.tradeQuantity = tradeQuantity
        
        self.quantity = quantity
        self.avgPrice = avgPrice
        self.totalEarnRate = totalEarnRate
        
        self.stockNameLabel.text = scenarioName
        
        if (self.quantity != nil)
        {
            self.quantityLabel.text = String(self.quantity!)
        }
        
        if (self.avgPrice != nil)
        {
            self.priceLabel.text = String(self.avgPrice!)
            self.rateLabel.text = String(Float(currentPrice - avgPrice!) / Float(avgPrice!) * 100)
        }
        
        if (self.totalEarnRate != nil)
        {
            self.rateLabel.text = String(self.totalEarnRate!)
        }
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
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
        conditionBox.addSubview(collectionView)
        
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
            make.leading.equalTo(stockNameTextLabel.snp.trailing).offset(40)
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(conditionTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(260)
        }
        
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
    
    override func viewDidLoad() {
        
        header.configure(title: self.stockName, earningRate: 0, currentPrice:self.currentPrice, ImageUrl:self.imageUrl)
        
        setUI()
        setDataSource()
        bindViewModel()
        setButton()
    }
    
    private func bindViewModel() {
        let output = viewModel.getInit(stockName: self.stockName, scenarioID: self.scenarioID)
        
        output.observeOn(MainScheduler.instance).bind {[weak self] item in
            self?.chart.configure(items: item.chart.data.periodPrice, page: "scenario")
            
            if (item.conditions != nil) {
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                
                let item = item.conditions!.data.map{ Item.condition($0)}
                let selectedSection = Section.Condition
                snapshot.appendSections([selectedSection])
                snapshot.appendItems(item, toSection: selectedSection)
                self?.dataSource?.apply(snapshot)
            }
        }.disposed(by: disposeBag)
    }
    
    private func setButton() {
        addButton.rx.tap.bind {[weak self] in
            //guard let self = self else { return }
            let viewController = NewScenarioViewController(scenarioId: self?.scenarioID, scenarioName: self!.scenarioName, stockName: self!.stockName, currentPrice: self!.currentPrice, quantity: self!.tradeQuantity)
            self?.navigationController?.pushViewController(viewController, animated: true)
            
  
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self?.addConditionTrigger.onNext(())
            }
        }.disposed(by: self.disposeBag)
        
        deleteButton.rx.tap.bind {[weak self] in
            let viewController = ScenarioDeletePopupViewController(scenarioName: self!.scenarioName)
            viewController.modalPresentationStyle = .overFullScreen
            self?.present(viewController, animated: false)
            
            viewController.noButton.rx.tap.bind {[weak viewController] in
                viewController?.dismiss(animated: false)
            }.disposed(by: self!.disposeBag)
            
            viewController.yesButton.rx.tap.bind {[weak viewController] in
                let out = self?.viewModel.deleteScenario(scenarioId: self!.scenarioID!)
                
                out?.observeOn(MainScheduler.instance).bind { out in
                    if (out.code == "200"){
                        
                        viewController?.dismiss(animated: false)
                        let viewController = IsDeletedScenarioViewController()
                        viewController.modalPresentationStyle = .overFullScreen
                        self?.present(viewController, animated: false)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak viewController, weak self] in
                            viewController?.dismiss(animated: false) {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                    
                }.disposed(by: self!.disposeBag)
                
            }.disposed(by: self!.disposeBag)
        }.disposed(by: self.disposeBag)
        
        adaptButton.rx.tap.bind {[weak self] in
            let viewController = AdaptModalViewController()
            viewController.modalPresentationStyle = .overFullScreen
            self?.present(viewController, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak viewController, weak self] in
                viewController?.dismiss(animated: false) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .Condition:
                return self?.createScenarioSection()
            default:
                return self?.createScenarioSection()
            }
        }, configuration: config)
    }
    
    private func createScenarioSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 10, bottom: 0, trailing: 10)
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .condition(let itemData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewScenarioCoverCollectionViewCell.id, for: indexPath) as? NewScenarioCoverCollectionViewCell
                cell?.configure(item: itemData)
                cell?.conditionDeleteButton.rx.tap.bind {
                    let viewController = ConditionDeleteModalViewController(scenarioName: self.scenarioName, condition: itemData.buysellType, conditionID: itemData.conditionId, viewModel: self.viewModel)
                    viewController.modalPresentationStyle = .overFullScreen
                    self.present(viewController, animated: false)
                }.disposed(by: self.disposeBag)
                return cell
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
