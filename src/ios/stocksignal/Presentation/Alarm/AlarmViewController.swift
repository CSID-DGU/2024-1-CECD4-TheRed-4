//
//  AlarmViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 9/5/24.
//

import Foundation
import UIKit
import SnapKit

final class AlarmViewController: UIViewController {
    let allButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.customBlue
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 0
        return button
    } ()
    
    let recentButton: UIButton = {
        let button = UIButton()
        button.setTitle("최근", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.customRed
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 0
        return button
    } ()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .background
        
        self.view.addSubview(allButton)
        self.view.addSubview(recentButton)
        
        allButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
        recentButton.snp.makeConstraints { make in
            make.top.equalTo(allButton.snp.top)
            make.leading.equalTo(allButton.snp.trailing).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
    }
}

