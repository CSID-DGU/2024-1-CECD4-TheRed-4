//
//  MyStockViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 9/6/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

fileprivate enum Section {
    case header
    case list
}

fileprivate enum Item: Hashable {
    case stockInformation(Stock, Int)
    case myStockInformation(MyStockInformation)
}

fileprivate struct MyStockInformation: Hashable {
    let timeLine: String
    let balance: Int
    let totalStockPL: Int
    let cash: Int
}

final class MyStockViewController: UIViewController {
    let viewModel = HomeViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let disposeBag = DisposeBag()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(StockCoverCollectionViewCell.self, forCellWithReuseIdentifier: StockCoverCollectionViewCell.id)
        collectionView.register(MyStockHeaderCollectionViewCell.self, forCellWithReuseIdentifier: MyStockHeaderCollectionViewCell.id)
        return collectionView
    } ()
    
    public let stockDetailTrigger = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        
        setUI()
        bindViewModel()
        bindView()
        setDataSource()
    }
    
    private func setUI() {
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.myStockList.bind {[weak self] item in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let formatter_time = DateFormatter()
            formatter_time.dateFormat = "yy-MM-dd HH:mm"
            let current_time_string = formatter_time.string(from: Date())
            
            let myStockInfo = MyStockInformation(timeLine: current_time_string, balance: item.data.totalStockPrice, totalStockPL: item.data.totalStockPL, cash: item.data.cash)
            let header = Item.myStockInformation(myStockInfo)
            let headerSection = Section.header
            snapshot.appendSections([headerSection])
            snapshot.appendItems([header], toSection: headerSection)
            
            let stockItems = item.data.stocks.enumerated().map { index, i in
                Item.stockInformation(i, index+1) }
            let listSection = Section.list
            snapshot.appendSections([listSection])
            snapshot.appendItems(stockItems, toSection: listSection)
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
            
    }
    
    private func bindView() {

        collectionView.rx.itemSelected.bind {[weak self] indexPath in
            let item = self?.dataSource?.itemIdentifier(for: indexPath)
            switch item {
            case .stockInformation(let content, _):
                let rate = Float(content.currentPrice - content.avgPrice) / Float(content.avgPrice) * 100
                let viewController = StockDetailViewController(stockName: content.stockName, earningRate: rate, currentPrice: content.currentPrice, ImageUrl: content.logoImage, quantity: content.quantity)
                self?.navigationController?.pushViewController(viewController, animated: true)
            default:
                print("default")
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .header:
                return self?.createMyStockHeaderSection()
            case .list:
                return self?.createListSection()
            default:
                return self?.createMyStockHeaderSection()
            }
        }, configuration: config)
    }

    private func createMyStockHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 30, bottom: 0, trailing: 30)
        return section
    }
    
    private func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 25, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 25, leading: 30, bottom: 0, trailing: 30)
        
        
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .stockInformation(let itemData, let index):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockCoverCollectionViewCell.id, for: indexPath) as? StockCoverCollectionViewCell
                cell?.configure(index: index, title: itemData.stockName, price: itemData.currentPrice, startPrice: itemData.avgPrice, ImageUrl: itemData.logoImage)
                return cell
            
            case .myStockInformation(let itemData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyStockHeaderCollectionViewCell.id, for: indexPath) as? MyStockHeaderCollectionViewCell
                cell?.configure(time: itemData.timeLine, balance: itemData.balance, PL: itemData.totalStockPL, cash: itemData.cash)
                
                return cell
            }
        })
    }
}
