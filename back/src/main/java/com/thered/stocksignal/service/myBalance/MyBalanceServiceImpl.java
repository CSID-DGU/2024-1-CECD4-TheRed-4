package com.thered.stocksignal.service.myBalance;

import com.thered.stocksignal.domain.entity.Company;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.domain.entity.UserStock;
import com.thered.stocksignal.domain.enums.OauthType;
import com.thered.stocksignal.kisApi.KisApiRequest;
import com.thered.stocksignal.repository.UserStockRepository;
import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static com.thered.stocksignal.app.dto.MyBalanceDto.*;

@Service
@RequiredArgsConstructor
public class MyBalanceServiceImpl implements  MyBalanceService{

    private final KisApiRequest apiRequest;
    private final OkHttpClient client;
    private final ObjectMapper objectMapper;
    private final UserStockRepository userStockRepository;

    // 내 잔고 조회
    public MyBalanceResponseDto getMyBalance(String accountNumber, String accessToken, String appKey, String appSecret) {

        // API url
        String endpoint = "/uapi/domestic-stock/v1/trading/inquire-balance";

        // API 쿼리 파라미터
        String url = apiRequest.buildUrl(endpoint,
                "CANO=" + accountNumber,
                "ACNT_PRDT_CD=01",
                "AFHR_FLPR_YN=N",
                "INQR_DVSN=02",
                "UNPR_DVSN=01",
                "FUND_STTL_ICLD_YN=N",
                "FNCG_AMT_AUTO_RDPT_YN=N",
                "PRCS_DVSN=00",
                "OFL_YN=",
                "CTX_AREA_FK100=",
                "CTX_AREA_NK100="
        );

        // 요청 헤더 생성
        Request request = new Request.Builder()
                .url(url)
                .addHeader("content-type", "application/json")
                .addHeader("authorization", "Bearer " + accessToken)
                .addHeader("appkey", appKey)
                .addHeader("appsecret", appSecret)
                .addHeader("tr_id", "VTTC8434R")
                .build();

        try (Response response = client.newCall(request).execute()) {

            // 응답 본문을 JsonNode로 변환
            String jsonResponse = Objects.requireNonNull(response.body()).string();
            JsonNode jsonNode = objectMapper.readTree(jsonResponse);

            MyBalanceResponseDto myBalanceDto = MyBalanceResponseDto.builder().build();
            List<StockResponseDto> stocks = new ArrayList<>(); // 주식 리스트

            // output1 : 보유 주식 개별 정보
            for (JsonNode stockNode : jsonNode.path("output1")) {

                StockResponseDto stock = StockResponseDto.builder().build();

                stock.setStockName(stockNode.path("prdt_name").asText());   // 종목명
                stock.setQuantity(stockNode.path("hldg_qty").asLong());  // 수량
                stock.setAvgPrice(stockNode.path("pchs_avg_pric").asLong());  // 매입 평균가
                stock.setCurrentPrice(stockNode.path("prpr").asLong()); // 현재가
                stock.setPL(stockNode.path("evlu_pfls_amt").asLong()); // 손익

                stocks.add(stock); // 해당 주식을 리스트에 추가

                // 조회한 내역을 UserStock DB에 업데이트함
                updateUserStock(1L, stockNode, 10L, 9900L);
                // TODO : DB 업데이트시 실제 얻은 값들로 수행
                // updateUserStock(userId, stockNode, quantity, currentPrice);
            }

            // output2 : 보유 주식 총합 정보
            myBalanceDto.setCash(jsonNode.path("output2").get(0).path("dnca_tot_amt").asLong());  // 예수금
            myBalanceDto.setStocks(stocks);
            myBalanceDto.setTotalStockPrice(jsonNode.path("output2").get(0).path("evlu_amt_smtl_amt").asLong()); // 보유 주식 전체 가치
            myBalanceDto.setTotalStockPL(jsonNode.path("output2").get(0).path("evlu_pfls_smtl_amt").asLong());    // 보유 주식 전체 손익

            return myBalanceDto;

        } catch (IOException e) {
            return null;
            // TODO : 실패 시 Status 반환
            // ApiResponse.onFailure(Status.MY_BALANCE_FAILURE);
        }
    }

    public void updateUserStock(Long userId, JsonNode stockNode, Long quantity, Long currentPrice) {

        Long companyId = 1L; // 종목 ID 가져오기

        // TODO : 실제 companyId를 가져오도록 변경
        // Long companyId = stockNode.path("company_id").asLong();

        UserStock userStock = null; // 사용자 ID와 종목 ID로 UserStock 가져오기

        // TODO : 실제 UserStock을 가져오도록 변경
        // UserStock userStock = userStockRepository.findByUserIdAndComapnyId(userId, companyId);

        /*
        TODO : User와 Company 객체를 DB에서 조회하도록 변경
        User user = userRepository.findById(userId);
        Company company = companyRepository.findById(companyId);
        */

        if (userStock != null) {
            // 이미 존재하면 업데이트
            userStock.setStockCount((long) quantity);
            userStock.setTotalPrice((long) (quantity * currentPrice));
            userStockRepository.save(userStock);
        }
        else {
            // 존재하지 않으면 새로 생성
            // TODO : 아래 예시를 실제 User 및 Company 객체로 변경
            UserStock newUserStock = UserStock.builder()
                    .user(new User(1L,"삼성전자","닉네임", OauthType.KAKAO,"1","1","1",true))
                    .company(new Company(1L,"065824", "삼성전자", "image"))
                    .stockCount(10L)
                    .totalPrice(99000L)
                    .build();
            userStockRepository.save(newUserStock);
        }
    }
}
