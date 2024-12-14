//
//  ScenarioNetwork.swift
//  stocksignal
//
//  Created by 신예빈 on 11/13/24.
//

import Foundation
import RxSwift

final class ScenarioNetwork {
    private let booleanNetwork: Network<BooleanResponse>
    private let conditionNetwork: Network<ConditionResponse>
    
    init(booleanNetwork: Network<BooleanResponse>, conditionNetwork: Network<ConditionResponse>) {
        self.booleanNetwork = booleanNetwork
        self.conditionNetwork = conditionNetwork
    }
    
    public func createScenario(updateData: [String: Any]) -> Observable<BooleanResponse> {
        return self.booleanNetwork.PostData(path: "api/scenario/create", defaultValue: BooleanResponse(), updateData: updateData)
    }
    
    public func addCondition(updateData: [String: Any]) -> Observable<BooleanResponse> {
        return self.booleanNetwork.PostData(path: "api/scenario/conditions/create", defaultValue: BooleanResponse(), updateData: updateData)
    }
    
    public func getConditions(scenarioId: Int) -> Observable<ConditionResponse> {
        return self.conditionNetwork.getItemList(path: "api/scenario/\(scenarioId)/conditions", defaultValue: ConditionResponse())
    }
    
    public func deleteScenario(scenarioId: Int) -> Observable<BooleanResponse> {
        return self.booleanNetwork.deleteData(path: "api/scenario/\(scenarioId)/delete", defaultValue: BooleanResponse())
    }
    
    public func deleteCondition(conditionId: Int) -> Observable<BooleanResponse> {
        return self.booleanNetwork.deleteData(path: "api/scenario/conditions/\(conditionId)/delete", defaultValue: BooleanResponse())
    }
}

