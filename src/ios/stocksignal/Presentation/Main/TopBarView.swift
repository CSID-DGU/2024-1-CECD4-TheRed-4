//
//  TopBarView.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
//

import Foundation
import UIKit
import SnapKit

final class TopBarView: UIView {
    let logoImage: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logo"), for: .normal)
        return button
    }()
    
    let chatbotButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chatbot"), for: .normal)
        return button
    }()
    
    let alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "alarm"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(logoImage)
        self.addSubview(chatbotButton)
        self.addSubview(alarmButton)
        
        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        alarmButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        chatbotButton.snp.makeConstraints { make in
            make.trailing.equalTo(alarmButton).offset(-35)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
