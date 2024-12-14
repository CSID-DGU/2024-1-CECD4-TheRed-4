//
//  SetNickNameViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/20/24.
//

import Foundation
import UIKit
import RxSwift

class SetNickNameViewController: UIViewController {
    static let id = "SetNickNameViewController"
    
    private let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 설정하기"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    let nicknameInput: UITextField = {
        let textField = UITextField(frame: CGRect())
        
        textField.textColor = .black
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.backgroundColor = .white
        
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        return textField
    } ()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    let canChangeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let changeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("설정하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.customBlue
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        return button
    } ()
    
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        
        self.view.addSubview(box)
        box.addSubview(titleLabel)
        box.addSubview(nicknameInput)
        box.addSubview(confirmButton)
        box.addSubview(canChangeLabel)
        box.addSubview(changeButton)
        
        box.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(240)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        nicknameInput.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(confirmButton.snp.leading).offset(-20)
            make.height.equalTo(30)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameInput)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(55)
            make.height.equalTo(30)
        }
        
        canChangeLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameInput.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        changeButton.snp.makeConstraints { make in
            make.top.equalTo(canChangeLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().dividedBy(3)
        }
    }
    
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    private let canChange = false
    
    private let confirmTrigger = PublishSubject<Void>()
    private let changeTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        setUI()
        bindViewModel()
        setButton()
    }
    
    private func bindViewModel() {

        let input = MyPageViewModel.NickNameChangeInput(confirmTrigger: confirmTrigger, changeTrigger: changeTrigger)
        
        let output = viewModel.NickNameChange(triggers: input)
        
        output.confirmResult.bind {[weak self] result in
            if (result.code == "200")
            {
                DispatchQueue.main.async {
                    self?.canChangeLabel.text = "사용 가능합니다!"
                    self?.canChangeLabel.textColor = .customBlue
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self?.canChangeLabel.text = "이미 사용중인 닉네임입니다!"
                    self?.canChangeLabel.textColor = .customRed
                }
            }
        }.disposed(by: disposeBag)
        
        output.changeResult.observeOn(MainScheduler.instance).bind {[weak self] result in
            if (result.code == "200")
            {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.switchToNewWindow()
                }
            }
            else
            {
                let viewController = EditFailureModalViewController()
                viewController.modalPresentationStyle = .overFullScreen
                self?.present(viewController, animated: false)
            }
        }.disposed(by: disposeBag)
    }
    
    private func setButton() {
        confirmButton.rx.tap.bind {[weak self] _ in
            self?.viewModel.nickname = self?.nicknameInput.text ?? ""
            self?.confirmTrigger.onNext(())
        }.disposed(by: disposeBag)
        
        changeButton.rx.tap.bind {[weak self] _ in
            self?.changeTrigger.onNext(())
            
            
        }.disposed(by: disposeBag)
    }
}
