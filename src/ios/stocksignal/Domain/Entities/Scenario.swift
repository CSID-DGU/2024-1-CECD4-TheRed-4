//
//  Scenario.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
//

import Foundation

struct ScenarioResponse: Decodable {
    let code: String
    let result: String
    let message: String
    let data: [Scenario]
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = []
    }
}

struct ConditionResponse: Decodable {
    let code: String
    let result: String
    let message: String
    let data: [Condition]
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = []
    }
}

struct Scenario: Decodable, Hashable {
    let scenarioId: Int
    let scenarioName: String
    let companyName: String
    let initialPrice: Int
    let currentPrice: Int
    
    enum CodingKeys: CodingKey {
        case scenarioId
        case scenarioName
        case companyName
        case initialPrice
        case currentPrice
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.scenarioId = try container.decode(Int.self, forKey: .scenarioId)
        self.scenarioName = try container.decode(String.self, forKey: .scenarioName)
        self.companyName = try container.decode(String.self, forKey: .companyName)
        self.initialPrice = try container.decode(Int.self, forKey: .initialPrice)
        self.currentPrice = try container.decode(Int.self, forKey: .currentPrice)
    }
    
    init() {
        self.scenarioId = 0
        self.scenarioName = ""
        self.companyName = ""
        self.initialPrice = 0
        self.currentPrice = 0
    }
    
    init(scenarioId:Int, scenarioName:String, companyName:String, initialPrice:Int, currentPrice:Int) {
        self.scenarioId = scenarioId
        self.scenarioName = scenarioName
        self.companyName = companyName
        self.initialPrice = initialPrice
        self.currentPrice = currentPrice
    }
}

struct Condition: Decodable, Hashable {
    let conditionId: Int
    let buysellType: String
    let methodType: String
    let initialPrice: Int
    let currentPrice: Int
    let targetPrice1: Int
    let targetPrice2: Int
    let targetPrice3: Int
    let targetPrice4: Int
    let quantity: Int
    
    enum CodingKeys: CodingKey {
        case conditionId
        case buysellType
        case methodType
        case initialPrice
        case currentPrice
        case targetPrice1
        case targetPrice2
        case targetPrice3
        case targetPrice4
        case quantity
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.conditionId = try container.decode(Int.self, forKey: .conditionId)
        self.buysellType = try container.decode(String.self, forKey: .buysellType)
        self.methodType = try container.decode(String.self, forKey: .methodType)
        self.initialPrice = try container.decode(Int.self, forKey: .initialPrice)
        self.currentPrice = try container.decode(Int.self, forKey: .currentPrice)
        self.targetPrice1 = try container.decode(Int.self, forKey: .targetPrice1)
        self.targetPrice2 = try container.decode(Int.self, forKey: .targetPrice2)
        self.targetPrice3 = try container.decode(Int.self, forKey: .targetPrice3)
        self.targetPrice4 = try container.decode(Int.self, forKey: .targetPrice4)
        self.quantity = try container.decode(Int.self, forKey: .quantity)
    }
    
    init() {
        self.conditionId = 0
        self.buysellType = ""
        self.methodType = ""
        self.initialPrice = 0
        self.currentPrice = 0
        self.targetPrice1 = 0
        self.targetPrice2 = 0
        self.targetPrice3 = 0
        self.targetPrice4 = 0
        self.quantity = 0
    }
    
    init(conditionId:Int, buysellType:String, methodType:String, initialPrice:Int, currentPrice:Int, targetPrice1:Int, targetPrice2:Int, targetPrice3:Int, targetPrice4:Int, quantity:Int) {
        self.conditionId = conditionId
        self.buysellType = buysellType
        self.methodType = methodType
        self.initialPrice = initialPrice
        self.currentPrice = currentPrice
        self.targetPrice1 = targetPrice1
        self.targetPrice2 = targetPrice2
        self.targetPrice3 = targetPrice3
        self.targetPrice4 = targetPrice4
        self.quantity = quantity
    }
}
