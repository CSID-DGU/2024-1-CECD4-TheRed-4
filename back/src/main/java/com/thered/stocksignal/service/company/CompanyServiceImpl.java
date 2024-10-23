package com.thered.stocksignal.service.company;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thered.stocksignal.app.dto.StockDto.popularStockResponseDto;
import com.thered.stocksignal.domain.entity.Company;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.kisApi.KisApiRequest;
import com.thered.stocksignal.repository.CompanyRepository;
import com.thered.stocksignal.service.user.UserAccountService;
import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

import static com.thered.stocksignal.app.dto.CompanyDto.*;
import static com.thered.stocksignal.app.dto.StockDto.*;

@Service
@RequiredArgsConstructor
public class CompanyServiceImpl implements CompanyService {

    private final CompanyRepository companyRepository;
    private final KisApiRequest apiRequest;
    private final OkHttpClient client;
    private final ObjectMapper objectMapper;
    private final UserAccountService userAccountService;

    @Override
    public Optional<CompanyCodeResponseDto> findCodeByName(String companyName) {
        Optional<Company> company = companyRepository.findByCompanyName(companyName);
        if (company.isEmpty()) return Optional.empty();

        CompanyCodeResponseDto companyCode = CompanyCodeResponseDto.builder().build();
        companyCode.setCompanyCode(company.get().getCompanyCode());

        return Optional.of(companyCode);
    }

    @Override
    public Optional<CompanyLogoResponseDto> findLogoByName(String companyName) {
        Optional<Company> company = companyRepository.findByCompanyName(companyName);
        if (company.isEmpty()) return Optional.empty();

        CompanyLogoResponseDto companyLogo = CompanyLogoResponseDto.builder().build();
        companyLogo.setLogoImage(company.get().getLogoImage());
        return Optional.of(companyLogo);
    }

    @Override
    public Optional<CompanyInfoResponseDto> findCompanyInfoByCode(String companyCode, Long userId) {

        userAccountService.refreshKisToken(userId);

        Optional<User> user = userAccountService.findById(userId);
        if (user.isEmpty()) return Optional.empty(); //USER_NOT_FOUND

        // API url
        String endpoint = "/uapi/domestic-stock/v1/quotations/inquire-price";

        // API 쿼리 파라미터
        String url = apiRequest.buildUrl(endpoint,
                "FID_COND_MRKT_DIV_CODE=J",
                "FID_INPUT_ISCD="+companyCode
        );

        // 요청 헤더 생성
        Request request = new Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer " + user.get().getKisToken())
                .addHeader("appkey", user.get().getAppKey())
                .addHeader("appsecret", user.get().getSecretKey())
                .addHeader("tr_id", "FHKST01010100")
                .build();

        try (Response response = client.newCall(request).execute()) {

            // 응답 본문을 JsonNode로 변환
            String jsonResponse = Objects.requireNonNull(response.body()).string();
            JsonNode jsonNode = objectMapper.readTree(jsonResponse);
            JsonNode output = jsonNode.path("output");

            CompanyInfoResponseDto companyInfo = CompanyInfoResponseDto.builder().build();

            companyInfo.setOpenPrice(output.path("stck_oprc").asLong());   // 시가
            companyInfo.setClosePrice(output.path("stck_prpr").asLong());   // 종가(현재가)
            companyInfo.setLowPrice(output.path("stck_lwpr").asLong());   // 저가
            companyInfo.setHighPrice(output.path("stck_hgpr").asLong());   // 고가
            companyInfo.setTradingVolume(output.path("acml_vol").asLong());   // 거래량
            companyInfo.setTradingValue(output.path("acml_tr_pbmn").asLong());   // 거래대금
            companyInfo.setOneYearHighPrice(output.path("stck_dryy_hgpr").asLong());   // 연중최고가
            companyInfo.setOneYearLowPrice(output.path("stck_dryy_lwpr").asLong());   // 연중최저가

            return Optional.of(companyInfo);

        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<CurrentPriceResponseDto> findCurrentPriceByCode(String companyCode, Long userId){

        userAccountService.refreshKisToken(userId);

        Optional<User> user = userAccountService.findById(userId);
        if (user.isEmpty()) return Optional.empty(); //USER_NOT_FOUND

        // API url
        String endpoint = "/uapi/domestic-stock/v1/quotations/inquire-price";

        // API 쿼리 파라미터
        String url = apiRequest.buildUrl(endpoint,
                "FID_COND_MRKT_DIV_CODE=J",
                "FID_INPUT_ISCD="+companyCode
        );

        // 요청 헤더 생성
        Request request = new Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer " + user.get().getKisToken())
                .addHeader("appkey", user.get().getAppKey())
                .addHeader("appsecret", user.get().getSecretKey())
                .addHeader("tr_id", "FHKST01010100")
                .build();

        try (Response response = client.newCall(request).execute()) {

            // 응답 본문을 JsonNode로 변환
            String jsonResponse = Objects.requireNonNull(response.body()).string();
            JsonNode jsonNode = objectMapper.readTree(jsonResponse);
            JsonNode output = jsonNode.path("output");

            CurrentPriceResponseDto currentPrice = CurrentPriceResponseDto.builder().build();

            currentPrice.setCurrentPrice(output.path("stck_oprc").asLong());   // 현재가

            return Optional.of(currentPrice);

        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<PeriodPriceResponseDto> findPeriodPriceByCode(String companyCode, String startDate, String endDate, Long userId){

        userAccountService.refreshKisToken(userId);

        Optional<User> user = userAccountService.findById(userId);
        if (user.isEmpty()) return Optional.empty(); //USER_NOT_FOUND

        // API url
        String endpoint = "/uapi/domestic-stock/v1/quotations/inquire-daily-itemchartprice";

        // API 쿼리 파라미터
        String url = apiRequest.buildUrl(endpoint,
                "FID_COND_MRKT_DIV_CODE=J",
                "FID_INPUT_ISCD=" + companyCode,
                "FID_INPUT_DATE_1=" + startDate,
                "FID_INPUT_DATE_2=" + endDate,
                "FID_PERIOD_DIV_CODE=D",
                "FID_ORG_ADJ_PRC=0"
        );

        // 요청 헤더 생성
        Request request = new Request.Builder()
                .url(url)
                .addHeader("content-type", "application/json; charset=utf-8")
                .addHeader("authorization", "Bearer " + user.get().getKisToken())
                .addHeader("appkey", user.get().getAppKey())
                .addHeader("appsecret", user.get().getSecretKey())
                .addHeader("tr_id", "FHKST03010100")
                .build();

        try (Response response = client.newCall(request).execute()) {

            // 응답 본문을 JsonNode로 변환
            String jsonResponse = Objects.requireNonNull(response.body()).string();
            JsonNode jsonNode = objectMapper.readTree(jsonResponse);

            PeriodPriceResponseDto periodPrice = PeriodPriceResponseDto.builder().build();
            List<DailyPriceResponseDto> dailyPriceList = new ArrayList<>();

            for (JsonNode dailyNode : jsonNode.path("output2")) {

                DailyPriceResponseDto dailyPrice = DailyPriceResponseDto.builder().build();

                dailyPrice.setDate(dailyNode.path("stck_bsop_date").asText());   // 날짜
                dailyPrice.setClosePrice(dailyNode.path("stck_clpr").asLong());   // 종가
                dailyPrice.setTradingVolume(dailyNode.path("acml_vol").asLong());   // 거래량

                dailyPriceList.add(dailyPrice);
            }

            periodPrice.setPeriodPrice(dailyPriceList);

            return Optional.of(periodPrice);

        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<List<popularStockResponseDto>> getPopularStocks() {
        List<popularStockResponseDto> popularStocks = new ArrayList<>();
        try {
            String url = "https://finance.naver.com/sise/lastsearch2.naver";
            Document document = Jsoup.connect(url).get();

            // 주식 테이블에서 데이터 추출
            Elements rows = document.select("table.type_5 tbody tr");

            // 상위 10개 종목 가져오기
            for (int i = 1; i <= 14 && i < rows.size(); i++) { // 첫 번째 행은 헤더이므로 1부터 시작
                Element row = rows.get(i);

                String rankText = row.select("td.no").text();
                if (rankText.isEmpty()) {
                    continue; // 빈 문자열이면 건너뜀
                }

                popularStockResponseDto popularStock = popularStockResponseDto.builder().build();
                popularStock.setRank(Integer.parseInt(rankText)); // 순위
                popularStock.setCompanyName(row.select("td a.tltle").text()); // 종목명

                popularStocks.add(popularStock);
            }

            return Optional.of(popularStocks);

        } catch (Exception e) {
            return Optional.empty();
        }
    }
}
