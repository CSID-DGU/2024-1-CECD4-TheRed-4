//
//  MypageViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

final class MyPageViewController: UIViewController {
    
    let uiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "님"
        label.textAlignment = NSTextAlignment.center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    } ()
    
    let nicknameChangeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "edit"), for: .normal)
        return button
    } ()
    
    let connectButton: UIButton = {
        let button = UIButton()
        button.setTitle("한국투자증권 연동하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor.customBlue
        button.layer.cornerRadius = 5
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 6, height: 6)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = false
        
        return button
    } ()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원정보 수정하기", for: .normal)
        button.setTitleColor(.customBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor.background
        button.layer.cornerRadius = 5
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 6, height: 6)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = false

        return button
    } ()
    
    let withdrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 108/255, green: 108/255, blue: 108/255, alpha: 1)
        return button
    } ()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor.customRed
        return button
    } ()
    
    private func setUI() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(uiView)
        
        uiView.addSubview(titleLabel)
        //uiView.addSubview(nicknameChangeButton)
        uiView.addSubview(connectButton)
        uiView.addSubview(editButton)
        uiView.addSubview(withdrawButton)
        uiView.addSubview(logoutButton)

        uiView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(150)
            make.bottom.equalToSuperview().offset(-250)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            
        }
        
//        nicknameChangeButton.snp.makeConstraints { make in
//            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
//            make.centerY.equalTo(titleLabel.snp.centerY)
//        }
        
        
        connectButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(60)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(connectButton.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(60)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(158)
            make.height.equalTo(60)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(40)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(158)
            make.height.equalTo(60)
        }
    }
    
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setButton()
        bindViewModel()
    }
    
    private func setButton() {
        connectButton.rx.tap.bind {[weak self] _ in
            let viewController = ConnectModalViewController()
            viewController.modalPresentationStyle = .overFullScreen
            self?.present(viewController, animated: false)
        }.disposed(by: self.disposeBag)
        
        editButton.rx.tap.bind {[weak self] _ in
            let viewController = NickNameEditModalViewController()
            viewController.modalPresentationStyle = .overFullScreen
            self?.present(viewController, animated: false)
        }.disposed(by: self.disposeBag)
    }
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input()
        
        let out = viewModel.transform(input: input)
        
        out.nickname.bind {[weak self] nickname in
            DispatchQueue.main.async {
                self?.titleLabel.text = nickname.data.nickname + " 님"
            }
        }.disposed(by: disposeBag)
    
    }
}
