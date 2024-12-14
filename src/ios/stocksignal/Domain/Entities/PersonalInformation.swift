//
//  PersonalInformation.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
//

import Foundation

struct PersonalInformation: Decodable, Hashable {
    let balance: Int
    let stocks: [Stock]
    let totalEarning: Int
    let totalEarningRate: Float
    let lastUpdateDate: String
    
    enum CodingKeys: CodingKey {
        case balance
        case stocks
        case totalEarning
        case totalEarningRate
        case lastUpdateDate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.balance = try container.decode(Int.self, forKey: .balance)
        self.stocks = try container.decode([Stock].self, forKey: .stocks)
        self.totalEarning = try container.decode(Int.self, forKey: .totalEarning)
        self.totalEarningRate = try container.decode(Float.self, forKey: .totalEarningRate)
        self.lastUpdateDate = try container.decode(String.self, forKey: .lastUpdateDate)
    }
    
    init() {
        self.balance = 0
        self.stocks = []
        self.totalEarning = 0
        self.totalEarningRate = 0
        self.lastUpdateDate = ""
    }
}
