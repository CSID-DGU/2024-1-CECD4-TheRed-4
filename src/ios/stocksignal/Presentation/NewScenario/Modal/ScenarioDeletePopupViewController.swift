//
//  ScenarioDeletePopupViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 10/31/24.
//

import Foundation
import UIKit

class ScenarioDeletePopupViewController: UIViewController {
    static let id = "ScenarioDeletePopupViewController"
    
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
        label.text = "시나리오를 삭제할까요?"
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
    
    override func viewDidLoad() {
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
    
    init(scenarioName: String) {
        titleLabel.text = scenarioName + " 시나리오"
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
