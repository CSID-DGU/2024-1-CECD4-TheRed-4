//
//  Token.swift
//  stocksignal
//
//  Created by 신예빈 on 11/20/24.
//

import Foundation

struct Token: Decodable, Hashable {
    let access_token: String
    let token_type: String
    let refresh_token: String
    let refresh_token_expires_in: Int
    let expires_in: Int
    
    private enum CodingKeys: String, CodingKey {
        case access_token
        case token_type
        case refresh_token
        case refresh_token_expires_in
        case expires_in
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.access_token = try container.decode(String.self, forKey: .access_token)
        self.token_type = try container.decode(String.self, forKey: .token_type)
        self.refresh_token = try container.decode(String.self, forKey: .refresh_token)
        self.refresh_token_expires_in = try container.decode(Int.self, forKey: .refresh_token_expires_in)
        self.expires_in = try container.decode(Int.self, forKey: .expires_in)
    }
    
    init() {
        self.access_token = ""
        self.token_type = ""
        self.refresh_token = ""
        self.refresh_token_expires_in = 0
        self.expires_in = 0
    }
}

struct AccessTokenResponse: Decodable {
    let code: String
    let result: String
    let message: String
    let data: AccessToken
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = AccessToken()
    }
}

struct AccessToken: Decodable, Hashable {
    let userId: Int
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case userId
        case token
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.token = try container.decode(String.self, forKey: .token)
    }
    
    init() {
        self.userId = 0
        self.token = ""
    }
}
