//
//  TradeCompleteModalViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 11/25/24.
//

import Foundation
import UIKit

class TradeCompleteModalViewController: UIViewController {
    static let id = "TradeCompleteModalViewController"
    
    private let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    } ()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    } ()
    
    override func viewDidLoad() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        
        self.view.addSubview(box)
        box.addSubview(titleLabel)
        box.addSubview(descLabel)
        
        box.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    init(type: String, condition: String) {
        titleLabel.text = type
        descLabel.text = condition
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
