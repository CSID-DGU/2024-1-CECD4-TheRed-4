//
//  Date.swift
//  stocksignal
//
//  Created by 신예빈 on 11/11/24.
//

import Foundation

struct DateResponse: Decodable {
    let code: String
    let result: String
    let message: String
    let data: PeriodPrice
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = PeriodPrice()
    }
}

struct PeriodPrice: Decodable, Hashable {
    let periodPrice: [Dates]
    
    init() {
        self.periodPrice = []
    }
}

struct Dates: Decodable, Hashable {
    let date: String
    let startPrice: Int
    let closePrice: Int
    let highPrice: Int
    let lowPrice: Int
    let tradingVolume: Int
    
    private enum CodingKeys: String, CodingKey {
        case date
        case startPrice
        case closePrice
        case highPrice
        case lowPrice
        case tradingVolume
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.startPrice = try container.decode(Int.self, forKey: .startPrice)
        self.closePrice = try container.decode(Int.self, forKey: .closePrice)
        self.highPrice = try container.decode(Int.self, forKey: .highPrice)
        self.lowPrice = try container.decode(Int.self, forKey: .lowPrice)
        self.tradingVolume = try container.decode(Int.self, forKey: .tradingVolume)
    }
    
    init() {
        self.date = ""
        self.startPrice = 0
        self.closePrice = 0
        self.highPrice = 0
        self.lowPrice = 0
        self.tradingVolume = 0
    }
}

