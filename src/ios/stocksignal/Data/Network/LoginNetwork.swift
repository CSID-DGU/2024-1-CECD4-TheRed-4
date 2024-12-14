//
//  LoginNetwork.swift
//  stocksignal
//
//  Created by 신예빈 on 11/14/24.
//

import Foundation
import RxSwift

final class LoginNetwork {
    private let accessNetwork: Network<AccessTokenResponse>
    private let tokenNetwork: Network<Token>
    
    
    init(accessNetwork: Network<AccessTokenResponse>, tokenNetwork: Network<Token>) {
        self.accessNetwork = accessNetwork
        self.tokenNetwork = tokenNetwork
    }
    
    public func login(token: String) -> Observable<AccessTokenResponse> {
        return self.accessNetwork.PostDataWithoutToken(path: "api/auth/kakao/login/token?token=\(token)", defaultValue: AccessTokenResponse(), updateData: [:])
    }
    
    public func refreshToken(parameters: [String: Any]) -> Observable<Token> {
        return self.tokenNetwork.KakaoPostData(parameters: parameters, defaultValue: Token())
    }
}

