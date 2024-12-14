//
//  NewsCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/6/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class NewsCollectionViewCell: UICollectionViewCell {
    static let id = "NewsCollectionViewCell"

    private let news: UILabel = {
        let label = UILabel()
        let text = ""
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        label.attributedText = attributedString
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(news)
        
        news.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
    }
    
    public func configure(newsItem: News) {
        if let data = newsItem.title.data(using: .utf8) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
            
            if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                    let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                    mutableAttributedString.addAttributes([
                        .font: UIFont.systemFont(ofSize: 16) // 폰트 지정
                    ], range: NSRange(location: 0, length: attributedString.length))

                    news.attributedText = mutableAttributedString
                    news.numberOfLines = 0
                    news.lineBreakMode = .byWordWrapping
                }
        }
        news.setNeedsLayout()
        news.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

