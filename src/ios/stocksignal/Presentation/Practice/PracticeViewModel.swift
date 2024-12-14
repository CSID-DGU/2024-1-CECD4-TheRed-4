//
//  PracticeViewModel.swift
//  stocksignal
//
//  Created by 신예빈 on 11/24/24.
//

import Foundation
import RxSwift

final class PracticeViewModel {
    
    let network: UtilNetwork
    public var periodPrice: PeriodPrice
    
    public var accountCash = 100000000
    public var openPrice = 0
    public var currentPrice = 0
    public var avgPrice = 0
    public var quantity = 0
    public var tradeQuantity = 0
    public var timeStamp = 50
    
    public var scenarios:[Scenario] = []
    public var conditions:[Dictionary<String, Any>] = []
    
    init() {
        let provider = NetworkProvider()
        self.network = provider.makeUtilNetwork()
        self.periodPrice = PeriodPrice()
    }
    
    struct Input {
        let stockName: String
    }
    
    struct Output {
        
    }
    
    struct PageChangeInput {
        let practiceTrigger: PublishSubject<Void>
        let analysisTrigger: PublishSubject<Void>
        let aipredictTrigger: PublishSubject<Void>
        let autotradeTrigger: PublishSubject<Void>
    }
    
    struct PageItem {
        let practice:Observable<NewsResponse>
        let analysis:Observable<StockDetailResponse>
        let aipredict:Observable<String>
        let autotrading:Observable<ScenarioResponse>
    }
    
    struct IsPredict {
        let code:String
        let aipredictTrigger:PublishSubject<Void>
    }
    
    struct PredOutput {
        let predItems:[Int]
        let stockItem:Observable<PeriodPrice>
    }

    public func transform(input:String) -> Observable<DateResponse> {
        let getItem: Observable<DateResponse> = network.getDateValue(stockName: input, startDate: "20240209", endDate: "20240809")
        
        getItem.bind {[weak self] out in
            self?.periodPrice = out.data
        }
        
        return getItem
    }
    
    public func pageSelect(input:PageChangeInput) -> PageItem {
        let practice = input.practiceTrigger.flatMapLatest {_ -> Observable<NewsResponse> in
            return Observable.just(NewsResponse())
        }
        
        let analysis = input.analysisTrigger.flatMapLatest {_ -> Observable<StockDetailResponse> in
            return Observable.just(StockDetailResponse())
        }
        
        let aipredict = input.aipredictTrigger.flatMapLatest {_ -> Observable<String> in
            return Observable.just("")
            
        }
        
        let autotrading = input.autotradeTrigger.flatMapLatest {_ -> Observable<ScenarioResponse> in
            return Observable.just(ScenarioResponse())
        }
        
        return PageItem(practice: practice, analysis: analysis, aipredict: aipredict, autotrading: autotrading)
    }
    
    public func getChart(index: Int) -> [Dates] {
        var temp: [Dates] = []
        
        for i in index...99 {
            temp.append(periodPrice.periodPrice[i])
        }
        
        return temp
    }
    
    public func getAnalysis(index: Int) -> Dates {
        return (periodPrice.periodPrice[index])
    }
    
    public func buy(price: Int) {
        
        self.accountCash -= self.tradeQuantity * price
        self.avgPrice = (self.quantity * avgPrice + self.tradeQuantity * price) / (self.quantity + self.tradeQuantity)
        self.quantity = self.quantity + self.tradeQuantity
        self.tradeQuantity = 0
    }
    
    public func sell(price: Int) {
        self.accountCash += self.tradeQuantity * price
        self.quantity = self.quantity - self.tradeQuantity
        self.tradeQuantity = 0
        if self.quantity == 0 {
            self.avgPrice = 0
        }
    }
    
    public func step(timeStemp: Int) {
        self.currentPrice = self.getAnalysis(index: timeStemp).closePrice
        
    }
    
}

