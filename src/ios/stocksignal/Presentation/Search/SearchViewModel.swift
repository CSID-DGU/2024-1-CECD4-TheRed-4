//
//  SearchViewModel.swift
//  stocksignal
//
//  Created by 신예빈 on 11/11/24.
//

import Foundation
import RxSwift

final class SearchViewModel {
    
    public var stockName: String = ""
    let network: SearchNetwork
    let stockNetwork: StockNetwork
    
    init() {
        let networkProvider = NetworkProvider()
        network = networkProvider.makeSearchNetwork()
        stockNetwork = networkProvider.makeStockNetwork()
    }
    
    struct Input {
            
    }
    
    struct RankOutput {
        let rank: Observable<RankResponse>
    }

    struct SearchOutput {
        let logo: LogoImageResponse
        let price: CurrentPriceResponse
    }

    public func transform(input:Input) -> RankOutput {
        let rank = network.getRank()
        
        return RankOutput(rank: rank)
    }

    public func searching(stockName: String?) -> Observable<SearchOutput> {
        if (stockName != nil) {
            let logo = stockNetwork.getLogoImage(stockName: stockName!)
            let price = stockNetwork.getCurrentPrice(stockName: stockName!)
            return Observable.zip(logo, price) { logo, price in
                return SearchOutput(logo: logo, price: price)
            }
        }
        else {
            let logo = stockNetwork.getLogoImage(stockName: self.stockName)
            let price = stockNetwork.getCurrentPrice(stockName: self.stockName)
            return Observable.zip(logo, price) { logo, price in
                return SearchOutput(logo: logo, price: price)
            }
        }
    }
    
}
