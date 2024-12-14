//
//  HomeViewModel.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
//

import Foundation
import RxSwift

final class HomeViewModel {
    private let stockNetwork: StockNetwork
    public var itemCode: String
    
    init() {
        let networkProvider = NetworkProvider()
        stockNetwork = networkProvider.makeStockNetwork()
        itemCode = "000000"
    }
    
    struct Input {
//        let myStockTrigger: Observable<Void>
//        let homeTrigger: Observable<Void>
//        let stockDetailTrigger: Observable<Void>
    }
    
    struct Output {
        let stockList: Observable<BalanceResponse>
        let myStockList: Observable<BalanceResponse>
//        let stockDetail: Observable<StockDetail>
    }
    
    public func transform(input:Input) -> Output {
        let getItem: Observable<BalanceResponse> = stockNetwork.getStockList()
        
        //
        let myStockList: Observable<BalanceResponse> = stockNetwork.getStockList()
        
        //
        //        let stockDetail = input.stockDetailTrigger.flatMapLatest {[unowned self] _ -> Observable<StockDetail> in
        //            return self.stockNetwork.getStockDetail(code: itemCode)
        //        }
        //
        //        return Output(stockList: getItem, myStockList: myStockList, stockDetail: stockDetail)
        //    }
        return Output(stockList: getItem, myStockList: myStockList)
        
    }
}
