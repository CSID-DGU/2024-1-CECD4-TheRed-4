//
//  NetworkProvider.swift
//  stocksignal
//
//  Created by 신예빈 on 9/4/24.
//

import Foundation

final class NetworkProvider {
    private let endpoint: String
    private var token: String
    
    init() {
        //self.endpoint = "http://127.0.0.1:8000/testapp"
        self.endpoint = "https://pposiraun.com"
        
        
        self.token = ""
        setToken()
    }
    
    public func setToken() {
        let searchQuery: NSDictionary = [kSecClass: kSecClassKey,
                                     kSecAttrLabel: "accessToken",
                              kSecReturnAttributes: true,
                                    kSecReturnData: true]
        var searchedResult: CFTypeRef?
        let searchStatus = SecItemCopyMatching(searchQuery, &searchedResult)
        if searchStatus == errSecSuccess {
            guard let checkedItem = searchedResult,
                  let token = checkedItem[kSecValueData] as? Data else { return }
            self.token = String(data: token, encoding: String.Encoding.utf8)!
        } else {
            print("불러오기 실패, status = ", searchStatus)
        }
    }
    
    public func makeStockNetwork() -> StockNetwork {
        let stockNetwork = Network<BalanceResponse>(self.endpoint, token: self.token)
        let myStockNetwork = Network<BalanceResponse>(self.endpoint, token: self.token)
        let stockDetailNetwork = Network<StockDetailResponse>(self.endpoint, token: self.token)
        let currentPriceNetwork = Network<CurrentPriceResponse>(self.endpoint, token: self.token)
        let logoImageNetwork = Network<LogoImageResponse>(self.endpoint, token: self.token)
        
        return StockNetwork(stockNetwork: stockNetwork, myStockNetwork: myStockNetwork, stockDetailNetwork: stockDetailNetwork, currentPriceNetwork: currentPriceNetwork, logoimageNetwork: logoImageNetwork)
    }
    
    public func makeUtilNetwork() -> UtilNetwork {
        let newsNetwork = Network<NewsResponse>(self.endpoint, token: self.token)
        let scenarioNetwork = Network<ScenarioResponse>(self.endpoint, token: self.token)
        let dayChartNetwork = Network<DateResponse>(self.endpoint, token: self.token)
        
        return UtilNetwork(newsNetwork: newsNetwork, scenarioNetwork: scenarioNetwork, dayChartNetwork: dayChartNetwork)
    }
    
    public func makePersonalNetwork() -> PersonalNetwork {
        let nicknameNetwork = Network<NickNameResponse>(self.endpoint, token: self.token)
        let booleanNetwork = Network<BooleanResponse>(self.endpoint, token: self.token)
        
        return PersonalNetwork(nicknameNetwork: nicknameNetwork, booleanNetwork: booleanNetwork)
    }
    
    public func makeSearchNetwork() -> SearchNetwork {
        let rankNetwork = Network<RankResponse>(self.endpoint, token: self.token)
        
        return SearchNetwork(rankNetwork: rankNetwork)
    }
    
    public func makeScenarioNetwork() -> ScenarioNetwork {
        let booleanNetwork = Network<BooleanResponse>(self.endpoint, token: self.token)
        let conditionNetwork = Network<ConditionResponse>(self.endpoint, token: self.token)
        
        return ScenarioNetwork(booleanNetwork: booleanNetwork, conditionNetwork: conditionNetwork)
    }
    
    public func makeTradeNetwork() -> TradeNetwork {
        let codeNetwork = Network<CodeResponse>(self.endpoint, token: self.token)
        let booleanNetwork = Network<BooleanResponse>(self.endpoint, token: self.token)
        
        return TradeNetwork(codeNetwork: codeNetwork, booleanNetwork: booleanNetwork)
    }
    
    public func makeLoginNetwork() -> LoginNetwork {
        let accessNetwork = Network<AccessTokenResponse>(self.endpoint, token: self.token)
        let tokenNetwork = Network<Token>(self.endpoint, token: self.token)
        
        return LoginNetwork(accessNetwork: accessNetwork, tokenNetwork: tokenNetwork)
    }
}
