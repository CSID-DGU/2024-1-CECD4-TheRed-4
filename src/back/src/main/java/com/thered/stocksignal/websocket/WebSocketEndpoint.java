package com.thered.stocksignal.websocket;

import jakarta.websocket.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.net.URI;
import java.text.ParseException;

@Slf4j
@ClientEndpoint
@RequiredArgsConstructor
public class WebSocketEndpoint {

    Session userSession = null;
    private MessageHandler messageHandler;
    private String token;

    // 서버와 세션 연결
    // 서버로 메시지 전송 : session.getAsyncRemote().sendText(message); 와 같이 수행
    public Session connect(URI uri, String token){
        try {
            WebSocketContainer container = ContainerProvider
                    .getWebSocketContainer();
            container.connectToServer(this, uri);

            this.token =token;
            insertToken(userSession);

            return userSession;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // 세션에 토큰 삽입
    private void insertToken(Session session) {
        userSession.getUserProperties().put("token", "Bearer " + token);
    }

    // 한투 소켓 연결 성공시
    @OnOpen
    public void onOpen(Session kisSession) {
        this.userSession = kisSession;
        log.info("새로운 WebSocket 세션이 연결되었습니다: {}", userSession.getId());
    }

    // 한투 소켓 연결 종료시
    @OnClose
    public void onClose() {
        log.info("웹소켓 연결이 종료되었습니다: {}", userSession.getId());
        this.userSession = null;
    }


    // 한투 응답 메시지 처리
    @OnMessage
    public void onMessage(String message) throws ParseException, IOException {
        if (this.messageHandler != null) {
            this.messageHandler.handleResponse(message);
        }
    }

    // 메시지 핸들러 추가
    public void addMessageHandler(MessageHandler msgHandler) {
        this.messageHandler = msgHandler;
    }

    // 메시지 핸들러
    public interface MessageHandler {
        void handleResponse(String message) throws ParseException, IOException;
    }

}