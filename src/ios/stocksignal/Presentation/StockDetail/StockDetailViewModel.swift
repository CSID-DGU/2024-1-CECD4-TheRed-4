//
//  StockDetailViewModel.swift
//  stocksignal
//
//  Created by 신예빈 on 9/6/24.
//

import Foundation
import RxSwift

final class StockDetailViewModel {
    let pred = [56000, 58200, 58000, 57500, 57000, 56000, 55200, 54500, 54100, 53200, 53500, 54100, 54900, 55500, 54500, 55100, 55900, 56300, 57000, 57100, 58000, 57300, 57000, 57100, 57200, 56200, 56100, 55900]
    
    let network: StockNetwork
    let utilNetwork: UtilNetwork
    let testNetwork: TestNetwork
    let tradeNetwork: TradeNetwork
    
    let gruModel = GRUProvider()
    
    init() {
        let provider = NetworkProvider()
        network = provider.makeStockNetwork()
        utilNetwork = provider.makeUtilNetwork()
        testNetwork = TestNetwork()
        tradeNetwork = provider.makeTradeNetwork()
    }
    
    struct Input {
        let stockName: String
        let aipredictTrigger:PublishSubject<Void>
    }
    
    struct Output {
        let stockItem: Observable<PeriodPrice>
        let predItem: Observable<PredOutput>
    }
    
    struct PageChangeInput {
        let stockName: String
        let newsTrigger: PublishSubject<Void>
        let analysisTrigger: PublishSubject<Void>
        let aipredictTrigger: PublishSubject<Void>
        let autotradeTrigger: PublishSubject<Void>
    }
    
    struct PageItem {
        let news:Observable<NewsResponse>
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
        let stockItem:DateResponse
    }

    public func transform(input:Input) -> Output {
        let getItem: Observable<DateResponse> = utilNetwork.getDateValue(stockName: input.stockName, startDate: "20240101", endDate: "20241129")

        let predObservable = input.aipredictTrigger.flatMapLatest {_ -> Observable<PredOutput> in
            return getItem.flatMap { out -> Observable<PredOutput> in
                let input = Array(out.data.periodPrice.reversed())
                
                let predModel = self.gruModel.predict(items: input)
                
                let currentPrice = out.data.periodPrice[0].closePrice
                
                let tuningPrice = predModel.map {$0 - (predModel[0] - currentPrice)}
                
                let predItem = Observable.just(tuningPrice)
                
                let pred = Observable.zip(getItem, predItem)
                
                return pred.map { dateResponse, intArray in
                    return StockDetailViewModel.PredOutput(predItems: intArray, stockItem: dateResponse)
                    }
            }
        }
                
        return Output(stockItem: getItem.map{ $0.data }, predItem: predObservable)
    }
    
    public func pageSelect(input:PageChangeInput) -> PageItem {
        let news = input.newsTrigger.flatMapLatest {[unowned self] _ -> Observable<NewsResponse> in
            return self.utilNetwork.getNews(stockName: input.stockName)
        }
        
        let analysis = input.analysisTrigger.flatMapLatest {[unowned self] _ -> Observable<StockDetailResponse> in
            return self.network.getStockDetail(stockName: input.stockName)
        }
        
        let aipredict = input.aipredictTrigger.flatMapLatest {[unowned self] _ -> Observable<String> in
            return self.testNetwork.getAIPredictData()
        }
        
        let autotrading = input.autotradeTrigger.flatMapLatest {[unowned self] _ -> Observable<ScenarioResponse> in
            return self.utilNetwork.getScenarios()
        }
        
        return PageItem(news: news, analysis: analysis, aipredict: aipredict, autotrading: autotrading)
    }
    
    public func getCode(stockName: String) -> Observable<CodeResponse> {
        return self.tradeNetwork.getCode(stockName: stockName)
    }
    
    
    public var quantity:Int = 0
    
    public func buyStock(stockCode: String, orderType: String, price: Int) -> Observable<BooleanResponse> {
        var data = Dictionary<String, Any>()
        
        data["scode"] = stockCode
        data["orderType"] = orderType
        data["price"] = price
        data["week"] = self.quantity
        
        return self.tradeNetwork.buyStock(updateData: data)
    }
    
    public func sellStock(stockCode: String, orderType: String, price: Int) -> Observable<BooleanResponse> {
        var data = Dictionary<String, Any>()
        
        data["scode"] = stockCode
        data["orderType"] = orderType
        data["price"] = price
        data["week"] = self.quantity
        
        return self.tradeNetwork.sellStock(updateData: data)
    }
    
    public func practicePredict(periodPrice: PeriodPrice, timeStamp: Int) -> [Int] {
        var input:[Dates] = []
        
        for _ in 1...(100 - timeStamp) {
            input.append(Dates())
        }
        
        for i in 0...(periodPrice.periodPrice.count-1) {
            input.append(periodPrice.periodPrice[periodPrice.periodPrice.count-1-i])
        }
        
        let out = gruModel.predict(items: input)
        
        let currentPrice = periodPrice.periodPrice[timeStamp].closePrice
        
        let tuningPrice = out.map {$0 - (out[0] - currentPrice)}
        
        return tuningPrice
    }
}
