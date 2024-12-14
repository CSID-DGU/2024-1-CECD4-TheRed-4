//
//  TestNetwork.swift
//  stocksignal
//
//  Created by 신예빈 on 9/7/24.
//

import Foundation
import RxSwift

final class TestNetwork {
    private let network:Network<String>
    private let scenario:Network<Scenario>
    
    init() {
        network = Network<String>("http://127.0.0.1:8000/testapp", token: "")
        scenario = Network<Scenario>("http://127.0.0.1:8000/testapp", token: "")
    }
    
    public func getNewsData() -> Observable<String> {
        return self.network.getItemList(path: "getNewsData", defaultValue: "")
    }
    
    public func getAnalysisData() -> Observable<String> {
        return self.network.getItemList(path: "getAnalysisData", defaultValue: "")
    }
    
    public func getAIPredictData() -> Observable<String> {
        return self.network.getItemList(path: "getAIPredictData", defaultValue: "")
    }
    
    public func getAutoTradingData() -> Observable<Scenario> {
        return self.scenario.getItemList(path: "getAutoTradingScenarioListData", defaultValue: Scenario())
    }
}

