//
//  AIPredictModalViewContoller.swift
//  stocksignal
//
//  Created by 신예빈 on 11/1/24.
//

import Foundation
import UIKit

class AIPredictModalViewContoller: UIViewController {
    static let id = "AIPredictModalViewContoller"
    
    private let box: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.15)
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let text = "예상 주식 그래프 생성중..."
        let attributedString = NSAttributedString(string: text,attributes: [ 
            .strokeColor: UIColor.white,          // 외곽선 색상
            .foregroundColor: UIColor.black,  // 텍스트 색상
            .strokeWidth: -2.0 ])
        
        label.attributedText = attributedString
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        return label
    } ()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        let text = "AI예측은 정확하지 않을 수 있습니다."
        let attributedString = NSAttributedString(string: text,attributes: [
            .strokeColor: UIColor.white,          // 외곽선 색상
            .foregroundColor: UIColor.black,  // 텍스트 색상
            .strokeWidth: -2.0 ])
        
        label.attributedText = attributedString
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    } ()
    
    override func viewDidLoad() {
        view.backgroundColor = .black.withAlphaComponent(0.1)
        
        self.view.addSubview(box)
        box.addSubview(titleLabel)
        box.addSubview(descLabel)
        
        box.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(30)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        var idx = 0
        _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            var tempText = "예상 주식 그래프 생성중"
            for _ in 0...(idx % 3)
            {
                tempText += "."
            }
            self.titleLabel.text = tempText
            idx += 1
        }
    }
    
}
