package com.thered.stocksignal.service.trade;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thered.stocksignal.app.dto.TradeDto;
import com.thered.stocksignal.app.dto.kis.KisTradeDto;
import com.thered.stocksignal.domain.entity.Company;
import com.thered.stocksignal.domain.entity.Trade;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.domain.enums.OrderType;
import com.thered.stocksignal.domain.enums.TradeType;
import com.thered.stocksignal.repository.CompanyRepository;
import com.thered.stocksignal.repository.TradeRepository;
import com.thered.stocksignal.service.user.UserAccountService;
import com.thered.stocksignal.util.KisUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class TradeServiceImpl implements TradeService {

    private static final String baseUrl = "https://openapivts.koreainvestment.com:29443";

    private final UserAccountService userAccountService;
    private final TradeRepository tradeRepository;
    private final CompanyRepository companyRepository;

    private HttpHeaders makeHeaders(Long userId, String tr_id){
        User user = userAccountService.getUserById(userId).get();
        String accessToken = user.getKisToken();
        String appKey = user.getAppKey();
        String secretKey = user.getSecretKey();

        HttpHeaders header = new HttpHeaders(); // Http header
        header.set("content-type", "application/json; charset=utf-8");
        header.set("authorization", "Bearer " +accessToken);
        header.set("appkey", appKey);
        header.set("appsecret", secretKey);
        header.set("tr_id", tr_id);

        return header;
    }

    private Map<String, String> makeBody(
            User user, String PDNO, String ORD_DVSN, String ORD_QTY, String ORD_UNPR)
    {
        String account = user.getAccountNumber();
        String CANO = KisUtil.getCANO(account);
        String ACNT_PRDT_CD = KisUtil.getACNT_PRDT_CD(account);

        Map<String, String> body = new HashMap<>();
        body.put("CANO", CANO);
        body.put("ACNT_PRDT_CD", ACNT_PRDT_CD);
        body.put("PDNO", PDNO);
        body.put("ORD_DVSN", ORD_DVSN);
        body.put("ORD_QTY", ORD_QTY);
        body.put("ORD_UNPR", ORD_UNPR);

        return body;
    }

    private String trade(Long userId, TradeDto dto, String tr_id) {

        userAccountService.refreshKisToken(userId);

        User user = userAccountService.getUserById(userId)
                .orElseThrow(() -> new RuntimeException("존재하지 않는 회원입니다."));

        HttpHeaders header = makeHeaders(userId, tr_id);

        String orderType = dto.getOrderType().equals(OrderType.JIJUNG)? "00" : "01";

        Map<String, String> body = makeBody(user, dto.getScode(), orderType, dto.getWeek().toString(), dto.getPrice().toString());

        ObjectMapper objectMapper = new ObjectMapper();
        String jsonBody;
        try {
            jsonBody = objectMapper.writeValueAsString(body); // JSON 직렬화
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 오류", e);
        }

        HttpEntity<String> request = new HttpEntity<>(jsonBody, header);

        RestTemplate tokenRt = new RestTemplate();

        ResponseEntity<String> response = tokenRt.exchange(
                baseUrl+"/uapi/domestic-stock/v1/trading/order-cash",
                HttpMethod.POST,
                request,
                String.class
        ); // Request to Kis

        KisTradeDto.TradeResponseDto tradeResponseDto;

        String message = "true";
        try{
            tradeResponseDto = objectMapper.readValue(response.getBody(), KisTradeDto.TradeResponseDto.class);
            if(!tradeResponseDto.getRt_cd().equals("0")) message = "원인 : " + tradeResponseDto.getMsg1();
            else{
                Company company = companyRepository.findByCompanyCode(dto.getScode())
                        .orElseThrow(() -> new RuntimeException("존재하지 않는 회사 코드입니다."));

                TradeType type;
                if(tr_id.equals("VTTC0802U")) type = TradeType.BUY;
                else type = TradeType.SELL;

                Trade newTrade = Trade.builder()
                        .user(user)
                        .tradeDate(new Date())
                        .tradePrice(dto.getPrice())
                        .tradeQuantity(dto.getWeek())
                        .company(company)
                        .tradeType(type)
                        .build();

                tradeRepository.save(newTrade);
            }
        }catch(JsonMappingException e){
            throw new RuntimeException("JSON 파싱을 실패했습니다.", e);
        }catch (JsonProcessingException e){
            throw new RuntimeException("주문이 체결되지 않았습니다.", e);
        }
        return message;
    }

    @Override
    public String buy(Long userId, TradeDto dto) {

        return trade(userId, dto, "VTTC0802U");
    }

    @Override
    public String sell(Long userId, TradeDto dto) {

        return trade(userId, dto, "VTTC0801U");
    }
}
