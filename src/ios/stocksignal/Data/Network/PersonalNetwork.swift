//
//  PersonalNetwork.swift
//  stocksignal
//
//  Created by 신예빈 on 11/11/24.
//

import Foundation
import RxSwift

final class PersonalNetwork {
    private let nicknameNetwork: Network<NickNameResponse>
    private let booleanNetwork: Network<BooleanResponse>
    
    init(nicknameNetwork: Network<NickNameResponse>, booleanNetwork: Network<BooleanResponse>) {
        self.nicknameNetwork = nicknameNetwork
        self.booleanNetwork = booleanNetwork
    }
    
    public func getNickName() -> Observable<NickNameResponse> {
        return self.nicknameNetwork.getItemList(path: "api/user/info/detail", defaultValue: NickNameResponse())
    }

    public func isNickNameChange(nickname: String) -> Observable<BooleanResponse> {
        return self.booleanNetwork.getItemList(path: "api/user/\(nickname)/exists", defaultValue: BooleanResponse())
    }
    
    public func changeNickName(updateData: [String: Any]) -> Observable<BooleanResponse> {
        return self.booleanNetwork.PatchData(path: "api/user/info/edit", defaultValue: BooleanResponse(), updateData: updateData)
    }
    
    public func connectAccount(updateData: [String: Any]) -> Observable<BooleanResponse> {
        return self.booleanNetwork.PostData(path: "api/user/kis/connect", defaultValue: BooleanResponse(), updateData: updateData)
    }
}

