//
//  ChatbotViewController.swift
//  stocksignal
//
//  Created by 신예빈 on 9/5/24.
//

import Foundation
import UIKit
import SnapKit

final class ChatbotViewController: UIViewController {
    let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "Chatbot Page"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        self.view.addSubview(tempLabel)
        
        tempLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
