//
//  MyPageViewModel.swift
//  stocksignal
//
//  Created by 신예빈 on 11/11/24.
//

import Foundation
import RxSwift

final class MyPageViewModel {
    
    public var nickname: String = ""
    
    public var appKey: String = ""
    public var secretKey: String = ""
    public var account: String = ""
    
    let personalNetwork: PersonalNetwork
    
    init() {
        let networkProvider = NetworkProvider()
        personalNetwork = networkProvider.makePersonalNetwork()
    }
    
    struct Input {
            
    }
    
    struct Output {
        let nickname: Observable<NickNameResponse>
    }
    
    struct NickNameChangeInput {
        let confirmTrigger: PublishSubject<Void>
        let changeTrigger: PublishSubject<Void>
    }
    
    struct NickNameChangeOutput {
        let confirmResult: Observable<BooleanResponse>
        let changeResult: Observable<BooleanResponse>
    }
    
    struct ConnectInput {
        let confirmTrigger: PublishSubject<Void>
    }
    
    struct ConnectOutput {
        let confirmResult: Observable<BooleanResponse>
    }
    
    public func transform(input:Input) -> Output {

        
        return Output(nickname: getNickName())
    }
    
    public func getNickName() -> Observable<NickNameResponse> {
        return personalNetwork.getNickName()
    }
    
    public func NickNameChange(triggers: NickNameChangeInput) -> NickNameChangeOutput {
        
        let confirmResult = triggers.confirmTrigger.flatMapLatest {_ -> Observable<BooleanResponse> in
            return self.personalNetwork.isNickNameChange(nickname: self.nickname)
        }
        
        let changeResult = triggers.changeTrigger.flatMapLatest{_ -> Observable<BooleanResponse> in
            return self.personalNetwork.changeNickName(updateData: ["nickname":self.nickname])
        }
        
        return NickNameChangeOutput(confirmResult: confirmResult, changeResult: changeResult)
    }
    
    public func Connect(triggers: ConnectInput) -> ConnectOutput {
        
        let updateData = ["appKey": self.appKey, "secretKey": self.secretKey, "account": self.account]
    
        let confirmResult = triggers.confirmTrigger.flatMapLatest{_ -> Observable<BooleanResponse> in
            return self.personalNetwork.connectAccount(updateData: updateData)
        }
        
        return ConnectOutput(confirmResult: confirmResult)
    }
}
