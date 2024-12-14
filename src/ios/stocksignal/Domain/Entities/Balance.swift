//
//  Balance.swift
//  stocksignal
//
//  Created by 신예빈 on 11/7/24.
//

import Foundation

struct BalanceResponse: Decodable {
    let code: String
    let result: String
    let message: String
    let data: BalanceData
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = BalanceData()
    }
}

struct BalanceData: Decodable {
    let cash: Int
    let totalStockPrice: Int
    let totalStockPL: Int
    let stocks: [Stock]
    
    init() {
        self.cash = 0
        self.totalStockPrice = 0
        self.totalStockPL = 0
        self.stocks = []
    }
}
