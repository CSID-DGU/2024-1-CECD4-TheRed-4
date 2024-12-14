//
//  Personal.swift
//  stocksignal
//
//  Created by 신예빈 on 11/11/24.
//

import Foundation

struct BooleanResponse: Decodable {
    let code: String?
    let result: String?
    let message: String?
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
    }
}

struct NickNameResponse: Decodable {
    let code: String
    let result: String
    let message: String
    let data: NickName
    
    init() {
        self.code = "401"
        self.result = "FAILURE"
        self.message = "서버 연결에 실패했습니다."
        self.data = NickName()
    }
}

struct NickName: Decodable, Hashable {
    let nickname: String
    
    private enum CodingKeys: String, CodingKey {
        case nickname
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nickname = try container.decode(String.self, forKey: .nickname)
    }
    
    init() {
        self.nickname = ""
    }
}
