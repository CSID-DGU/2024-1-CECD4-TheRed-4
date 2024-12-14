//
//  News.swift
//  stocksignal
//
//  Created by 신예빈 on 11/10/24.
//

import Foundation

struct NewsResponse: Decodable {
    let code: String
    let result: String
    let message: String
    let data: [News]
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = []
    }
}

struct News: Decodable, Hashable {
    let title: String
    let url: String
    let pubDate: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case url
        case pubDate
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.pubDate = try container.decode(String.self, forKey: .pubDate)
    }
    
    init() {
        self.title = ""
        self.url = ""
        self.pubDate = ""
    }
}

