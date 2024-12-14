//
//  TradeNetwork.swift
//  stocksignal
//
//  Created by 신예빈 on 11/14/24.
//

import Foundation
import RxSwift
import SocketIO

final class TradeNetwork {
    private let codeNetwork: Network<CodeResponse>
    private let booleanNetwork: Network<BooleanResponse>
    
    init(codeNetwork: Network<CodeResponse>, booleanNetwork: Network<BooleanResponse>) {
        self.codeNetwork = codeNetwork
        self.booleanNetwork = booleanNetwork
    }
    
    public func getCode(stockName: String) -> Observable<CodeResponse> {
        return self.codeNetwork.getItemList(path: "api/company/\(stockName)/code", defaultValue: CodeResponse())
    }
    
    public func buyStock(updateData: [String: Any]) -> Observable<BooleanResponse> {
        return self.booleanNetwork.PostData(path: "api/trade/buy", defaultValue: BooleanResponse(), updateData: updateData)
    }
    
    public func sellStock(updateData: [String: Any]) -> Observable<BooleanResponse> {
        return self.booleanNetwork.PostData(path: "api/trade/sell", defaultValue: BooleanResponse(), updateData: updateData)
    }
    
    
}

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    var manager: SocketManager!
    var socket: SocketIOClient!

    override init() {
        super.init()
        manager = SocketManager(socketURL: URL(string: "wss://pposiraun.com")!,
                                config: [.log(true), .compress, .path("/stocksignal")])
        socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { data, ack in
            print("소켓 연결 성공")
            self.sendMessage()
        }

        socket.on(clientEvent: .disconnect) { data, ack in
            print("소켓 연결 종료")
        }

        socket.on("event") { data, ack in
            print("서버로부터 데이터 수신: \(data)")
        }

        socket.on("error") { data, ack in
            print("소켓 에러 발생: \(data)")
        }
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func sendMessage() {
        let message = [
            "action": "connect",
            "token": "Bearer aaaa",
            "companyName": "삼성전자"
        ]
        socket.emit("event", message)
    }
}


class WebSocketManager {
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession = URLSession(configuration: .default)
    private let url = URL(string: "wss://pposiraun.com/stocksignal")!

    func connect() {
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        print("WebSocket 연결 시도")

        // 초기 메시지 전송
        let initialMessage = [
            "action": "connect",
            "token": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsIm5pY2tuYW1lIjoi7ZmN7JuQ7KSAIiwiaWF0IjoxNzMxMDU0NzczLCJleHAiOjE3MzQ2NTQ3NzN9.gWoR45M4tTpwx1gyk8oiZqUQfvw3aHuaqDxXdKqilDs", "companyName": "삼성전자"
        ]
        send(message: initialMessage)

        // 메시지 수신 대기
        receiveMessage()
    }

    func send(message: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: message, options: []) else {
            print("메시지 변환 실패")
            return
        }
        webSocketTask?.send(.data(data)) { error in
            if let error = error {
                print("메시지 전송 실패: \(error)")
            } else {
                print("메시지 전송 성공")
            }
        }
    }

    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("서버로부터 데이터 수신: \(data)")
                case .string(let text):
                    print("서버로부터 메시지 수신: \(text)")
                @unknown default:
                    print("알 수 없는 메시지 수신")
                }
                // 다시 수신 대기
                self?.receiveMessage()
            case .failure(let error):
                print("메시지 수신 실패: \(error)")
            }
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        print("WebSocket 연결 종료")
    }
}
