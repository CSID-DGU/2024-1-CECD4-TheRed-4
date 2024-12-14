//
//  SearchViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import SwiftUI

fileprivate enum Section {
    case RankItem
}

fileprivate enum Item: Hashable {
    case rankItem(Rank)
}

final class SearchViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인기 검색어 TOP 10"
        return label
    } ()
    
    let tempView: UIView = {
        let view = UIView()
        return view
    } ()
    
    let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    } ()
    
    let searchInput: UITextField = {
        let textField = UITextField(frame: CGRect())
        textField.placeholder = "관심있는 주식 종목을 검색하세요"
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.backgroundColor = .background
        
        return textField
    } ()
    
    let searchButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "search")?.withTintColor(.customBlue)
        button.setImage(image, for: .normal)
        return button
    } ()
        
    private func setUI() {
        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(searchView)
        self.view.addSubview(searchInput)
        self.view.addSubview(tempView)
        self.view.addSubview(searchButton)
        tempView.addSubview(titleLabel)
        tempView.addSubview(collectionView)
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(searchInput.snp.top)
            make.bottom.equalTo(searchInput.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalTo(searchInput.snp.leading)
        }
        
        searchInput.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(0)
            make.height.equalTo(60)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        tempView.snp.makeConstraints { make in
            make.top.equalTo(searchInput.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    public let viewModel = SearchViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let disposeBag = DisposeBag()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.isScrollEnabled = false
        collectionView.register(RankItemCollectionViewCell.self, forCellWithReuseIdentifier: RankItemCollectionViewCell.id)
        return collectionView
    } ()
    
    public let searchTrigger = PublishSubject<Void>()
    public let stockDetailTrigger = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        
        setUI()
        bindViewModel()
        bindView()
        setButton()
    }
    
    private func bindView() {

        collectionView.rx.itemSelected.bind {[weak self] indexPath in
            let item = self?.dataSource?.itemIdentifier(for: indexPath)
            switch item {
            case .rankItem(let content):
                self?.stockDetailTrigger.onNext(content.companyName)
            default:
                print("default")
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = SearchViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.rank.bind {[weak self] rank in

            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let item = rank.data.map { Item.rankItem($0) }
            let section = Section.RankItem
            snapshot.appendSections([section])
            snapshot.appendItems(item, toSection: section)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
    }
    
    private func setButton() {
        searchButton.rx.tap.bind {
            self.viewModel.stockName = self.searchInput.text!
            self.searchTrigger.onNext(())
        }.disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .RankItem:
                return self?.createRankSection()
            default:
                return self?.createRankSection()
            }
        }, configuration: config)
    }
    
    private func createRankSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 10, bottom: 0, trailing: 10)
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .rankItem(let content):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankItemCollectionViewCell.id, for: indexPath) as? RankItemCollectionViewCell
                cell?.configure(index: content.rank, companyName: content.companyName)
                
                return cell
            }
        })
    }
    
}
