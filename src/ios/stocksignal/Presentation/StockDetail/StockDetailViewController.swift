//
//  StockDetailViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 9/5/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

fileprivate enum Section {
    case chart
    case button
    case selected
    case news
    case analysis
    case aipredict
    case autotrade
}

fileprivate enum Item: Hashable {
    case chart(PeriodPrice)
    case predChart(PredictData)
    case button
}

fileprivate struct PredictData: Hashable {
    let data: PeriodPrice
    let predData: [Int]
}

final class StockDetailViewController: UIViewController {
    let stockName: String
    let currentPrice: Int
    let quantity: Int
    
    private let viewModel = StockDetailViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let disposeBag = DisposeBag()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.isScrollEnabled = false
        collectionView.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: ChartCollectionViewCell.id)
        collectionView.register(StockDetailButtonCollectionViewCell.self, forCellWithReuseIdentifier: StockDetailButtonCollectionViewCell.id)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.id)
        collectionView.register(AnalysisCollectionViewCell.self, forCellWithReuseIdentifier: AnalysisCollectionViewCell.id)
        collectionView.register(AIPredictCollectionViewCell.self, forCellWithReuseIdentifier: AIPredictCollectionViewCell.id)
        return collectionView
    } ()
    
    let header = StockDetailHeaderCollectionViewCell()
    
    let newsButtonTrigger = PublishSubject<Void>()
    let analysisButtonTrigger = PublishSubject<Void>()
    let aipredictButtonTrigger = PublishSubject<Void>()
    let autotradeButtonTrigger = PublishSubject<Void>()
    
    let aipredictShowTrigger = PublishSubject<Void>()
    
    var isButtonBind = false
    
    let scrollView = UIScrollView()
    let selectedSectionViewController: SelectedSectionViewController
    let buySellButtonView = BuySellButtonView()
    
    init(stockName:String, earningRate:Float, currentPrice:Int,ImageUrl: String, quantity:Int) {
        self.stockName = stockName
        self.currentPrice = currentPrice
        self.quantity = quantity
        
        header.configure(title: stockName, earningRate: earningRate, currentPrice: currentPrice, ImageUrl: ImageUrl)
        
        self.selectedSectionViewController = SelectedSectionViewController(header: header, stockName: stockName, earningRate: earningRate, currentPrice: currentPrice, imgUrl: ImageUrl, newsButtonTrigger: newsButtonTrigger, analysisButtonTrigger: analysisButtonTrigger, aipredictButtonTrigger: aipredictButtonTrigger, autotradeButtonTrigger: autotradeButtonTrigger)
        
        
        super.init(nibName: nil, bundle: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupContentView()
        setupChildViewController()
        
        bindViewModel()
        bindView()
        setDataSource()
        
        setUI()
        setButton()
    }
    
    private func setUI() {
        self.view.addSubview(buySellButtonView)
        
        buySellButtonView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func setupScrollView() {
        self.view.addSubview(scrollView)
            
        scrollView.backgroundColor = UIColor.background
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
        
    private func setupContentView() {
        self.scrollView.addSubview(header)
        self.scrollView.addSubview(collectionView)
        
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(160)
        }
        
        collectionView.backgroundColor = UIColor.background
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.top.equalTo(header.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(330)
        }
    }
        
    private func setupChildViewController() {
        addChild(selectedSectionViewController)
        scrollView.addSubview(selectedSectionViewController.view)
        selectedSectionViewController.view.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading).offset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(scrollView.snp.bottom)
            make.height.equalTo(500)
        }
        
        //selectedViewController.didMove(toParent: self)
    }
    
    private func bindViewModel() {
        let input = StockDetailViewModel.Input(stockName: self.stockName, aipredictTrigger: aipredictShowTrigger)
        let output = viewModel.transform(input: input)
        
        output.stockItem.bind {[weak self] stockItem in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

            let chart = Item.chart(stockItem)
            let chartSection = Section.chart
            snapshot.appendSections([chartSection])
            snapshot.appendItems([chart], toSection: chartSection)
            
            let button = Item.button
            let buttonSection = Section.button
            snapshot.appendSections([buttonSection])
            snapshot.appendItems([button], toSection: buttonSection)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.predItem.bind {[weak self] item in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let chart = Item.predChart(PredictData(data: item.stockItem.data, predData: item.predItems))
            let chartSection = Section.chart
            snapshot.appendSections([chartSection])
            snapshot.appendItems([chart], toSection: chartSection)
            
            let button = Item.button
            let buttonSection = Section.button
            snapshot.appendSections([buttonSection])
            snapshot.appendItems([button], toSection: buttonSection)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
    }
    
    private func bindView() {
       
    }
    
    private func setButton() {
        buySellButtonView.instantButton.rx.tap.bind {[weak self] in
            let viewController = InstantModalViewController(currentPrice: self!.currentPrice, stockName: self!.stockName, quantity: self!.quantity ,viewModel: self!.viewModel)
            
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            
            self?.present(viewController, animated: true)
        }.disposed(by: disposeBag)
        
        buySellButtonView.askingButton.rx.tap.bind {[weak self] in
            let viewController = SelectTradeModalViewController(currentPrice: self!.currentPrice, stockName: self!.stockName, quantity: self!.quantity, viewModel: self!.viewModel)
            
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
            }
            
            self?.present(viewController, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .chart:
                return self?.createChartSection()
            case .button:
                return self?.createButtonSection()
            case .news:
                return self?.createSelectedSection()
            case .analysis:
                return self?.createSelectedSection()
            case .aipredict:
                return self?.createSelectedSection()
            case .autotrade:
                return self?.createSelectedSection()
            default:
                return self?.createSelectedSection()
            }
        }, configuration: config)
    }

    private func createChartSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 30, bottom: 10, trailing: 30)
        return section
    }
    
    private func createButtonSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 30, bottom: 0, trailing: 30)
        return section
    }
    
    private func createSelectedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 30, bottom: 0, trailing: 30)
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .chart(let itemData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.id, for: indexPath) as? ChartCollectionViewCell
                cell?.configure(items: itemData.periodPrice, page: "info")
                return cell
            case .predChart(let itemData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.id, for: indexPath) as? ChartCollectionViewCell
                cell?.predict(data: itemData.data.periodPrice, predData: itemData.predData)
                return cell
            case .button:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockDetailButtonCollectionViewCell.id, for: indexPath) as? StockDetailButtonCollectionViewCell
                
                if (self.isButtonBind == false) {
                    cell?.newsButton.rx.tap.bind {[weak self] in
                        cell?.buttonSelect(index: 0)
                        self?.newsButtonTrigger.onNext(())
                    }.disposed(by: self.disposeBag)
                    cell?.analysisButton.rx.tap.bind {[weak self] in
                        cell?.buttonSelect(index: 1)
                        self?.analysisButtonTrigger.onNext(())
                    }.disposed(by: self.disposeBag)
                    cell?.aipredictButton.rx.tap.bind {[weak self] in
                        cell?.buttonSelect(index: 2)
                        self?.aipredictButtonTrigger.onNext(())
                        let viewController = AIPredictModalViewContoller()
                        viewController.modalPresentationStyle = .overFullScreen
                        self?.present(viewController, animated: false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak viewController, weak self] in
                            viewController?.dismiss(animated: false)
                            self?.aipredictShowTrigger.onNext(())
                        }
                    }.disposed(by: self.disposeBag)
                    cell?.autotradeButton.rx.tap.bind {[weak self] in
                        cell?.buttonSelect(index: 3)
                        self?.autotradeButtonTrigger.onNext(())
                    }.disposed(by: self.disposeBag)
                    self.isButtonBind = true
                }
                return cell
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
