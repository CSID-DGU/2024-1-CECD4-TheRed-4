//
//  StockNetwork.swift
//  stocksignal
//
//  Created by 신예빈 on 9/3/24.
//

import Foundation
import RxSwift

final class StockNetwork {
    private let stockNetwork:Network<BalanceResponse>
    private let myStockNetwork:Network<BalanceResponse>
    private let detailNetwork:Network<StockDetailResponse>
    private let currentPriceNetwork: Network<CurrentPriceResponse>
    private let logoImageNetwork: Network<LogoImageResponse>
    
    init(stockNetwork: Network<BalanceResponse>, myStockNetwork: Network<BalanceResponse>, stockDetailNetwork: Network<StockDetailResponse>, currentPriceNetwork: Network<CurrentPriceResponse>, logoimageNetwork: Network<LogoImageResponse>) {
        self.stockNetwork = stockNetwork
        self.myStockNetwork = myStockNetwork
        self.detailNetwork = stockDetailNetwork
        self.currentPriceNetwork = currentPriceNetwork
        self.logoImageNetwork = logoimageNetwork
    }
    
    public func getStockList() -> Observable<BalanceResponse> {
        let result = self.stockNetwork.getItemList(path: "api/mybalance", defaultValue: BalanceResponse())
        print("test\n")
        print(result)
        print("\n")
        return result
    }
    
    public func getMyStockList() -> Observable<BalanceResponse> {
        return self.stockNetwork.getItemList(path: "api/mybalance", defaultValue: BalanceResponse())
    }
    
    public func getStockDetail(stockName:String) -> Observable<StockDetailResponse> {
        return self.detailNetwork.getItemList(path: "api/company/\(stockName)", defaultValue: StockDetailResponse())
    }
    
    public func getCurrentPrice(stockName: String) -> Observable<CurrentPriceResponse> {
        return self.currentPriceNetwork.getItemList(path: "api/company/\(stockName)/current-price", defaultValue: CurrentPriceResponse())
    }
    
    public func getLogoImage(stockName: String) -> Observable<LogoImageResponse> {
        return self.logoImageNetwork.getItemList(path: "api/company/\(stockName)/logo", defaultValue: LogoImageResponse())
    }
}

