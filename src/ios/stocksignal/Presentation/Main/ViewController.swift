//
//  ViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 8/22/24.
//

import UIKit
import SnapKit
import RxSwift

class ViewController: UITabBarController {
    
    private let topbarView = TopBarView()
    private let disposeBag = DisposeBag()
    
    private let homeViewController = HomeViewController()
    private let searchViewController = SearchViewController()
    
    private let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindView()
        changeViewController()
        setTabBar()
        setAttribute()
        
        self.selectedIndex = 1
        
    }
        
    private func setUI() {
        view.backgroundColor = .white
        
        self.view.addSubview(topbarView)
        
        topbarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func bindView() {
        topbarView.chatbotButton.rx.tap.bind{[weak self] in
            let viewController = PracticeMainViewController()
            self?.navigationController?.pushViewController(viewController, animated: true)
        }.disposed(by: disposeBag)
        
        topbarView.alarmButton.rx.tap.bind{[weak self] in
            
            let navigationController = UINavigationController()
            let viewController = AlarmViewController()
            navigationController.viewControllers = [viewController]
            self?.present(navigationController, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func changeViewController() {
        homeViewController.myStockTrigger.subscribe(onNext: {
            let viewController = MyStockViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }).disposed(by: disposeBag)
        
        homeViewController.stockDetailTrigger.subscribe(onNext: { [weak self] stock in
            let rate = Float(stock.currentPrice - stock.avgPrice) / Float(stock.avgPrice) * 100
            let viewController = StockDetailViewController(stockName: stock.stockName, earningRate: rate, currentPrice: stock.currentPrice, ImageUrl: stock.logoImage, quantity: stock.quantity)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }).disposed(by: disposeBag)
        
        searchViewController.searchTrigger.subscribe(onNext: {
            let name = self.searchViewController.viewModel.stockName
            
            let output = self.searchViewController.viewModel.searching(stockName: nil)
            
            output
                .observeOn(MainScheduler.instance)
                .bind { out in
                    let viewController = StockDetailViewController(stockName: name, earningRate: Float(0), currentPrice:out.price.data.currentPrice, ImageUrl: out.logo.data.logoImage, quantity: 0)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }.disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        searchViewController.stockDetailTrigger.subscribe(onNext: {[weak self] stockName in         
            let output = self?.searchViewController.viewModel.searching(stockName: stockName)
        
            output?
                .observeOn(MainScheduler.instance)
                .bind { out in
                    let viewController = StockDetailViewController(stockName: stockName, earningRate: Float(0), currentPrice: out.price.data.currentPrice, ImageUrl: out.logo.data.logoImage, quantity: 0)
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }.disposed(by: self!.disposeBag)
        }).disposed(by: disposeBag)
    }
    
    public func changeViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setTabBar() {
        let appearanceTabBar = UITabBarAppearance()
        appearanceTabBar.configureWithOpaqueBackground()
        appearanceTabBar.backgroundColor = .white
        tabBar.standardAppearance = appearanceTabBar
        tabBar.tintColor = UIColor.customBlue
        tabBar.backgroundColor = .white
    }

    private func setAttribute() {
        viewControllers = [
            createNavigationController(for: searchViewController, title: "검색", image: UIImage(named: "search")!, selectedImage: UIImage(named: "search")!),
            createNavigationController(for: homeViewController, title: "홈", image: UIImage(named: "home")!, selectedImage: UIImage(named: "home")!),
            createNavigationController(for: MyPageViewController(), title: "마이페이지", image: UIImage(named: "mypage")!, selectedImage: UIImage(named: "mypage")!)
        ]
    }
    
    fileprivate func createNavigationController(for rootViewController: UIViewController, title: String?, image: UIImage, selectedImage: UIImage) -> UIViewController {
            let navigationController = UINavigationController(rootViewController:  rootViewController)
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.backgroundColor = .white
            navigationController.tabBarItem.title = title
            navigationController.tabBarItem.image = image
            navigationController.tabBarItem.selectedImage = selectedImage
            return navigationController
        }
}

