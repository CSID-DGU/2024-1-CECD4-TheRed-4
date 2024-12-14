//
//  LoginViewModel.swift
//  stocksignal
//
//  Created by 신예빈 on 11/14/24.
//

import Foundation
import RxSwift
import KakaoSDKUser



final class LoginViewModel {
    
    private let network: LoginNetwork
    private let personalNetwork: PersonalNetwork
    
    init() {
        let networkProvider = NetworkProvider()
        network = networkProvider.makeLoginNetwork()
        personalNetwork = networkProvider.makePersonalNetwork()
    }
    
    struct Input {

    }
    
    struct Output {

    }
    
    public func transform(input:Input) -> Output {

        
        return Output()
    }
    
    public func refresh(refreshToken: String) -> Observable<Token> {
        var parameters: [String:Any] = [:]
        parameters["grant_type"] = "refresh_token"
        parameters["client_id"] = "859897bc7ad1eed0ca3e9bac1b83bb68"
        parameters["refresh_token"] = refreshToken
        
        return network.refreshToken(parameters: parameters)
    }
    
    public func login(accessToken: String) -> Observable<AccessTokenResponse> {
        return network.login(token: accessToken)
    }
    
    public func idCheck() -> Observable<NickNameResponse> {
        return personalNetwork.getNickName()
    }
}
    

