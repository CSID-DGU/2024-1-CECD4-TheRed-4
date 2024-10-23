package com.thered.stocksignal.service.myBalance;

import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.kisApi.KisApiRequest;
import com.thered.stocksignal.service.company.CompanyService;
import com.thered.stocksignal.service.user.UserAccountService;
import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.springframework.stereotype.Service;
import com.thered.stocksignal.app.dto.CompanyDto.CompanyLogoResponseDto;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

import static com.thered.stocksignal.app.dto.MyBalanceDto.*;

@Service
@RequiredArgsConstructor
public class MyBalanceServiceImpl implements  MyBalanceService{

    private final KisApiRequest apiRequest;
    private final OkHttpClient client;
    private final ObjectMapper objectMapper;
    private final CompanyService companyService;
    private final UserAccountService userAccountService;

    // 내 잔고 조회
    public Optional<MyBalanceResponseDto> getMyBalance(Long userId) {

        userAccountService.refreshKisToken(userId);

        Optional<User> user = userAccountService.findById(userId);
        if (user.isEmpty()) return Optional.empty(); //USER_NOT_FOUND

        // API url
        String endpoint = "/uapi/domestic-stock/v1/trading/inquire-balance";

        // API 쿼리 파라미터
        String url = apiRequest.buildUrl(endpoint,
                "CANO=" + user.get().getAccountNumber(),
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
                .addHeader("authorization", "Bearer " + user.get().getKisToken())
                .addHeader("appkey", user.get().getAppKey())
                .addHeader("appsecret", user.get().getSecretKey())
                .addHeader("tr_id", "VTTC8434R")
                .build();

        try (Response response = client.newCall(request).execute()) {

            // 응답 본문을 JsonNode로 변환
            String jsonResponse = Objects.requireNonNull(response.body()).string();
            JsonNode jsonNode = objectMapper.readTree(jsonResponse);

            MyBalanceResponseDto myBalance = MyBalanceResponseDto.builder().build();
            List<StockResponseDto> stocks = new ArrayList<>(); // 주식 리스트

            // output1 : 보유 주식 개별 정보
            for (JsonNode stockNode : jsonNode.path("output1")) {

                StockResponseDto stock = StockResponseDto.builder().build();

                String companyName = stockNode.path("prdt_name").asText();
                stock.setStockName(companyName);   // 종목명
                stock.setQuantity(stockNode.path("hldg_qty").asLong());  // 수량
                stock.setAvgPrice(stockNode.path("pchs_avg_pric").asLong());  // 매입 평균가
                stock.setCurrentPrice(stockNode.path("prpr").asLong()); // 현재가
                stock.setPL(stockNode.path("evlu_pfls_amt").asLong()); // 손익
                String logoImage = companyService.findLogoByName(companyName)
                        .map(CompanyLogoResponseDto::getLogoImage)
                        .orElse(null); // TODO: null 대신 디폴트이미지 경로

                stock.setLogoImage(logoImage);
                // 로고 이미지

                stocks.add(stock); // 해당 주식을 리스트에 추가
            }

            // output2 : 보유 주식 총합 정보
            myBalance.setCash(jsonNode.path("output2").get(0).path("dnca_tot_amt").asLong());  // 예수금
            myBalance.setStocks(stocks);
            myBalance.setTotalStockPrice(jsonNode.path("output2").get(0).path("evlu_amt_smtl_amt").asLong()); // 보유 주식 전체 가치
            myBalance.setTotalStockPL(jsonNode.path("output2").get(0).path("evlu_pfls_smtl_amt").asLong());    // 보유 주식 전체 손익

            return Optional.of(myBalance);

        } catch (Exception e) {
            return Optional.empty();
        }
    }
}
