//
//  PracticeMainViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/24/24.
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
    case practice
    case analysis(StockDetail)
    case aipredict
    
    case autotradingHeader(String)
    case autotrading(Scenario)
    case autotradingButton
}

final class PracticeMainViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    } ()
    
    private let header = StockDetailHeaderCollectionViewCell()
    private let chart = ChartCollectionViewCell()
    
    private let button = PracticeButtonCollectionViewCell()
    
    private let tradeButton = BuySellButtonView()
    
    private func setUI() {
        self.view.backgroundColor = .background
        self.view.addSubview(scrollView)
        self.view.addSubview(tradeButton)
        
        scrollView.backgroundColor = .background
        
        scrollView.addSubview(headerView)
        scrollView.addSubview(button)
        scrollView.addSubview(collectionView)
        
        headerView.addSubview(header)
        headerView.addSubview(chart)
        
        tradeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(400)
            make.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(45)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.height.equalTo(400)
        }
        
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        chart.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(225)
        }
    }
    
    override func viewDidLoad() {
        setDataSource()
        setUI()
        
        setButton()
        bindViewModel()
        
        practiceButtonTrigger.onNext(())

        viewModel.transform(input: "삼성전자").observeOn(MainScheduler.instance).bind {[weak self] out in
            self?.chart.practiceConfigure(items: Array(out.data.periodPrice[51...99]))
            self?.currentPrice = out.data.periodPrice[51].closePrice
            self?.viewModel.currentPrice = self!.currentPrice
            self?.viewModel.openPrice = self!.currentPrice
            self?.header.practiceConfigure(title: "연습모드", earningRate: 0, currentPrice: self!.currentPrice)
        }.disposed(by: disposeBag)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private let viewModel = PracticeViewModel()
    private let stockDetailViewModel = StockDetailViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let disposeBag = DisposeBag()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.isScrollEnabled = false
        collectionView.register(PracticeCollectionViewCell.self, forCellWithReuseIdentifier: PracticeCollectionViewCell.id)
        collectionView.register(AnalysisCollectionViewCell.self, forCellWithReuseIdentifier: AnalysisCollectionViewCell.id)
        collectionView.register(AIPredictCollectionViewCell.self, forCellWithReuseIdentifier: AIPredictCollectionViewCell.id)
        collectionView.register(AutoTradeSelectHeaderCollectionViewCell.self, forCellWithReuseIdentifier: AutoTradeSelectHeaderCollectionViewCell.id)
        collectionView.register(AutoTradeSelectCollectionViewCell.self, forCellWithReuseIdentifier: AutoTradeSelectCollectionViewCell.id)
        collectionView.register(AutoTradeSelectButtonCollectionViewCell.self, forCellWithReuseIdentifier: AutoTradeSelectButtonCollectionViewCell.id)
        return collectionView
    } ()
    
    let practiceButtonTrigger = PublishSubject<Void>()
    let analysisButtonTrigger = PublishSubject<Void>()
    let aipredictButtonTrigger = PublishSubject<Void>()
    let autotradeButtonTrigger = PublishSubject<Void>()
    
    let nextButtonTrigger = PublishSubject<Void>()
    let continueButtonTrigger = PublishSubject<Void>()
    let stopButtonTrigger = PublishSubject<Void>()
    let endButtonTrigger = PublishSubject<Void>()
    
    let practiceUIUpdateTrigger = PublishSubject<Void>()
    
    let aipredictShowTrigger = PublishSubject<Void>()
    
    var isPracticeButtonBind = false
    var isAutoTradeButtonBind = false
    
    var timeStamp = 50
    var isContinue = false
    var currentPrice = 0
    
    private func setButton() {
        button.newsButton.rx.tap.bind {[weak self] _ in
            self?.button.buttonSelect(index: 0)
            self?.practiceButtonTrigger.onNext(())
        }.disposed(by: disposeBag)
        
        button.analysisButton.rx.tap.bind {[weak self] _ in
            self?.button.buttonSelect(index: 1)
            self?.analysisButtonTrigger.onNext(())
        }.disposed(by: disposeBag)
        
        button.aipredictButton.rx.tap.bind {[weak self] _ in
            self?.button.buttonSelect(index: 2)
            self?.aipredictButtonTrigger.onNext(())
            self?.aipredictButtonTrigger.onNext(())
            let viewController = AIPredictModalViewContoller()
            viewController.modalPresentationStyle = .overFullScreen
            self?.present(viewController, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak viewController, weak self] in
                let pred = self?.stockDetailViewModel.practicePredict(periodPrice: (self?.viewModel.periodPrice)!, timeStamp: self!.timeStamp)
                self?.chart.predict(data: self!.viewModel.getChart(index: self!.timeStamp), predData: pred!)
                viewController?.dismiss(animated: false)
                
            }
        }.disposed(by: disposeBag)
        
        button.autotradeButton.rx.tap.bind {[weak self] _ in
            self?.button.buttonSelect(index: 3)
            self?.autotradeButtonTrigger.onNext(())
        }.disposed(by: disposeBag)
        
        nextButtonTrigger.subscribe(onNext : {
            if self.timeStamp > 0 {
                self.timeStamp -= 1
                self.chart.practiceConfigure(items: self.viewModel.getChart(index: self.timeStamp))
                self.currentPrice = self.viewModel.getAnalysis(index: self.timeStamp).closePrice
                self.viewModel.step(timeStemp: self.timeStamp)
                self.header.setRateSync(currentPrice: self.currentPrice)
            }
            else {
                print("end")
            }
        }).disposed(by: disposeBag)
        
        continueButtonTrigger.subscribe(onNext : {

        }).disposed(by: disposeBag)
        
        stopButtonTrigger.subscribe(onNext : {
            self.isContinue = false
            print("stop")
        }).disposed(by: disposeBag)
        
        endButtonTrigger.subscribe(onNext : {

        }).disposed(by: disposeBag)
        
        tradeButton.instantButton.rx.tap.bind {[weak self] _ in
            let viewController = PracticeInstantModalViewController(currentPrice: self!.currentPrice, viewModel: self!.viewModel)
            
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            
            viewController.onDismiss = {[weak self] in
                self?.practiceUIUpdateTrigger.onNext(())
            }
            
            self?.present(viewController, animated: true)
        }.disposed(by: disposeBag)
        
        tradeButton.askingButton.rx.tap.bind {[weak self] _ in
            let viewController = PracticeSelectTradeModalViewController(currentPrice: self!.currentPrice, viewModel: self!.viewModel)
            
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
            }
            
            self?.present(viewController, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = PracticeViewModel.PageChangeInput(practiceTrigger: practiceButtonTrigger, analysisTrigger: analysisButtonTrigger, aipredictTrigger: aipredictButtonTrigger, autotradeTrigger: autotradeButtonTrigger)
        
        let output = viewModel.pageSelect(input: input)
        
        output.practice.bind{[weak self] _ in
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let practice = Item.practice
            let practiceSection = Section.selected
            snapshot.appendSections([practiceSection])
            snapshot.appendItems([practice], toSection: practiceSection)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.analysis.bind{[weak self] _ in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            let out = self?.viewModel.getAnalysis(index: self!.timeStamp)
            
            let analysis = Item.analysis(StockDetail(openPrice: out!.startPrice, closePrice: out!.closePrice, tradingVolume: out!.tradingVolume, lowPrice: out!.lowPrice, highPrice: out!.highPrice, oneYearLowPrice: 49900, oneYearHighPrice: 88800))

            let analysisSection = Section.selected
            snapshot.appendSections([analysisSection])
            snapshot.appendItems([analysis], toSection: analysisSection)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.aipredict.bind{[weak self] _ in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

            if let firstItem = snapshot.itemIdentifiers.first {
                snapshot.deleteItems([firstItem])
            }
            
            let aipredict = Item.aipredict
            let aipredictSection = Section.selected
            snapshot.appendSections([aipredictSection])
            snapshot.appendItems([aipredict], toSection: aipredictSection)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.autotrading.bind{[weak self] autotrading in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            if let firstItem = snapshot.itemIdentifiers.first {
                snapshot.deleteItems([firstItem])
            }
            
            let autotradingHeaderSection = Section.autotradingHeader
            let autotradingSection = Section.autotrading
            let autotradingButtonSection = Section.autotradingButton
            
            let header = Item.autotradingHeader("연습모드")
            
            var item = autotrading.data.map { Item.autotrading($0) }
            print(self?.viewModel.scenarios)
            if (self?.viewModel.scenarios.isEmpty == false) {
                item = self!.viewModel.scenarios.map { Item.autotrading($0)}
            }
            
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
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
            case .practice:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PracticeCollectionViewCell.id, for: indexPath) as? PracticeCollectionViewCell
                cell?.configure(viewModel: self.viewModel)
                
                if (self.isPracticeButtonBind == false) {
                    cell?.nextButton.rx.tap.bind {[weak self] _ in
                        self?.nextButtonTrigger.onNext(())
                    }.disposed(by: self.disposeBag)
                    
                    cell?.continueButton.rx.tap.bind {[weak self] _ in
                        self?.isContinue = true
                        while(self!.isContinue && self!.viewModel.timeStamp > 0) {
                            cell?.updateUI()
                            self?.timeStamp -= 1
                            self?.viewModel.timeStamp = self!.timeStamp
                            self?.chart.practiceConfigure(items: self!.viewModel.getChart(index: self!.timeStamp))
                            self?.currentPrice = self!.viewModel.getAnalysis(index: self!.timeStamp).closePrice
                            self?.viewModel.step(timeStemp: self!.timeStamp)
                            self?.header.setRateSync(currentPrice: self!.currentPrice)
                            RunLoop.current.run(until: Date().addingTimeInterval(Double(0.1)))
                        }
                        //self?.continueButtonTrigger.onNext(())
                    }.disposed(by: self.disposeBag)
                    
                    cell?.stopButton.rx.tap.bind {[weak self] _ in
                        self?.stopButtonTrigger.onNext(())
                    }.disposed(by: self.disposeBag)
                    
                    cell?.endButton.rx.tap.bind {[weak self] _ in
                        while(self!.viewModel.timeStamp > 0) {
                            cell?.updateUI()
                            self?.timeStamp -= 1
                            self?.viewModel.timeStamp = self!.timeStamp
                            self?.chart.practiceConfigure(items: self!.viewModel.getChart(index: self!.timeStamp))
                            self?.currentPrice = self!.viewModel.getAnalysis(index: self!.timeStamp).closePrice
                            self?.viewModel.step(timeStemp: self!.timeStamp)
                            self?.header.setRateSync(currentPrice: self!.currentPrice)
                            RunLoop.current.run(until: Date().addingTimeInterval(Double(0.1)))
                        }
                        //self?.endButtonTrigger.onNext(())
                    }.disposed(by: self.disposeBag)
                    
                    self.practiceUIUpdateTrigger.subscribe(onNext: {
                        cell?.updateUI()
                    }).disposed(by: self.disposeBag)
                    self.isPracticeButtonBind = true
                }
                return cell
            case .analysis(let content):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnalysisCollectionViewCell.id, for: indexPath) as? AnalysisCollectionViewCell
                cell?.configure(stockName: String(50 - self.timeStamp) + " / 50", currentPrice: content.closePrice, stockDetail: content)
                return cell
            case .aipredict:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AIPredictCollectionViewCell.id, for: indexPath) as? AIPredictCollectionViewCell
                return cell
            case .autotradingHeader(let title):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AutoTradeSelectHeaderCollectionViewCell.id, for: indexPath) as? AutoTradeSelectHeaderCollectionViewCell
                cell?.configure(title: title)
                
                if (self.isAutoTradeButtonBind == false) {
                    cell?.plusButton.rx.tap.bind {
                        let viewController = PracticeNewScenarioCoverViewController(viewModel: self.viewModel)
                        
                        viewController.onDismiss = {
                            self.autotradeButtonTrigger.onNext(())
                        }
                        
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }.disposed(by: self.disposeBag)
                    self.isAutoTradeButtonBind = true
                }
                return cell
            case .autotrading(let scenario):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AutoTradeSelectCollectionViewCell.id, for: indexPath) as? AutoTradeSelectCollectionViewCell
                let rate = Float(scenario.currentPrice - scenario.initialPrice) / Float(scenario.initialPrice) * 100
                cell?.configure(condition: scenario.scenarioName, rate: rate)
                return cell
            case .autotradingButton:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AutoTradeSelectButtonCollectionViewCell.id, for: indexPath) as? AutoTradeSelectButtonCollectionViewCell
                return cell
            }
        })
    }
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
