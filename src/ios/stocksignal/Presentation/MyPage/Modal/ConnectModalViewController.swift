//
//  ConnectModalViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/12/24.
//

import Foundation
import UIKit
import RxSwift

class ConnectModalViewController: UIViewController {
    static let id = "ConnectModalViewController"
    
    private let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "한국투자증권 연동하기"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    let appKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 앱 키"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    let appKeyInput: UITextField = {
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
    
    let secretKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "시크릿 키"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    let secretKeyInput: UITextField = {
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
    
    let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "계좌번호"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    let accountInput: UITextField = {
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
    
    public let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("연동하기", for: .normal)
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
        box.addSubview(appKeyLabel)
        box.addSubview(appKeyInput)
        box.addSubview(secretKeyLabel)
        box.addSubview(secretKeyInput)
        box.addSubview(accountLabel)
        box.addSubview(accountInput)
        box.addSubview(cancelButton)
        box.addSubview(confirmButton)
        
        box.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(290)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        appKeyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        appKeyInput.snp.makeConstraints { make in
            make.centerY.equalTo(appKeyLabel.snp.centerY)
            make.leading.equalTo(appKeyLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        secretKeyLabel.snp.makeConstraints { make in
            make.top.equalTo(appKeyLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        secretKeyInput.snp.makeConstraints { make in
            make.centerY.equalTo(secretKeyLabel.snp.centerY)
            make.leading.equalTo(appKeyLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(secretKeyLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        accountInput.snp.makeConstraints { make in
            make.centerY.equalTo(accountLabel.snp.centerY)
            make.leading.equalTo(appKeyLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(accountLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(45)
            make.height.equalTo(40)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.top)
            make.trailing.equalToSuperview().offset(-45)
            make.height.equalTo(40)
            make.width.equalToSuperview().dividedBy(3)
        }
    }
    
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    private let canChange = false
    
    private let confirmTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        setUI()
        bindViewModel()
        setButton()
    }
    
    private func bindViewModel() {

        let input = MyPageViewModel.ConnectInput(confirmTrigger: confirmTrigger)
        
        let output = viewModel.Connect(triggers: input)
        
        output.confirmResult.observeOn(MainScheduler.instance).bind {[weak self] result in
            if (result.code == "200")
            {
                let viewController = ConnectSuccessModalViewController()
                viewController.modalPresentationStyle = .overFullScreen
                self?.present(viewController, animated: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak viewController, weak self] in
                    viewController?.dismiss(animated: false) {
                        self?.dismiss(animated: false)
                    }
                }
            }
            else
            {
                let viewController = ConnectFailureModalViewController()
                viewController.modalPresentationStyle = .overFullScreen
                self?.present(viewController, animated: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak viewController, weak self] in
                    viewController?.dismiss(animated: false) {
                        self?.dismiss(animated: false)
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func setButton() {
        
        cancelButton.rx.tap.bind {[weak self] _ in
            self?.dismiss(animated: false) {
                self?.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: disposeBag)
        
        confirmButton.rx.tap.bind {[weak self] _ in
            self?.viewModel.appKey = self?.appKeyInput.text ?? ""
            self?.viewModel.secretKey = self?.secretKeyInput.text ?? ""
            self?.viewModel.account = self?.accountInput.text ?? ""
            self?.confirmTrigger.onNext(())
        }.disposed(by: disposeBag)
    }
    
}
