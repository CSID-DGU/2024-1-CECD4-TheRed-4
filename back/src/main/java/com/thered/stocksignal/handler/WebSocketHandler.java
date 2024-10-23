/*

package com.thered.stocksignal.handler;

import com.thered.stocksignal.domain.entity.Scenario;
import com.thered.stocksignal.domain.entity.ScenarioCondition;
import com.thered.stocksignal.domain.enums.BuysellType;
import com.thered.stocksignal.domain.enums.MethodType;
import com.thered.stocksignal.repository.ScenarioConditionRepository;
import com.thered.stocksignal.repository.ScenarioRepository;
import com.thered.stocksignal.service.trade.TradeService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompSessionHandler;
import org.springframework.messaging.simp.stomp.StompHeaders;
import org.springframework.messaging.simp.stomp.StompSession;
import org.springframework.stereotype.Component;

import java.lang.reflect.Type;
import java.util.List;

@Component
@RequiredArgsConstructor
public class PriceHandler implements StompSessionHandler {

    private final TradeService tradingService;
    private final ScenarioRepository scenarioRepository;
    private final ScenarioConditionRepository scenarioConditionRepository;

    @Override
    public void afterConnected(StompSession session, StompHeaders connectedHeaders) {
        String approvalKey = "cfwf322432"; // 발급받은 웹소켓 접속키
        String trId = "H0STCNT0"; // 실시간 주식 체결가

        // 데이터베이스에서 모든 시나리오를 로드
        List<Scenario> scenarios = scenarioRepository.findAll();

        // 각 시나리오에 대해 구독 요청 전송
        for (Scenario scenario : scenarios) {
            String trKey = scenario.getCompany().getCompanyCode(); // 종목 코드

            // JSON 형식의 구독 요청 본문
            String requestBody = String.format(
                    "{\"header\":{\"approval_key\":\"%s\",\"custtype\":\"P\",\"tr_type\":\"1\",\"content-type\":\"utf-8\"}," +
                            "\"body\":{\"input\":{\"tr_id\":\"%s\",\"tr_key\":\"%s\"}}}",
                    approvalKey, trId, trKey
            );

            // 구독 요청 전송
            session.send("/topic/subscribe", requestBody);
        }
    }


    @Override
    public Type getPayloadType(StompHeaders headers) {
        return String.class;
    }

    @Override
    public void handleFrame(StompHeaders headers, Object payload) {
        String message = (String) payload;
        processMessage(message);
    }

    private void processMessage(String message) {
        // 메시지를 "|"로 구분하고 매도호가/매수호가 추출
        String[] parts = message.split("\\|");

        // 응답 형식 체크 (암호화 유무, TR_ID, 데이터 건수)
        if (parts.length < 4) return; // 데이터가 부족하면 리턴

        int dataCount = Integer.parseInt(parts[2]); // 데이터 건수

        for (int i = 0; i < dataCount; i++) {
            String[] responseData = parts[i + 3].split("\\^");
            String sellPrice = responseData[10]; // 매도호가
            String buyPrice = responseData[11]; // 매수호가

            // 데이터베이스에서 모든 시나리오 조건들 로드
            List<ScenarioCondition> scList = scenarioConditionRepository.findAll();

            // 모든 시나리오 조건에 대해 체크
            for (ScenarioCondition sc : scList) {
                executeTrade(sc, sellPrice, buyPrice);
            }
        }
    }

    private void executeTrade(ScenarioCondition sc, String sellPrice, String buyPrice) {
        Long currentSellPrice = Long.parseLong(sellPrice); // 매도호가
        Long currentBuyPrice = Long.parseLong(buyPrice); // 매수호가

        if (sc.getMethodType() == MethodType.RATE || sc.getMethodType() == MethodType.PRICE) {

            if (sc.getBuysellType() == BuysellType.BUY) {

                if (sc.getTargetPrice1() != null && currentBuyPrice >= sc.getTargetPrice1()) {
                    // buy(sc.getUserId(), sc.getScenario().getCompany().getCompanyCode(), sc.getQuantity());
                }
                if (sc.getTargetPrice2() != null && currentBuyPrice <= sc.getTargetPrice2()) {
                    // buy(sc.getUserId(), sc.getScenario().getCompany().getCompanyCode(), sc.getQuantity());
                }

            } else if (sc.getBuysellType() == BuysellType.SELL) {

                if (sc.getTargetPrice1() != null && currentBuyPrice >= sc.getTargetPrice1()) {
                    // sell(sc.getUserId(), sc.getScenario().getCompany().getCompanyCode(), sc.getQuantity());
                }
                if (sc.getTargetPrice2() != null && currentBuyPrice <= sc.getTargetPrice2()) {
                    // sell(sc.getUserId(), sc.getScenario().getCompany().getCompanyCode(), sc.getQuantity());
                }
            }
        }

        if (sc.getMethodType() == MethodType.TRADING) {

            if (sc.getBuysellType() == BuysellType.BUY) {

                // 상승 -> 하락
                if (sc.getTargetPrice1() != null && currentBuyPrice >= sc.getTargetPrice1()) {
                    sc.setPrice1Reached(true);
                    scenarioConditionRepository.save(sc);
                }
                else if (sc.getTargetPrice2() != null && currentBuyPrice <= sc.getTargetPrice2() && sc.isPrice1Reached() == true) {
                    // buy(sc.getUserId(), sc.getScenario().getCompany().getCompanyCode(), sc.getQuantity());
                }

                // 하락 -> 상승
                if (sc.getTargetPrice3() != null && currentBuyPrice <= sc.getTargetPrice3()) {
                    sc.setPrice3Reached(true);
                    scenarioConditionRepository.save(sc);
                }
                else if (sc.getTargetPrice4() != null && currentBuyPrice >= sc.getTargetPrice4() && sc.isPrice3Reached() == true) {
                    // buy(sc.getUserId(), sc.getScenario().getCompany().getCompanyCode(), sc.getQuantity());
                }

            } else if (sc.getBuysellType() == BuysellType.SELL) {

                // 상승 -> 하락
                if (sc.getTargetPrice1() != null && currentBuyPrice >= sc.getTargetPrice1()) {
                    sc.setPrice1Reached(true);
                    scenarioConditionRepository.save(sc);
                }
                if (sc.getTargetPrice2() != null && currentBuyPrice <= sc.getTargetPrice2() && sc.isPrice1Reached() == true) {
                    // sell(sc.getUserId(), sc.getScenario().getCompany().getCompanyCode(), sc.getQuantity());
                }

                // 하락 -> 상승
                if (sc.getTargetPrice3() != null && currentBuyPrice <= sc.getTargetPrice3()) {
                    sc.setPrice3Reached(true);
                    scenarioConditionRepository.save(sc);
                }
                else if (sc.getTargetPrice4() != null && currentBuyPrice >= sc.getTargetPrice4() && sc.isPrice3Reached() == true) {
                    // sell(sc.getUserId(), sc.getScenario().getCompany().getCompanyCode(), sc.getQuantity());
                }
            }
        }
    }

    public void handleException(StompSession session, StompCommand command, StompHeaders headers, byte[] payload, Throwable exception){};

    public void handleTransportError(StompSession session, Throwable error){};
}

*/
