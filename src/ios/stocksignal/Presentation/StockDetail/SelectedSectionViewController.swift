//
//  SelectedViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 9/7/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

fileprivate enum Section {
    case selected
    case autotradingHeader
    case autotrading
    case autotradingButton
}

fileprivate enum Item: Hashable {
    case news(News)
    case analysis(StockDetail)
    case aipredict
    
    case autotradingHeader(String)
    case autotrading(Scenario)
    case autotradingButton
}

final class SelectedSectionViewController: UIViewController, UINavigationControllerDelegate {
    let stockName: String
    
    private let viewModel = StockDetailViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let disposeBag = DisposeBag()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.isScrollEnabled = false
        collectionView.register(StockDetailButtonCollectionViewCell.self, forCellWithReuseIdentifier: StockDetailButtonCollectionViewCell.id)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.id)
        collectionView.register(AnalysisCollectionViewCell.self, forCellWithReuseIdentifier: AnalysisCollectionViewCell.id)
        collectionView.register(AIPredictCollectionViewCell.self, forCellWithReuseIdentifier: AIPredictCollectionViewCell.id)
        collectionView.register(AutoTradeSelectHeaderCollectionViewCell.self, forCellWithReuseIdentifier: AutoTradeSelectHeaderCollectionViewCell.id)
        collectionView.register(AutoTradeSelectCollectionViewCell.self, forCellWithReuseIdentifier: AutoTradeSelectCollectionViewCell.id)
        collectionView.register(AutoTradeSelectButtonCollectionViewCell.self, forCellWithReuseIdentifier: AutoTradeSelectButtonCollectionViewCell.id)
        return collectionView
    } ()
    
    let newsButtonTrigger: PublishSubject<Void>
    let analysisButtonTrigger: PublishSubject<Void>
    let aipredictButtonTrigger: PublishSubject<Void>
    let autotradeButtonTrigger: PublishSubject<Void>
    let header: StockDetailHeaderCollectionViewCell
    
    let earningRate: Float
    let currentPrice: Int
    let imgUrl: String
    var tradeQuantity: Int = 0
    
    init(header: StockDetailHeaderCollectionViewCell,  stockName: String, earningRate: Float, currentPrice:Int, imgUrl:String, newsButtonTrigger:PublishSubject<Void>, analysisButtonTrigger:PublishSubject<Void>, aipredictButtonTrigger:PublishSubject<Void>, autotradeButtonTrigger:PublishSubject<Void>) {
        self.header = header
        self.stockName = stockName
        self.earningRate = earningRate
        self.currentPrice = currentPrice
        self.imgUrl = imgUrl
        self.newsButtonTrigger = newsButtonTrigger
        self.analysisButtonTrigger = analysisButtonTrigger
        self.aipredictButtonTrigger = aipredictButtonTrigger
        self.autotradeButtonTrigger = autotradeButtonTrigger
        
        super.init(nibName: nil, bundle: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindViewModel()
        bindView()
        setDataSource()
        analysisButtonTrigger.onNext(())

    }
    
    private func setUI() {
        self.view.addSubview(collectionView)
        
        self.view.backgroundColor = .white
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //collectionView.backgroundColor = UIColor.background
    }
    
    private func bindViewModel() {
        
        let input = StockDetailViewModel.PageChangeInput(stockName: stockName, newsTrigger: newsButtonTrigger, analysisTrigger: analysisButtonTrigger, aipredictTrigger: aipredictButtonTrigger, autotradeTrigger: autotradeButtonTrigger)
        let output = viewModel.pageSelect(input: input)
        
        output.news.bind {[weak self] news in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let selectedSection = Section.selected
            snapshot.appendSections([selectedSection])
            let item = news.data.map{ Item.news($0)}
            snapshot.appendItems(item, toSection: selectedSection)
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.analysis.observeOn(MainScheduler.instance).bind {[weak self] analysis in
            
            self?.header.setRate(openPrice: analysis.data.openPrice)
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let item = Item.analysis(analysis.data)
            let selectedSection = Section.selected
            snapshot.appendSections([selectedSection])
            snapshot.appendItems([item], toSection: selectedSection)
            self?.dataSource?.apply(snapshot)
        
        }.disposed(by: disposeBag)
        
        output.aipredict.bind {[weak self] aipredict in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let item = Item.aipredict
            let selectedSection = Section.selected
            snapshot.appendSections([selectedSection])
            snapshot.appendItems([item], toSection: selectedSection)
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.autotrading.bind {[weak self] autotrading in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            let autotradingHeaderSection = Section.autotradingHeader
            let autotradingSection = Section.autotrading
            let autotradingButtonSection = Section.autotradingButton
            
            let header = Item.autotradingHeader(self!.stockName)
            let item = autotrading.data.map { Item.autotrading($0) }
            let button = Item.autotradingButton
            
            snapshot.appendSections([autotradingHeaderSection])
            snapshot.appendSections([autotradingSection])
            snapshot.appendSections([autotradingButtonSection])
            snapshot.appendItems([header], toSection: autotradingHeaderSection)
            snapshot.appendItems(item, toSection: autotradingSection)
            snapshot.appendItems([button], toSection: autotradingButtonSection)
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
    }
    
    private func bindView() {

        collectionView.rx.itemSelected.bind {[weak self] indexPath in
            let item = self?.dataSource?.itemIdentifier(for: indexPath)
            
            switch item {
            case .autotrading(let content):
                let viewController = NewScenarioCoverViewController(scenarioID:content.scenarioId, scenarioName: content.scenarioName, stockName: content.companyName, earningRate: self!.earningRate, currentPrice: self!.currentPrice, imageUrl: self!.imgUrl, tradeQuantity: self!.tradeQuantity, quantity: nil, avgPrice: content.initialPrice, totalEarnRate: nil)
                self?.navigationController?.pushViewController(viewController, animated: true)
            default:
                print("default")
            }
        }.disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .selected:
                return self?.createSelectedSection()
            case .autotradingHeader:
                return self?.createAutotradingHeaderSection()
            case .autotrading:
                return self?.createAutotradingSection()
            case .autotradingButton:
                return self?.createAutotradingButtonSection()
            default:
                return self?.createSelectedSection()
            }
        }, configuration: config)
    }
    
    private func createSelectedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 30, bottom: 0, trailing: 30)
        return section
    }
    
    private func createAutotradingHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 10, bottom: 0, trailing: 10)
        return section
    }
    
    private func createAutotradingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        return section
    }
    
    private func createAutotradingButtonSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 30, bottom: 0, trailing: 30)
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .news(let content):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.id, for: indexPath) as? NewsCollectionViewCell
                cell?.configure(newsItem: content)
                return cell
            case .analysis(let content):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnalysisCollectionViewCell.id, for: indexPath) as? AnalysisCollectionViewCell
                cell?.configure(stockName: self.stockName, currentPrice: self.currentPrice, stockDetail: content)
                self.tradeQuantity = content.tradingVolume
                return cell
            case .aipredict:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AIPredictCollectionViewCell.id, for: indexPath) as? AIPredictCollectionViewCell
                return cell
            case .autotradingHeader(let title):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AutoTradeSelectHeaderCollectionViewCell.id, for: indexPath) as? AutoTradeSelectHeaderCollectionViewCell
                cell?.configure(title: title)
                cell?.plusButton.rx.tap.bind {
                    let viewController = ScenarioNameModalViewController(stockName: self.stockName, earningRate: self.earningRate, currentPrice: self.currentPrice, imageUrl: self.imgUrl, tradeQuantity: self.tradeQuantity)
                    
                    viewController.onDismiss = {
                        print("ggggggg")
                        self.autotradeButtonTrigger.onNext(())
                    }
                    
                    let navigationController = UINavigationController(rootViewController: viewController)
                    navigationController.modalPresentationStyle = .overFullScreen
                    navigationController.delegate = self
                    
                    self.present(navigationController, animated: false)
                }.disposed(by: self.disposeBag)
                return cell
            case .autotrading(let scenario):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AutoTradeSelectCollectionViewCell.id, for: indexPath) as? AutoTradeSelectCollectionViewCell
                var rate = Float(scenario.currentPrice - scenario.initialPrice) / Float(scenario.initialPrice) * 100
                if scenario.currentPrice == 0 {
                    rate = 0
                }
                cell?.configure(condition: scenario.scenarioName, rate: rate)
                return cell
            case .autotradingButton:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AutoTradeSelectButtonCollectionViewCell.id, for: indexPath) as? AutoTradeSelectButtonCollectionViewCell
                return cell
            }
        })
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.isEmpty {
            // Navigation Controller가 닫혔을 때
            print("Navigation Controller dismissed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

