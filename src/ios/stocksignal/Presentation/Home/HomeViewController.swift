//
//  HomeViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
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
    case timeLine(String)
}

final class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let disposeBag = DisposeBag()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(StockCoverCollectionViewCell.self, forCellWithReuseIdentifier: StockCoverCollectionViewCell.id)
        collectionView.register(HomeHeaderCollectionViewCell.self, forCellWithReuseIdentifier: HomeHeaderCollectionViewCell.id)
        return collectionView
    } ()
    
    public let myStockTrigger = PublishSubject<Void>()
    public let stockDetailTrigger = PublishSubject<Stock>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        collectionView.backgroundColor = UIColor.background
    }
    
    private func bindViewModel() {
        
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.stockList.bind {[weak self] stockList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            self?.setCash(cash: stockList.data.cash, quantity: 0)
            
            let formatter_time = DateFormatter()
            formatter_time.dateFormat = "yy-MM-dd HH:mm"
            let current_time_string = formatter_time.string(from: Date())
            
            let updateTimeLine = Item.timeLine(current_time_string)
            let headerSection = Section.header
            snapshot.appendSections([headerSection])
            snapshot.appendItems([updateTimeLine], toSection: headerSection)
            
            let stockItems = stockList.data.stocks.enumerated().map { index, item in
                Item.stockInformation(item, index+1) }
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
                self?.stockDetailTrigger.onNext(content)

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
                return self?.createHeaderSection()
            case .list:
                return self?.createListSection()
            default:
                return self?.createHeaderSection()
            }
        }, configuration: config)
    }
    
    private func createHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 30, leading: 30, bottom: 0, trailing: 30)
        return section
    }
    
    private func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 25, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .timeLine(let itemData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCollectionViewCell.id, for: indexPath) as? HomeHeaderCollectionViewCell
                cell?.configure(time: itemData)
                cell?.mystockButton.rx.tap.bind {[weak self] _ in
                    self?.myStockTrigger.onNext(())
                }.disposed(by: self.disposeBag)
                return cell!
                
            case .stockInformation(let itemData, let index):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockCoverCollectionViewCell.id, for: indexPath) as? StockCoverCollectionViewCell
                cell?.configure(index: index, title: itemData.stockName, price: itemData.currentPrice, startPrice: itemData.avgPrice, ImageUrl: itemData.logoImage)
                return cell
            }
        })
    }
    
    private func setCash(cash: Int, quantity: Int) {
        // Convert Int to Data
        let cashData = "\(cash)".data(using: .utf8)!
        let quantityData = "\(quantity)".data(using: .utf8)!

        // Cash 저장 쿼리
        let cashSaveQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "cash", // Unique key for cash
            kSecAttrService: "StockSignal",
            kSecValueData: cashData
        ]

        // Cash 추가
        var status = SecItemAdd(cashSaveQuery, nil)
        
        if status == errSecDuplicateItem {
            // 이미 존재하는 경우, 업데이트
            let updateQuery: NSDictionary = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: "cash",
                kSecAttrService: "StockSignal"
            ]
            let updateAttributes: NSDictionary = [kSecValueData: cashData]
            status = SecItemUpdate(updateQuery, updateAttributes)
            
            if status == errSecSuccess {
                print("cash update 성공")
            } else {
                print("cash update 실패: \(status)")
            }
        } else if status == errSecSuccess {
            print("cash add 성공")
    
        } else {
            print("cash add 실패: \(status)")
        }

        // Quantity 저장 쿼리
        let quantitySaveQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "quantity", // Unique key for quantity
            kSecAttrService: "StockSignal",
            kSecValueData: quantityData
        ]

        // Quantity 추가
        var status2 = SecItemAdd(quantitySaveQuery, nil)

        if status2 == errSecDuplicateItem {
            // 이미 존재하는 경우, 업데이트
            let updateQuery2: NSDictionary = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: "quantity",
                kSecAttrService: "StockSignal"
            ]
            let updateAttributes2: NSDictionary = [kSecValueData: quantityData]
            status2 = SecItemUpdate(updateQuery2, updateAttributes2)
            
            if status2 == errSecSuccess {
                print("quantity update 성공")
            } else {
                print("quantity update 실패: \(status2)")
            }
        } else if status2 == errSecSuccess {
            print("quantity add 성공")
        } else {
            print("quantity add 실패: \(status2)")
        }
    }

}
