//
//  AddConditionModalViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 10/31/24.
//

import Foundation
import UIKit

class AddConditionModalViewController: UIViewController {
    static let id = "AddConditionModalViewController"
    
    private let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = " 시나리오"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "조건을 추가했습니다."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    } ()
    
    public let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("돌아가기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.white
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    init(scenarioName: String) {
        
        titleLabel.text = scenarioName + " 시나리오"
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        
        self.view.addSubview(box)
        box.addSubview(titleLabel)
        box.addSubview(descLabel)
//        box.addSubview(closeButton)
        
        box.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(140)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
//        closeButton.snp.makeConstraints { make in
//            make.top.equalTo(descLabel.snp.bottom).offset(30)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(35)
//            make.width.equalToSuperview().dividedBy(2.25)
//        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
