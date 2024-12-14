//
//  IntroViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/20/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import KakaoSDKUser

final class IntroViewController: UIViewController {
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "STOCK SIGNAL")
        return view
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        view.addSubview(logoView)
        
        logoView.snp.makeConstraints { make in
            make.width.equalTo(243)
            make.height.equalTo(115)
            make.center.equalToSuperview()
        }
        
        test()
        
        //autoLogin()
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    private var accessToken: String = ""
    
    private func test() {
        let item = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsIm5pY2tuYW1lIjoi7ZmN7JuQ7KSAIiwiaWF0IjoxNzMxMDU0NzczLCJleHAiOjE3MzQ2NTQ3NzN9.gWoR45M4tTpwx1gyk8oiZqUQfvw3aHuaqDxXdKqilDs"
        
        
        let accessTokenSaveQuery: NSDictionary = [kSecClass: kSecClassKey,
                                   kSecAttrLabel: "accessToken",
                        kSecAttrApplicationLabel: "StockSignal",
                                              kSecValueData: item.data(using: .utf8)!]
        let status = SecItemAdd(accessTokenSaveQuery, nil)
        
        switch status {
        case errSecSuccess:
            print("add 성공")
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.switchToNewWindow()
            }
        default:
            print("실패")
            let previousQuery: NSDictionary = [kSecClass: kSecClassKey,
                                                kSecAttrLabel: "accessToken"]
            let updateQuery: NSDictionary = [kSecValueData: item.data(using: .utf8)!]
            let state = SecItemUpdate(previousQuery, updateQuery)
        
            switch state {
            case errSecSuccess:
                print("update 성공")
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.switchToNewWindow()
                }
            default:
                print("실패")
            }
        }
    }
    
    
    
    private func autoLogin() {
//        let deleteQuery: NSDictionary = [kSecClass: kSecClassKey,
//                                     kSecAttrLabel: "accessToken",
//                              kSecReturnAttributes: true,
//                                    kSecReturnData: true]
//        
//        let result = SecItemDelete(deleteQuery)
        
        
        let searchQuery: NSDictionary = [kSecClass: kSecClassKey,
                                     kSecAttrLabel: "accessToken",
                              kSecReturnAttributes: true,
                                    kSecReturnData: true]
        var searchedResult: CFTypeRef?
        let searchStatus = SecItemCopyMatching(searchQuery, &searchedResult)
        
        if searchStatus == errSecSuccess {
            let out = viewModel.idCheck()
            
            out.observeOn(MainScheduler.instance).bind { out in
                if (out.code == "200") {
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.switchToNewWindow()
                    }
                }
                else {
                    let viewController = LoginViewController()
                    viewController.modalPresentationStyle = .overFullScreen
                    self.present(viewController, animated: false)
//                    let searchQuery2: NSDictionary = [kSecClass: kSecClassKey,
//                                                 kSecAttrLabel: "refreshToken",
//                                          kSecReturnAttributes: true,
//                                                kSecReturnData: true]
//                    var searchedResult2: CFTypeRef?
//                    let searchStatus2 = SecItemCopyMatching(searchQuery, &searchedResult2)
//                    
//                    if searchStatus2 == errSecSuccess {
//                        guard let checkedItem = searchedResult2,
//                              let token = checkedItem[kSecValueData] as? Data else { return }
//                        let data = String(data: token, encoding: String.Encoding.utf8)!
//                        
//                        let refresh = self.viewModel.refresh(refreshToken: data)
//                        
//                        refresh.observeOn(MainScheduler.instance).bind { refresh in
//                            
//                        }.disposed(by: self.disposeBag)
//                    }
//                    else {
//                        let viewController = LoginViewController()
//                        viewController.modalPresentationStyle = .overFullScreen
//                        self.present(viewController, animated: false)
//                    }
                }
            }.disposed(by: disposeBag)
            
        } else {
            let viewController = LoginViewController()
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: false)
        }
    }
}
