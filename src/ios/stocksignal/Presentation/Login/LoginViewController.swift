//
//  LoginViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/14/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import KakaoSDKUser

final class LoginViewController: UIViewController {
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "STOCK SIGNAL")
        return view
    } ()
    
    private let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao_login"), for: .normal)
        return button
    } ()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        view.addSubview(logoView)
        view.addSubview(kakaoLoginButton)
        
        logoView.snp.makeConstraints { make in
            make.width.equalTo(243)
            make.height.equalTo(115)
            make.center.equalToSuperview()
        }

        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.35)
            make.height.equalTo(45)
        }
        
        setButton()
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    private func setButton() {
        kakaoLoginButton.rx.tap.bind{[weak self] _ in
            
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk { [weak self](oauthToken, error) in
                    if let error = error {
                        print(error)
                        print("로그인에 실패했습니다. 다시 시도해주세요.")
                    } else {
                        if oauthToken != nil {
                            self?.setNickName(accessToken: oauthToken!.accessToken, refreshToken: oauthToken!.refreshToken)
                        }
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                    if let error = error {
                        print(error)
                        print("로그인에 실패했습니다. 다시 시도해주세요.")
                    } else {
                        if oauthToken != nil {
                            self?.setNickName(accessToken: oauthToken!.accessToken, refreshToken: oauthToken!.refreshToken)
                        }
                    }
                }
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func setNickName(accessToken: String, refreshToken: String) {
        let out = viewModel.login(accessToken: accessToken)
        
        out.observeOn(MainScheduler.instance).bind {out in
            let accessTokenSaveQuery: NSDictionary = [kSecClass: kSecClassKey,
                                       kSecAttrLabel: "accessToken",
                            kSecAttrApplicationLabel: "StockSignal",
                                                  kSecValueData: out.data.token.data(using: .utf8)!]
            let status = SecItemAdd(accessTokenSaveQuery, nil)
            
            switch status {
                case errSecSuccess:
                    print("성공")
                case errSecDuplicateItem:
                    print("실패")
                    let previousQuery: NSDictionary = [kSecClass: kSecClassKey,
                                                        kSecAttrLabel: "accessToken"]
                    let updateQuery: NSDictionary = [kSecValueData: out.data.token.data(using: .utf8)!]
                    let state = SecItemUpdate(previousQuery, updateQuery)
                    switch state {
                        case errSecSuccess:
                            print("update 성공")
                        default:
                            print("실패")
                        }
                    default:
                        print("KeyChain 등록 실패")
                    }
    
            let refreshTokenSaveQuery: NSDictionary = [kSecClass: kSecClassKey,
                                                  kSecAttrLabel: "refreshToken",
                                       kSecAttrApplicationLabel: "StockSignal",
                                                   kSecValueData: refreshToken.data(using: .utf8)!]
            SecItemAdd(refreshTokenSaveQuery, nil)
            
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.switchToNewWindow()
            }
            
//            let viewController = SetNickNameViewController()
//            viewController.modalPresentationStyle = .overFullScreen
//            self?.present(viewController, animated: false)
        }.disposed(by: disposeBag)

    }
}

