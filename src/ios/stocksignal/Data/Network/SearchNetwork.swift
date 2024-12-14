//
//  SearchNetwork.swift
//  stocksignal
//
//  Created by 신예빈 on 11/11/24.
//

import Foundation
import RxSwift

final class SearchNetwork {
    private let rankNetwork: Network<RankResponse>
    
    init(rankNetwork: Network<RankResponse>) {
        self.rankNetwork = rankNetwork
    }
    
    public func getRank() -> Observable<RankResponse> {
        return self.rankNetwork.getItemList(path: "api/company/popular", defaultValue: RankResponse())
    }

}
