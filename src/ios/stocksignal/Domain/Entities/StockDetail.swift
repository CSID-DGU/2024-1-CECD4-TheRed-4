//
//  StockDetail.swift
//  stocksignal
//
//  Created by 신예빈 on 9/5/24.
//

import Foundation

struct StockDetailResponse: Decodable {
    let code: String
    let result: String
    let message: String
    let data: StockDetail
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = StockDetail()
    }
}

struct StockDetail: Decodable, Hashable {
    let openPrice: Int
    let closePrice: Int
    let tradingVolume: Int
    let lowPrice: Int
    let highPrice: Int
    let oneYearLowPrice: Int
    let oneYearHighPrice: Int
    
    enum CodingKeys: CodingKey {
        case openPrice
        case closePrice
        case tradingVolume
        case lowPrice
        case highPrice
        case oneYearLowPrice
        case oneYearHighPrice
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.openPrice = try container.decode(Int.self, forKey: .openPrice)
        self.closePrice = try container.decode(Int.self, forKey: .closePrice)
        self.tradingVolume = try container.decode(Int.self, forKey: .tradingVolume)
        self.lowPrice = try container.decode(Int.self, forKey: .lowPrice)
        self.highPrice = try container.decode(Int.self, forKey: .highPrice)
        self.oneYearLowPrice = try container.decode(Int.self, forKey: .oneYearLowPrice)
        self.oneYearHighPrice = try container.decode(Int.self, forKey: .oneYearHighPrice)
    }
    
    init() {
        self.openPrice = 0
        self.closePrice = 0
        self.tradingVolume = 0
        self.lowPrice = 0
        self.highPrice = 1
        self.oneYearLowPrice = 0
        self.oneYearHighPrice = 1
    }
    
    init(openPrice:Int, closePrice:Int, tradingVolume:Int, lowPrice:Int, highPrice:Int, oneYearLowPrice:Int, oneYearHighPrice:Int) {
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.tradingVolume = tradingVolume
        self.lowPrice = lowPrice
        self.highPrice = highPrice
        self.oneYearLowPrice = oneYearLowPrice
        self.oneYearHighPrice = oneYearHighPrice
    }
}
