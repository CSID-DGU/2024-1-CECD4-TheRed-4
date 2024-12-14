//
//  ConditionDeleteModalViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/13/24.
//

import Foundation
import UIKit
import RxSwift

class ConditionDeleteModalViewController: UIViewController {
    static let id = "ConditionDeleteModalViewController"
    
    private let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "시나리오"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "조건을 삭제할까요?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    } ()
    
    public let noButton: UIButton = {
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
    
    public let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.customRed
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        return button
    } ()
    
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        
        self.view.addSubview(box)
        box.addSubview(titleLabel)
        box.addSubview(descLabel)
        box.addSubview(noButton)
        box.addSubview(yesButton)
        
        box.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        noButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(35)
            make.width.equalToSuperview().dividedBy(2.25)
        }
        
        yesButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(30)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(35)
            make.width.equalToSuperview().dividedBy(2.25)
        }
    }
    
    override func viewDidLoad() {
        setUI()
        setButton()
    }
    
    private let disposeBag = DisposeBag()
    
    private let scenarioName: String
    private let condition: String
    
    private let conditionID: Int
    private let viewmodel: NewScenarioViewModel
    
    init(scenarioName: String, condition: String, conditionID: Int, viewModel: NewScenarioViewModel) {
        titleLabel.text = scenarioName + " 시나리오"
        descLabel.text = condition + " 조건을 삭제할까요?"
        
        self.scenarioName = scenarioName
        self.condition = condition
        
        self.conditionID = conditionID
        self.viewmodel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private func setButton() {
        noButton.rx.tap.bind {[weak self] _ in
            self?.dismiss(animated: false)
        }.disposed(by: disposeBag)
        
        yesButton.rx.tap.bind {[weak self] _ in
            let out = self?.viewmodel.deleteCondition(conditionId: self!.conditionID)
            
            out?.observeOn(MainScheduler.instance).bind {[weak self] out in
                if (out.code == "200")
                {
                    let viewController = IsDeletedConditionModalViewController(scenarioName: self!.scenarioName, condition: self!.condition)
                    viewController.modalPresentationStyle = .overFullScreen
                
                    self?.present(viewController, animated: false)
        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak viewController] in
                        viewController?.dismiss(animated: false)
                    }
                }
            }.disposed(by: self!.disposeBag)
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
