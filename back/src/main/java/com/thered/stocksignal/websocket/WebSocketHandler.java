package com.thered.stocksignal.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.thered.stocksignal.app.dto.CompanyDto.SocketPayloadDto;
import com.thered.stocksignal.app.dto.StockDto;
import com.thered.stocksignal.app.dto.kis.KisSocketDto;
import com.thered.stocksignal.domain.entity.Scenario;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.domain.session.UserSession;
import com.thered.stocksignal.jwt.JWTUtil;
import com.thered.stocksignal.repository.CompanyRepository;
import com.thered.stocksignal.repository.ScenarioRepository;
import com.thered.stocksignal.repository.UserRepository;
import com.thered.stocksignal.service.company.CompanyService;
import com.thered.stocksignal.service.scenario.ScenarioTrade;
import com.thered.stocksignal.service.user.UserAccountService;
import jakarta.annotation.PostConstruct;
import jakarta.websocket.Session;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.net.URI;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@Component
@RequiredArgsConstructor
public class WebSocketHandler extends TextWebSocketHandler {

    private final ConcurrentHashMap<Long, UserSession> userSessions = new ConcurrentHashMap<>();
    private final Lock lock = new ReentrantLock();

    private final CompanyRepository companyRepository;
    private final ScenarioRepository scenarioRepository;
    private final UserRepository userRepository;

    private final JWTUtil jwtUtil;

    private final ScenarioTrade scenarioTrade;
    private final CompanyService companyService;
    private final UserAccountService userAccountService;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        System.out.println("새로운 WebSocket 세션이 연결되었습니다: " + session.getId());
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        System.out.println("WebSocket 세션이 종료되었습니다: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession clientSession, TextMessage message) throws Exception {

        lock.lock();
        try{
            // 클라이언트에서 보낸 메시지
            String payload = message.getPayload();
            ObjectMapper objectMapper = new ObjectMapper();
            SocketPayloadDto dto = objectMapper.readValue(payload, SocketPayloadDto.class);

            String token = dto.getToken();
            Long userId = userAccountService.getUserIdFromToken(token);
            String companyName = dto.getCompanyName();
            String companyCode = companyService.findCodeByName(companyName).get().getCompanyCode();

            if (userId == -1) {
                System.out.println("유효하지 않은 세션입니다. 유저 확인 불가능");
            }
            else{
                System.out.println("받은 메시지: " + payload);

                if(userSessions.get(userId) == null){
                    userSessions.put(userId, new UserSession(clientSession, null));
                }
                else{
                    userSessions.get(userId).setClientSession(clientSession);
                }

                // action에 따른 처리
                switch (dto.getAction()) {
                    case "connect":
                        handleKisSocketRequest(token, userId, companyCode, companyName, "1");
                        break;
                    case "disconnect":
                        handleKisSocketRequest(token, userId, companyCode, companyName, "2");
                        break;
                    default:
                        System.out.println("알 수 없는 action: " + dto.getAction());
                }
            }
        } finally {
            lock.unlock();
        }
    }

    // 한투 세션 관리
    public void updateKisSession(Session kisSession){
        String token =  (String)kisSession.getUserProperties().get("token");
        Long userId = userAccountService.getUserIdFromToken(token);// 토큰으로부터 사용자 ID 반환
        if (userId == -1) {
            System.out.println("유효하지 않은 세션입니다. 유저 확인 불가능");
        }
        else{
            UserSession userSession = userSessions.get(userId);

            if(userSession != null){    // 기존 세션 맵이 있는 경우
                userSession.setKisSession(kisSession); // 기존의 한투 세션 업데이트
            }
            else if(kisSession != null){   // 기존 세션 맵이 없는 경우, kisSession이 null이 아닐 때
                userSessions.put(userId, new UserSession(null, kisSession)); // 새로운 UserSession 생성
            }
        }
    }

    // 클라이언트로 메시지 전송
    public void sendMessageToClient(WebSocketSession session, StockDto.RealTimeStockDto dto) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            String message = objectMapper.writeValueAsString(dto);
            if(session.isOpen()){
                session.sendMessage(new TextMessage(message)); // dto를 문자열로 변환하여 클라이언트에게 전송
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 한투로 메시지 전송
    public void sendMessageToKis(String token, Long userId, KisSocketDto.KisSocketRequestDto request, String searchName) {

        // 세션 맵에서 찾을 수 있는 유저고, 한투 세션이 null이 아닐때,
        if(userSessions.containsKey(userId) && userSessions.get(userId).getKisSession()!=null){
            handleExistingSession(userId, request, searchName);
        }
        // 세션 맵에서 찾을 수 없거나, 한투 세션이 null일 때
        else if(request.getHeader().getTr_type().equals("1")){
            handleNewSession(token, userId, request, searchName);
        }
    }

    // 새 한투 세션 열기
    private void handleNewSession(String token, Long userId, KisSocketDto.KisSocketRequestDto request, String searchName) {
        try {

            final WebSocketEndpoint clientEndPoint = new WebSocketEndpoint();
            Session newSession = clientEndPoint.connect(new URI("ws://ops.koreainvestment.com:31000/tryitout/H0STASP0"), token);

            updateKisSession(newSession);

            ObjectMapper objectMapper = new ObjectMapper();
            String message = objectMapper.writeValueAsString(request);

            newSession.getAsyncRemote().sendText(message);

            clientEndPoint.addMessageHandler(response -> handleResponse(response, userId, searchName));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 기존 한투 세션 가져오기
    private void handleExistingSession(Long userId, KisSocketDto.KisSocketRequestDto request, String searchName) {
        String type = request.getHeader().getTr_type(); // tr_type : 1 등록 2 해제

        // 삭제 요청이고, 자동매매가 아닌 호가 조회 페이지 이탈에 의한 것이라면
        if(searchName != null && type.equals("2")){

            List<Scenario> scenarios = scenarioRepository.findByUserId(userId);
            boolean isEnrolled = false;

            for(Scenario scenario : scenarios){
                if(scenario.getCompany().getCompanyName() == searchName){
                    isEnrolled = true;
                    break;
                }
            }
            if(isEnrolled){
               return; // 유저의 자동매매 시나리오에 있는 주식은 등록을 해제하지 않음
            }
        }
        // 그외 모든 경우
        try {
            // userId에 해당하는 세션 가져오기
            UserSession existingSession = userSessions.get(userId);

            ObjectMapper objectMapper = new ObjectMapper();
            String message = objectMapper.writeValueAsString(request);

            // 기존 세션으로 업데이트된 메시지 전송
            existingSession.getKisSession().getAsyncRemote().sendText(message);
            System.out.println("변경된 메시지를 전송했습니다: " + message);

            if(type.equals("2")){
                // 삭제 후에 scenario 테이블에 아무것도 없다면 userSessions에서 세션을 가져오고 종료
                if(scenarioRepository.findByUserId(userId).isEmpty()){
                    try {
                        existingSession.setKisSession(null); // kis세션 제거
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 한투로부터 오는 응답 처리
    private void handleResponse(String response, Long userId, String searchName) {
        String[] parts = response.split("\\|");
        String[] data = parts[parts.length - 1].split("\\^");

        if (parts.length >= 4) {
            List<StockDto.RealTimeStockDto> stockInfoDtoList = parseStockInfo(data);
            for (StockDto.RealTimeStockDto dto : stockInfoDtoList) {
                if (dto.getCompanyName().equals(searchName)) {
                    StockDto.RealTimeStockDto realTimeStock = companyService.getRealTimeStock(userId, dto);
                    sendMessageToClient(userSessions.get(userId).getClientSession(), realTimeStock);
                }
                scenarioTrade.checkAutoTrade(userId, dto);
            }
        } else {
            System.out.println(response); // 초당 거래건수 초과 등
        }
    }

    // 응답 파싱
    private List<StockDto.RealTimeStockDto> parseStockInfo(String[] data) {
        List<List<String>> stockInfos = new ArrayList<>();
        List<StockDto.RealTimeStockDto> stockInfoDtoList = new ArrayList<>();

        // 정보 단위 그룹화
        for (int i = 0; i < data.length; i += 59) {
            List<String> stockInfo = new ArrayList<>();
            for (int j = i; j < i + 59 && j < data.length; j++) {
                stockInfo.add(data[j]);
            }
            stockInfos.add(stockInfo);
        }

        // 각 종목 정보 세트를 순회
        for (List<String> stockInfo : stockInfos) {
            System.out.println(stockInfo);

            if (!stockInfo.isEmpty()) {
                String companyCode = stockInfo.getFirst();
                String companyName = companyRepository.findByCompanyCode(companyCode).get().getCompanyName();

                StockDto.RealTimeStockDto stockInfoDto = StockDto.RealTimeStockDto.builder()
                        .companyName(companyName)
                        .time(stockInfo.get(1))

                        .sellPrice1(Long.parseLong(stockInfo.get(3)))
                        .sellPrice2(Long.parseLong(stockInfo.get(4)))
                        .sellPrice3(Long.parseLong(stockInfo.get(5)))
                        .sellPrice4(Long.parseLong(stockInfo.get(6)))
                        .sellPrice5(Long.parseLong(stockInfo.get(7)))
                        .sellPrice6(Long.parseLong(stockInfo.get(8)))

                        .buyPrice1(Long.parseLong(stockInfo.get(13)))
                        .buyPrice2(Long.parseLong(stockInfo.get(14)))
                        .buyPrice3(Long.parseLong(stockInfo.get(15)))
                        .buyPrice4(Long.parseLong(stockInfo.get(16)))
                        .buyPrice5(Long.parseLong(stockInfo.get(17)))
                        .buyPrice6(Long.parseLong(stockInfo.get(18)))

                        .sellQuantity1(Long.parseLong(stockInfo.get(23)))
                        .sellQuantity2(Long.parseLong(stockInfo.get(24)))
                        .sellQuantity3(Long.parseLong(stockInfo.get(25)))
                        .sellQuantity4(Long.parseLong(stockInfo.get(26)))
                        .sellQuantity5(Long.parseLong(stockInfo.get(27)))
                        .sellQuantity6(Long.parseLong(stockInfo.get(28)))

                        .buyQuantity1(Long.parseLong(stockInfo.get(33)))
                        .buyQuantity2(Long.parseLong(stockInfo.get(34)))
                        .buyQuantity3(Long.parseLong(stockInfo.get(35)))
                        .buyQuantity4(Long.parseLong(stockInfo.get(36)))
                        .buyQuantity5(Long.parseLong(stockInfo.get(37)))
                        .buyQuantity6(Long.parseLong(stockInfo.get(38)))
                        .build();

                stockInfoDtoList.add(stockInfoDto);
            }
        }
        return stockInfoDtoList;
    }

    // 한투 요청 메시지 양식 (type : "1"이면 등록, "2"면 해제)
    // 자동매매의 경우 searchName을 null로 설정바랍니다. searchName은 실시간 매매호가 검색시 쓰이는 종목명입니다.
    public void handleKisSocketRequest(String token, Long userId, String companyCode, String searchName, String type) {
        // 웹소켓 연결
        KisSocketDto.Header header = KisSocketDto.Header.builder()
                .approval_key(userRepository.findById(userId).get().getSocketKey())
                .custtype("P")
                .tr_type(type)
                .content_type("utf-8")
                .build();

        KisSocketDto.Input input = KisSocketDto.Input.builder()
                .tr_id("H0STASP0")
                .tr_key(companyCode)
                .build();

        KisSocketDto.Body body = KisSocketDto.Body.builder()
                .input(input)
                .build();

        KisSocketDto.KisSocketRequestDto request = KisSocketDto.KisSocketRequestDto.builder()
                .header(header)
                .body(body)
                .build();

        try{
            sendMessageToKis(token, userId, request, searchName);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    // 서버 재시작 시 모든 유저의 세션을 재연결
    @PostConstruct
    public void reconnectAllKisSocketSessions() {
        List<User> users = userRepository.findAll(); // 모든 유저 ID
        for (User user : users) {

            Long userId = user.getId();
            String nickname = user.getNickname();
            Long expirationTime = 86400000L; // 24시간

            List<Scenario> scenarios = scenarioRepository.findByUserId(userId);

            // 유저의 구독 요청 재전송
            for(Scenario scenario : scenarios){
                String companyCode = scenario.getCompany().getCompanyCode();
                String companyName = scenario.getCompany().getCompanyName();
                String token = jwtUtil.createJwt(userId, nickname);

                // 각 사용자마다 연결
                handleKisSocketRequest(token, userId, companyCode, null, "1");
            }
        }
    }
}