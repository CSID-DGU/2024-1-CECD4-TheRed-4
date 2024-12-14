package com.thered.stocksignal.domain.session;

import jakarta.websocket.Session;
import lombok.*;
import org.springframework.web.socket.WebSocketSession;

@Getter
@Setter
@AllArgsConstructor
public class UserSession {
    private WebSocketSession clientSession; // 클라이언트와의 세션
    private Session kisSession;     // 한국투자증권과의 세션
}
