//
//  UtilNetwork.swift
//  stocksignal
//
//  Created by 신예빈 on 11/10/24.
//

import Foundation
import RxSwift

final class UtilNetwork {
    private let newsNetwork: Network<NewsResponse>
    private let scenarioNetwork: Network<ScenarioResponse>
    private let dayChartNetwork: Network<DateResponse>
    
    init(newsNetwork: Network<NewsResponse>, scenarioNetwork: Network<ScenarioResponse>, dayChartNetwork: Network<DateResponse>) {
        self.newsNetwork = newsNetwork
        self.scenarioNetwork = scenarioNetwork
        self.dayChartNetwork = dayChartNetwork
    }
    
    public func getNews(stockName: String) -> Observable<NewsResponse> {
        return self.newsNetwork.getItemList(path: "api/news/\(stockName)", defaultValue: NewsResponse())
    }
    
    public func getScenarios() -> Observable<ScenarioResponse> {
        return self.scenarioNetwork.getItemList(path: "api/scenario", defaultValue: ScenarioResponse())
    }
    
    public func getDateValue(stockName: String, startDate: String, endDate: String) -> Observable<DateResponse> {
        return self.dayChartNetwork.getItemList(path: "api/company/\(stockName)/period-price?startDate=\(startDate)&endDate=\(endDate)", defaultValue: DateResponse())
    }

}

