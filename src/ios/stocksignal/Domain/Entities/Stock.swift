//
//  Stock.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
//

import Foundation

struct RankResponse: Decodable{
    let code: String
    let result: String
    let message: String
    let data: [Rank]
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = []
    }
}

struct Rank: Decodable, Hashable {
    let rank: Int
    let companyName: String
    
    private enum CodingKeys: String, CodingKey {
        case rank
        case companyName
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rank = try container.decode(Int.self, forKey: .rank)
        self.companyName = try container.decode(String.self, forKey: .companyName)
    }
    
    init() {
        self.rank = 0
        self.companyName = ""
    }
}

struct CurrentPriceResponse: Decodable{
    let code: String
    let result: String
    let message: String
    let data: CurrentPrice
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = CurrentPrice()
    }
}

struct CurrentPrice: Decodable, Hashable {
    let currentPrice: Int
    
    private enum CodingKeys: String, CodingKey {
        case currentPrice
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentPrice = try container.decode(Int.self, forKey: .currentPrice)
    }
    
    init() {
        self.currentPrice = 0
    }
}

struct LogoImageResponse: Decodable{
    let code: String
    let result: String
    let message: String
    let data: LogoImage
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = LogoImage()
    }
}

struct LogoImage: Decodable, Hashable {
    let logoImage: String
    
    private enum CodingKeys: String, CodingKey {
        case logoImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.logoImage = try container.decode(String.self, forKey: .logoImage)
    }
    
    init() {
        self.logoImage = "default_logo"
    }
}

struct CodeResponse: Decodable {
    let code: String
    let result: String
    let message: String
    let data: Code
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = Code()
    }
}

struct Code: Decodable, Hashable  {
    let companyCode: String
    
    private enum CodingKeys: String, CodingKey {
        case companyCode
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.companyCode = try container.decode(String.self, forKey: .companyCode)
    }
    
    init() {
        self.companyCode = ""
    }
}

struct Stock: Decodable, Hashable {
    let stockName: String
    let logoImage: String
    let quantity: Int
    let avgPrice: Int
    let currentPrice: Int
    let pl: Int
    
    private enum CodingKeys: String, CodingKey {
        case stockName
        case logoImage
        case quantity
        case avgPrice
        case currentPrice
        case pl
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stockName = try container.decode(String.self, forKey: .stockName)
        self.logoImage = try container.decodeIfPresent(String.self, forKey: .logoImage) ?? "default_logo"
        self.quantity = try container.decode(Int.self, forKey: .quantity)
        self.avgPrice = try container.decode(Int.self, forKey: .avgPrice)
        self.currentPrice = try container.decode(Int.self, forKey: .currentPrice)
        self.pl = try container.decode(Int.self, forKey: .pl)
    }
    
    init() {
        self.stockName = ""
        self.logoImage =  "default_logo"
        self.quantity = 0
        self.avgPrice = 0
        self.currentPrice = 0
        self.pl = 0
    }
}
