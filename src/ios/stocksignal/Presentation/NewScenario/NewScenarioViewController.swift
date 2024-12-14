//
//  NewScenarioViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 9/10/24.
//

import UIKit
import SnapKit
import RxSwift

fileprivate enum Section {
    case BuyEarning
    case BuyPrice
    case BuyTrading
    case SellEarning
    case SellPrice
    case SellTrading
}

fileprivate enum Item: Hashable {
    case buyEarning
    case buyPrice
    case buyTrading
    case sellEarning
    case sellPrice
    case sellTrading
}


class NewScenarioViewController: UIViewController {
    
    private let viewModel = NewScenarioViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let disposeBag = DisposeBag()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.isScrollEnabled = false
        collectionView.register(NewScenarioBuyEarningCollectionViewCell.self, forCellWithReuseIdentifier: NewScenarioBuyEarningCollectionViewCell.id)
        collectionView.register(NewScenarioBuyPriceCollectionViewCell.self, forCellWithReuseIdentifier: NewScenarioBuyPriceCollectionViewCell.id)
        collectionView.register(NewScenarioBuyTradingCollectionViewCell.self, forCellWithReuseIdentifier: NewScenarioBuyTradingCollectionViewCell.id)
        collectionView.register(NewScenarioSellEarningCollectionViewCell.self, forCellWithReuseIdentifier: NewScenarioSellEarningCollectionViewCell.id)
        collectionView.register(NewScenarioSellPriceCollectionViewCell.self, forCellWithReuseIdentifier: NewScenarioSellPriceCollectionViewCell.id)
        collectionView.register(NewScenarioSellTradingCollectionViewCell.self, forCellWithReuseIdentifier: NewScenarioSellTradingCollectionViewCell.id)
        return collectionView
    } ()
    
    private let buyButtonTrigger = PublishSubject<Void>()
    private let sellButtonTrigger = PublishSubject<Void>()
    private let rateButtonTrigger = PublishSubject<Void>()
    private let priceButtonTrigger = PublishSubject<Void>()
    private let tradingButtonTrigger = PublishSubject<Void>()
    
    private let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let header = NewScenarioHeaderCollectionViewCell()
    private let buySellButton = NewScenarioButtonCollectionViewCell()
    private let standardButton = NewScenarioStandardCollectionViewCell()
    private let footer = NewScenarioFooterCollectionViewCell()
    
    private var buySellIndex = 1
    private var standardIndex = 1
    private var buttonIndex = 0
    private var footerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setDataSource()
        bindViewModel()
        setButton()
        
        setUI()
        
        buyButtonTrigger.onNext(())
        
        // UITapGestureRecognizer 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 다른 터치 이벤트도 처리되도록 설정
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true) // 현재 뷰에서 포커스를 제거하여 키보드 닫기
    }
    
    private func setUI() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(box)
        box.addSubview(header)
        box.addSubview(buySellButton)
        box.addSubview(standardButton)
        box.addSubview(collectionView)
        self.view.addSubview(footer)
        
        box.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        header.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        buySellButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(header.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        standardButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(buySellButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(standardButton.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        footer.snp.makeConstraints { make in
            make.height.equalTo(220)
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(box.snp.bottom)
            //bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).offset(0).constraint
        }
    }
    
    private let scenarioId: Int?
    private let scenarioName: String
    private let stockName: String
    private let currentPrice: Int
    private let quantity: Int
    
    
    init (scenarioId: Int?, scenarioName: String, stockName: String, currentPrice: Int, quantity: Int) {
        self.scenarioId = scenarioId
        self.scenarioName = scenarioName
        self.stockName = stockName
        self.currentPrice = currentPrice
        self.quantity = quantity
        
        header.configure(stockName: self.stockName, currentPrice: self.currentPrice, quantity: self.quantity)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private func bindViewModel() {
        let input = NewScenarioViewModel.Input(buyButtonTrigger: buyButtonTrigger, sellButtonTrigger: sellButtonTrigger, rateButtonTrigger: rateButtonTrigger, priceButtonTrigger: priceButtonTrigger, tradingButtonTrigger: tradingButtonTrigger)
        let output = viewModel.buttonSelect(input: input)
                
        output.buy.bind {[weak self] out in

            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let item = self?.selectItem(index: out)
            let section = self?.selectSection(index: out)
            snapshot.appendSections([section!])
            snapshot.appendItems([item!], toSection: section)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.sell.bind {[weak self] out in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let item = self?.selectItem(index: out)
            let section = self?.selectSection(index: out)
            snapshot.appendSections([section!])
            snapshot.appendItems([item!], toSection: section)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.rate.bind {[weak self] out in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let item = self?.selectItem(index: out)
            let section = self?.selectSection(index: out)
            snapshot.appendSections([section!])
            snapshot.appendItems([item!], toSection: section)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.price.bind {[weak self] out in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let item = self?.selectItem(index: out)
            let section = self?.selectSection(index: out)
            snapshot.appendSections([section!])
            snapshot.appendItems([item!], toSection: section)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.trading.bind {[weak self] out in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let item = self?.selectItem(index: out)
            let section = self?.selectSection(index: out)
            snapshot.appendSections([section!])
            snapshot.appendItems([item!], toSection: section)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
    }
    
    private func selectItem(index: Int) -> Item {
        switch index {
        case 0:
            return Item.buyEarning
        case 1:
            return Item.buyPrice
        case 2:
            return Item.buyTrading
        case 3:
            return Item.sellEarning
        case 4:
            return Item.sellPrice
        case 5:
            return Item.sellTrading
        default:
            return Item.buyEarning
        }
    }
    
    private func selectSection(index: Int) -> Section {
        switch index {
        case 0:
            return Section.BuyEarning
        case 1:
            return Section.BuyPrice
        case 2:
            return Section.BuyTrading
        case 3:
            return Section.SellEarning
        case 4:
            return Section.SellPrice
        case 5:
            return Section.SellTrading
        default:
            return Section.BuyEarning
        }
    }
    
    private func setButton() {
        
        buySellButton.buyButton.rx.tap.bind {[weak self] in
            self?.buttonIndex = 0
            self?.setButtonColor(buySellIndex: 1, standardIndex: 0)
            self?.buyButtonTrigger.onNext(())
        }.disposed(by: self.disposeBag)
        
        buySellButton.sellButton.rx.tap.bind {[weak self] in
            self?.buttonIndex = 0
            self?.setButtonColor(buySellIndex: 2, standardIndex: 0)
            self?.sellButtonTrigger.onNext(())
        }.disposed(by: self.disposeBag)
        
        standardButton.rateButton.rx.tap.bind {[weak self] in
            self?.buttonIndex = 0
            self?.setButtonColor(buySellIndex: 0, standardIndex: 1)
            self?.rateButtonTrigger.onNext(())
        }.disposed(by: self.disposeBag)
        
        standardButton.priceButton.rx.tap.bind {[weak self] in
            self?.buttonIndex = 0
            self?.setButtonColor(buySellIndex: 0, standardIndex: 2)
            self?.priceButtonTrigger.onNext(())
        }.disposed(by: self.disposeBag)
        
        standardButton.tradingButton.rx.tap.bind {[weak self] in
            self?.buttonIndex = 0
            self?.setButtonColor(buySellIndex: 0, standardIndex: 3)
            self?.tradingButtonTrigger.onNext(())
        }.disposed(by: self.disposeBag)
        
        footer.amountCheckButton.rx.tap.bind {[weak self] in
            self?.setFooterButton(Index: 1)
        }.disposed(by: self.disposeBag)
        
        footer.rateCheckButton.rx.tap.bind {[weak self] in
            self?.setFooterButton(Index: 2)
        }.disposed(by: self.disposeBag)
        
        footer.confirmButton.rx.tap.bind {[weak self] in
            
            if (self?.scenarioId == nil)
            {
                let out = self?.viewModel.makeScenario(scenarioName: self!.scenarioName, companyName: self!.stockName, currentPrice: self!.currentPrice, buttonIndex: self!.buttonIndex, footerIndex: self!.footerIndex)
                
                if out == nil {
                    print("nil")
                }
                out?.observeOn(MainScheduler.instance).bind { out in
                    if (out.code == "200") {
                        let viewController = AddConditionModalViewController(scenarioName: self!.scenarioName)
                        viewController.modalPresentationStyle = .overFullScreen
                        self?.present(viewController, animated: false)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak viewController, weak self] in
                            viewController?.dismiss(animated: false) {
                                self?.navigationController?.popViewController(animated: true)
                                self?.navigationController?.popViewController(animated: true)
                                self?.navigationController?.dismiss(animated: false)
                            }
                        }
                    }
                }.disposed(by: self!.disposeBag)
            }
            else {
                let out = self?.viewModel.addCondition(scenarioId: self!.scenarioId!, currentPrice: self!.currentPrice, buttonIndex: self!.buttonIndex, footerIndex: self!.footerIndex)
                
                if out == nil {
                    print("nil")
                }
                out?.observeOn(MainScheduler.instance).bind { out in
                    if (out.code == "200") {
                        let viewController = AddConditionModalViewController(scenarioName: self!.scenarioName)
                        viewController.modalPresentationStyle = .overFullScreen
                        self?.present(viewController, animated: false)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak viewController, weak self] in
                            viewController?.dismiss(animated: false) {
                                self?.navigationController?.popViewController(animated: true)
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }.disposed(by: self!.disposeBag)
            }

        }.disposed(by: self.disposeBag)
    }
    
    private func setFooterButton(Index: Int) {
        footer.setLabel(viewModel: self.viewModel)
        let bgImages = [UIImage(named: "checkBox_gray"), UIImage(named: "checkBox_blue"), UIImage(named: "checkBox_red")]
        if Index == self.footerIndex{
            self.footerIndex = 0
            self.footer.amountCheckButton.setBackgroundImage(bgImages[0], for: .normal)
            self.footer.rateCheckButton.setBackgroundImage(bgImages[0], for: .normal)
        }
        else{
            switch Index {
            case 1:
                self.footerIndex = Index
                self.footer.amountCheckButton.setBackgroundImage(bgImages[self.buySellIndex], for: .normal)
                self.footer.rateCheckButton.setBackgroundImage(bgImages[0], for: .normal)
            case 2:
                self.footerIndex = Index
                self.footer.amountCheckButton.setBackgroundImage(bgImages[0], for: .normal)
                self.footer.rateCheckButton.setBackgroundImage(bgImages[self.buySellIndex], for: .normal)
            default : break
            }
        }
    }
    
    private func setButtonColor(buySellIndex:Int, standardIndex:Int) {
        let bgColors = [UIColor.white, UIColor.customBlue, UIColor.customRed]
        let bgImages = [UIImage(named: "checkBox_gray"), UIImage(named: "checkBox_blue"), UIImage(named: "checkBox_red")]
        
        switch buySellIndex {
        case 1:
            self.buySellIndex = buySellIndex
            self.buySellButton.buyButton.backgroundColor = .customBlue
            self.buySellButton.buyButton.setTitleColor(.white, for: .normal)
            self.buySellButton.sellButton.backgroundColor = .white
            self.buySellButton.sellButton.setTitleColor(.black, for: .normal)
        case 2:
            self.buySellIndex = buySellIndex
            self.buySellButton.buyButton.backgroundColor = .white
            self.buySellButton.buyButton.setTitleColor(.black, for: .normal)
            self.buySellButton.sellButton.backgroundColor = .customRed
            self.buySellButton.sellButton.setTitleColor(.white, for: .normal)
        default: break
        }
        
        switch standardIndex {
        case 1:
            self.standardIndex = standardIndex
            self.standardButton.rateButton.backgroundColor = bgColors[self.buySellIndex]
            self.standardButton.priceButton.backgroundColor = bgColors[0]
            self.standardButton.tradingButton.backgroundColor = bgColors[0]
            self.standardButton.rateButton.setTitleColor(.white, for: .normal)
            self.standardButton.priceButton.setTitleColor(.customBlack, for: .normal)
            self.standardButton.tradingButton.setTitleColor(.customBlack, for: .normal)
        case 2:
            self.standardIndex = standardIndex
            self.standardButton.rateButton.backgroundColor = bgColors[0]
            self.standardButton.priceButton.backgroundColor = bgColors[self.buySellIndex]
            self.standardButton.tradingButton.backgroundColor = bgColors[0]
            self.standardButton.rateButton.setTitleColor(.customBlack, for: .normal)
            self.standardButton.priceButton.setTitleColor(.white, for: .normal)
            self.standardButton.tradingButton.setTitleColor(.customBlack, for: .normal)
        case 3:
            self.standardIndex = standardIndex
            self.standardButton.rateButton.backgroundColor = bgColors[0]
            self.standardButton.priceButton.backgroundColor = bgColors[0]
            self.standardButton.tradingButton.backgroundColor = bgColors[self.buySellIndex]
            self.standardButton.rateButton.setTitleColor(.customBlack, for: .normal)
            self.standardButton.priceButton.setTitleColor(.customBlack, for: .normal)
            self.standardButton.tradingButton.setTitleColor(.white, for: .normal)
        default:
            switch self.standardIndex {
            case 1:
                self.standardButton.rateButton.backgroundColor = bgColors[self.buySellIndex]
            case 2:
                self.standardButton.priceButton.backgroundColor = bgColors[self.buySellIndex]
            case 3:
                self.standardButton.tradingButton.backgroundColor = bgColors[self.buySellIndex]
            default: break
            }
        }
        
        switch self.footerIndex {
        case 1:
            self.footer.amountCheckButton.setBackgroundImage(bgImages[self.buySellIndex], for: .normal)
        case 2:
            self.footer.rateCheckButton.setBackgroundImage(bgImages[self.buySellIndex], for: .normal)
        default: break
        }
    }
    
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .BuyEarning, .SellEarning:
                return self?.createEarningSection()
            case .BuyPrice, .SellPrice:
                return self?.createPriceSection()
            case .BuyTrading, .SellTrading:
                return self?.createTradingSection()
            default:
                return self?.createEarningSection()
            }
        }, configuration: config)
    }
    
    private func createEarningSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 10, bottom: 0, trailing: 10)
        return section
    }
    
    private func createPriceSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 10, bottom: 0, trailing: 10)
        return section
    }
    
    private func createTradingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 10, bottom: 0, trailing: 10)
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .buyEarning:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewScenarioBuyEarningCollectionViewCell.id, for: indexPath) as? NewScenarioBuyEarningCollectionViewCell
                cell?.upCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_blue"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    self.buttonIndex = 1
                }.disposed(by: self.disposeBag)
                cell?.downCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_blue"), for: .normal)
                    self.buttonIndex = 2
                }.disposed(by: self.disposeBag)
                cell?.setLabel(currentPrice: self.currentPrice, viewModel: self.viewModel)
                return cell
            case .buyPrice:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewScenarioBuyPriceCollectionViewCell.id, for: indexPath) as? NewScenarioBuyPriceCollectionViewCell
                cell?.upCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_blue"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    self.buttonIndex = 1
                }.disposed(by: self.disposeBag)
                cell?.downCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_blue"), for: .normal)
                    self.buttonIndex = 2
                }.disposed(by: self.disposeBag)
                cell?.setLabel(viewModel: self.viewModel)
                return cell
            case .buyTrading:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewScenarioBuyTradingCollectionViewCell.id, for: indexPath) as? NewScenarioBuyTradingCollectionViewCell
                cell?.upCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_blue"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    self.buttonIndex = 1
                }.disposed(by: self.disposeBag)
                cell?.downCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_blue"), for: .normal)
                    self.buttonIndex = 2
                }.disposed(by: self.disposeBag)
                cell?.setLabel(currentPrice: self.currentPrice, viewModel: self.viewModel)
                return cell
            case .sellEarning:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewScenarioSellEarningCollectionViewCell.id, for: indexPath) as? NewScenarioSellEarningCollectionViewCell
                cell?.upCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_red"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    self.buttonIndex = 1
                }.disposed(by: self.disposeBag)
                cell?.downCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_red"), for: .normal)
                    self.buttonIndex = 2
                }.disposed(by: self.disposeBag)
                cell?.setLabel(currentPrice: self.currentPrice, viewModel: self.viewModel)
                return cell
            case .sellPrice:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewScenarioSellPriceCollectionViewCell.id, for: indexPath) as? NewScenarioSellPriceCollectionViewCell
                cell?.upCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_red"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    self.buttonIndex = 1
                }.disposed(by: self.disposeBag)
                cell?.downCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_red"), for: .normal)
                    self.buttonIndex = 2
                }.disposed(by: self.disposeBag)
                cell?.setLabel(viewModel: self.viewModel)
                return cell
            case .sellTrading:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewScenarioSellTradingCollectionViewCell.id, for: indexPath) as? NewScenarioSellTradingCollectionViewCell
                cell?.upCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_red"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    self.buttonIndex = 1
                }.disposed(by: self.disposeBag)
                cell?.downCheckButton.rx.tap.bind {_ in
                    cell?.upCheckButton.setBackgroundImage(UIImage(named: "checkBox_gray"), for: .normal)
                    cell?.downCheckButton.setBackgroundImage(UIImage(named: "checkBox_red"), for: .normal)
                    self.buttonIndex = 2
                }.disposed(by: self.disposeBag)
                cell?.setLabel(currentPrice: self.currentPrice, viewModel: self.viewModel)
                return cell
            }
        })
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
