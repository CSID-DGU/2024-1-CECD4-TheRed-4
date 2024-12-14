//
//  NewScenarioViewModel.swift
//  stocksignal
//
//  Created by 신예빈 on 9/10/24.
//

import Foundation
import RxSwift

struct condition: Hashable {
    let condition: String
    let condition1: String
    let condition2: String
    let condition3: String
    let condition4: String
    let condition5: String
}

final class NewScenarioViewModel {    
    var buySellIndex = 0
    var standardIndex = 0
    
    var targetPrice_buy_rate_up = 0
    var targetPrice_buy_rate_down = 0
    
    var targetPrice_buy_price_up = 0
    var targetPrice_buy_price_down = 0
    
    var targetPrice_buy_trade_up1 = 0
    var targetPrice_buy_trade_down1 = 0
    var targetPrice_buy_trade_down2 = 0
    var targetPrice_buy_trade_up2 = 0
    
    var targetPrice_sell_rate_up = 0
    var targetPrice_sell_rate_down = 0
    
    var targetPrice_sell_price_up = 0
    var targetPrice_sell_price_down = 0
    
    var targetPrice_sell_trade_up1 = 0
    var targetPrice_sell_trade_down1 = 0
    var targetPrice_sell_trade_down2 = 0
    var targetPrice_sell_trade_up2 = 0
    
    var tradeQuantity = 0
    var tradeRate = 0
    
    let utilNetwork: UtilNetwork
    let scenarioNetwork: ScenarioNetwork
    
    init() {
        let provider = NetworkProvider()
        utilNetwork = provider.makeUtilNetwork()
        scenarioNetwork = provider.makeScenarioNetwork()
    }
    
    struct Input {
        let buyButtonTrigger: PublishSubject<Void>
        let sellButtonTrigger: PublishSubject<Void>
        let rateButtonTrigger: PublishSubject<Void>
        let priceButtonTrigger: PublishSubject<Void>
        let tradingButtonTrigger: PublishSubject<Void>
    }
    
    struct Output {
        let buy:Observable<Int>
        let sell:Observable<Int>
        let rate:Observable<Int>
        let price:Observable<Int>
        let trading:Observable<Int>
    }
    
    struct Conditions {
        let conditions: Observable<[condition]>
    }
    
    struct InitOutput {
        let chart: DateResponse
        let conditions: ConditionResponse?
    }
    
    public func getInit(stockName: String, scenarioID: Int?) -> Observable<InitOutput> {
        let getChart: Observable<DateResponse> = utilNetwork.getDateValue(stockName: stockName, startDate: "20240101", endDate: "20241129")
        
        let getConditions: Observable<ConditionResponse?> = {
            if scenarioID != nil {
                return scenarioNetwork.getConditions(scenarioId: scenarioID!)
                    .map { $0 as ConditionResponse? } // map을 사용해 옵셔널로 변환
            } else {
                return Observable.just(nil) // scenarioID가 nil일 경우
            }
        }()
        
        return Observable.zip(getChart, getConditions) { chart, condition in
            return InitOutput(chart: chart, conditions: condition)
            }
    }
    
    public func buttonSelect(input:Input) -> Output {
        let buy = input.buyButtonTrigger.flatMapLatest { _ -> Observable<Int> in
            self.buySellIndex = 0
            return Observable.just(Int(self.buySellIndex * 3 + self.standardIndex))
        }
        
        let sell = input.sellButtonTrigger.flatMapLatest { _ -> Observable<Int> in
            self.buySellIndex = 1
            return Observable.just(Int(self.buySellIndex * 3 + self.standardIndex))
        }
        
        let rate = input.rateButtonTrigger.flatMapLatest { _ -> Observable<Int> in
            self.standardIndex = 0
            return Observable.just(Int(self.buySellIndex * 3 + self.standardIndex))
        }
        
        let price = input.priceButtonTrigger.flatMapLatest { _ -> Observable<Int> in
            self.standardIndex = 1
            return Observable.just(Int(self.buySellIndex * 3 + self.standardIndex))
        }
        
        let trading = input.tradingButtonTrigger.flatMapLatest { _ -> Observable<Int> in
            self.standardIndex = 2
            return Observable.just(Int(self.buySellIndex * 3 + self.standardIndex))
        }
        
        return Output(buy: buy, sell: sell, rate: rate, price: price, trading: trading)
    }
    
    
    public func makeScenario(scenarioName: String, companyName: String, currentPrice:Int, buttonIndex: Int, footerIndex: Int) -> Observable<BooleanResponse>? {
        
        
        var result = Dictionary<String, Any>()
        
        result["scenarioName"] = scenarioName
        result["companyName"] = companyName
        result["initialPrice"] = currentPrice
        result["targetPrice1"] = 0
        result["targetPrice2"] = 0
        result["targetPrice3"] = 0
        result["targetPrice4"] = 0
        
        switch buySellIndex {
        case 0:
            result["buysellType"] = "BUY"
        case 1:
            result["buysellType"] = "SELL"
        default:
            return nil
        }
        
        print(1)
        
        switch standardIndex {
        case 0:
            result["methodType"] = "RATE"
        case 1:
            result["methodType"] = "PRICE"
        case 2:
            result["methodType"] = "TRADING"
        default:
            return nil
        }
        
        print(2)
        
        if buttonIndex == 0 || footerIndex == 0 {
            return nil
        }
        else {
            switch (self.buySellIndex * 3 + self.standardIndex){
            case 0:
                if buttonIndex == 1 {
                    if targetPrice_buy_rate_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_rate_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_rate_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_rate_down
                }
            case 1:
                if buttonIndex == 1 {
                    if targetPrice_buy_price_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_price_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_price_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_price_down
                }
            case 2:
                if buttonIndex == 1 {
                    if targetPrice_buy_trade_up1 == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_trade_up1
                    if targetPrice_buy_trade_down1 == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_trade_down1
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_trade_down2 == 0 { return nil }
                    result["targetPrice3"] = targetPrice_buy_trade_down2
                    if targetPrice_buy_trade_up2 == 0 { return nil }
                    result["targetPrice4"] = targetPrice_buy_trade_up2
                }
            case 3:
                if buttonIndex == 1 {
                    if targetPrice_sell_rate_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_rate_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_rate_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_rate_down
                }
            case 4:
                if buttonIndex == 1 {
                    if targetPrice_sell_price_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_price_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_price_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_price_down
                }
            case 5:
                if buttonIndex == 1 {
                    if targetPrice_sell_trade_up1 == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_trade_up1
                    if targetPrice_sell_trade_down1 == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_trade_down1
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_trade_down2 == 0 { return nil }
                    result["targetPrice3"] = targetPrice_sell_trade_down2
                    if targetPrice_sell_trade_up2 == 0 { return nil }
                    result["targetPrice4"] = targetPrice_sell_trade_up2
                }
            default:
                return nil
            }
            
            if footerIndex == 1 {
                if tradeQuantity == 0 { return nil }
                result["quantity"] = tradeQuantity
            }
            else if footerIndex == 2 {
                if tradeRate == 0 { return nil }
                result["quantity"] = tradeRate
            }
            
            print(result)
            let out = scenarioNetwork.createScenario(updateData: result)
            
            return out
        }
    }
    
    public func addCondition(scenarioId: Int, currentPrice:Int, buttonIndex: Int, footerIndex: Int) -> Observable<BooleanResponse>? {
        
        
        var result = Dictionary<String, Any>()
        
        result["scenarioId"] = scenarioId
        result["targetPrice1"] = 0
        result["targetPrice2"] = 0
        result["targetPrice3"] = 0
        result["targetPrice4"] = 0
        
        switch buySellIndex {
        case 0:
            result["buysellType"] = "BUY"
        case 1:
            result["buysellType"] = "SELL"
        default:
            return nil
        }
        
        switch standardIndex {
        case 0:
            result["methodType"] = "RATE"
        case 1:
            result["methodType"] = "PRICE"
        case 2:
            result["methodType"] = "TRADING"
        default:
            return nil
        }
        
        if buttonIndex == 0 || footerIndex == 0 {
            return nil
        }
        else {
            switch (self.buySellIndex * 3 + self.standardIndex){
            case 0:
                if buttonIndex == 1 {
                    if targetPrice_buy_rate_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_rate_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_rate_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_rate_down
                }
            case 1:
                if buttonIndex == 1 {
                    if targetPrice_buy_price_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_price_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_price_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_price_down
                }
            case 2:
                if buttonIndex == 1 {
                    if targetPrice_buy_trade_up1 == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_trade_up1
                    if targetPrice_buy_trade_down1 == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_trade_down1
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_trade_down2 == 0 { return nil }
                    result["targetPrice3"] = targetPrice_buy_trade_down2
                    if targetPrice_buy_trade_up2 == 0 { return nil }
                    result["targetPrice4"] = targetPrice_buy_trade_up2
                }
            case 3:
                if buttonIndex == 1 {
                    if targetPrice_sell_rate_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_rate_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_rate_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_rate_down
                }
            case 4:
                if buttonIndex == 1 {
                    if targetPrice_sell_price_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_price_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_price_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_price_down
                }
            case 5:
                if buttonIndex == 1 {
                    if targetPrice_sell_trade_up1 == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_trade_up1
                    if targetPrice_sell_trade_down1 == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_trade_down1
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_trade_down2 == 0 { return nil }
                    result["targetPrice3"] = targetPrice_sell_trade_down2
                    if targetPrice_sell_trade_up2 == 0 { return nil }
                    result["targetPrice4"] = targetPrice_sell_trade_up2
                }
            default:
                return nil
            }
            
            if footerIndex == 1 {
                if tradeQuantity == 0 { return nil }
                result["quantity"] = tradeQuantity
            }
            else if footerIndex == 2 {
                if tradeRate == 0 { return nil }
                result["quantity"] = tradeRate
            }
            
            print(result)
            let out = scenarioNetwork.addCondition(updateData: result)
            
            return out
        }
    }
    
    public func practiceMakeScenario(scenarioName: String, companyName: String, currentPrice:Int, buttonIndex: Int, footerIndex: Int) -> Scenario? {
        
        
        var result = Dictionary<String, Any>()
        
        result["scenarioName"] = scenarioName
        result["companyName"] = companyName
        result["initialPrice"] = currentPrice
        result["targetPrice1"] = 0
        result["targetPrice2"] = 0
        result["targetPrice3"] = 0
        result["targetPrice4"] = 0
        
        switch buySellIndex {
        case 0:
            result["buysellType"] = "BUY"
        case 1:
            result["buysellType"] = "SELL"
        default:
            return nil
        }
        
        switch standardIndex {
        case 0:
            result["methodType"] = "RATE"
        case 1:
            result["methodType"] = "PRICE"
        case 2:
            result["methodType"] = "TRADING"
        default:
            return nil
        }
        
        if buttonIndex == 0 || footerIndex == 0 {
            return nil
        }
        else {
            switch (self.buySellIndex * 3 + self.standardIndex){
            case 0:
                if buttonIndex == 1 {
                    if targetPrice_buy_rate_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_rate_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_rate_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_rate_down
                }
            case 1:
                if buttonIndex == 1 {
                    if targetPrice_buy_price_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_price_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_price_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_price_down
                }
            case 2:
                if buttonIndex == 1 {
                    if targetPrice_buy_trade_up1 == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_trade_up1
                    if targetPrice_buy_trade_down1 == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_trade_down1
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_trade_down2 == 0 { return nil }
                    result["targetPrice3"] = targetPrice_buy_trade_down2
                    if targetPrice_buy_trade_up2 == 0 { return nil }
                    result["targetPrice4"] = targetPrice_buy_trade_up2
                }
            case 3:
                if buttonIndex == 1 {
                    if targetPrice_sell_rate_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_rate_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_rate_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_rate_down
                }
            case 4:
                if buttonIndex == 1 {
                    if targetPrice_sell_price_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_price_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_price_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_price_down
                }
            case 5:
                if buttonIndex == 1 {
                    if targetPrice_sell_trade_up1 == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_trade_up1
                    if targetPrice_sell_trade_down1 == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_trade_down1
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_trade_down2 == 0 { return nil }
                    result["targetPrice3"] = targetPrice_sell_trade_down2
                    if targetPrice_sell_trade_up2 == 0 { return nil }
                    result["targetPrice4"] = targetPrice_sell_trade_up2
                }
            default:
                return nil
            }
            
            if footerIndex == 1 {
                if tradeQuantity == 0 { return nil }
                result["quantity"] = tradeQuantity
            }
            else if footerIndex == 2 {
                if tradeRate == 0 { return nil }
                result["quantity"] = tradeRate
            }
            
            return Scenario(scenarioId: 0, scenarioName: result["scenarioName"] as! String, companyName: "연습모드", initialPrice: currentPrice, currentPrice: currentPrice)
        }
    }
    
    public func practiceAddCondition(scenarioId: Int, currentPrice:Int, buttonIndex: Int, footerIndex: Int) -> Dictionary<String, Any>? {
        
        
        var result = Dictionary<String, Any>()
        
        result["scenarioId"] = scenarioId
        result["targetPrice1"] = 0
        result["targetPrice2"] = 0
        result["targetPrice3"] = 0
        result["targetPrice4"] = 0
        
        switch buySellIndex {
        case 0:
            result["buysellType"] = "BUY"
        case 1:
            result["buysellType"] = "SELL"
        default:
            return nil
        }
        
        switch standardIndex {
        case 0:
            result["methodType"] = "RATE"
        case 1:
            result["methodType"] = "PRICE"
        case 2:
            result["methodType"] = "TRADING"
        default:
            return nil
        }
        
        if buttonIndex == 0 || footerIndex == 0 {
            return nil
        }
        else {
            switch (self.buySellIndex * 3 + self.standardIndex){
            case 0:
                if buttonIndex == 1 {
                    if targetPrice_buy_rate_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_rate_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_rate_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_rate_down
                }
            case 1:
                if buttonIndex == 1 {
                    if targetPrice_buy_price_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_price_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_price_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_price_down
                }
            case 2:
                if buttonIndex == 1 {
                    if targetPrice_buy_trade_up1 == 0 { return nil }
                    result["targetPrice1"] = targetPrice_buy_trade_up1
                    if targetPrice_buy_trade_down1 == 0 { return nil }
                    result["targetPrice2"] = targetPrice_buy_trade_down1
                }
                else if buttonIndex == 2 {
                    if targetPrice_buy_trade_down2 == 0 { return nil }
                    result["targetPrice3"] = targetPrice_buy_trade_down2
                    if targetPrice_buy_trade_up2 == 0 { return nil }
                    result["targetPrice4"] = targetPrice_buy_trade_up2
                }
            case 3:
                if buttonIndex == 1 {
                    if targetPrice_sell_rate_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_rate_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_rate_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_rate_down
                }
            case 4:
                if buttonIndex == 1 {
                    if targetPrice_sell_price_up == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_price_up
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_price_down == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_price_down
                }
            case 5:
                if buttonIndex == 1 {
                    if targetPrice_sell_trade_up1 == 0 { return nil }
                    result["targetPrice1"] = targetPrice_sell_trade_up1
                    if targetPrice_sell_trade_down1 == 0 { return nil }
                    result["targetPrice2"] = targetPrice_sell_trade_down1
                }
                else if buttonIndex == 2 {
                    if targetPrice_sell_trade_down2 == 0 { return nil }
                    result["targetPrice3"] = targetPrice_sell_trade_down2
                    if targetPrice_sell_trade_up2 == 0 { return nil }
                    result["targetPrice4"] = targetPrice_sell_trade_up2
                }
            default:
                return nil
            }
            
            if footerIndex == 1 {
                if tradeQuantity == 0 { return nil }
                result["quantity"] = tradeQuantity
            }
            else if footerIndex == 2 {
                if tradeRate == 0 { return nil }
                result["quantity"] = tradeRate
            }
            
            return result
        }
    }
    
    public func getUnit(price: Int) -> Int {
        if (price < 2000) {
            return 1
        }
        else if (price < 5000) {
            return 5
        }
        else if (price < 20000) {
            return 10
        }
        else if (price < 50000) {
            return 50
        }
        else if (price < 200000) {
            return 100
        }
        else if (price < 500000) {
            return 500
        }
        else {
            return 1000
        }
    }
    
    public func deleteScenario(scenarioId: Int) -> Observable<BooleanResponse> {
        return scenarioNetwork.deleteScenario(scenarioId: scenarioId)
    }
    
    public func deleteCondition(conditionId: Int) -> Observable<BooleanResponse> {
        return scenarioNetwork.deleteCondition(conditionId: conditionId)
    }
}
