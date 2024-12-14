package com.thered.stocksignal.service.company;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thered.stocksignal.app.dto.StockDto.popularStockResponseDto;
import com.thered.stocksignal.domain.entity.Company;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.util.KisUtil;
import com.thered.stocksignal.repository.CompanyRepository;
import com.thered.stocksignal.service.user.UserAccountService;
import jakarta.persistence.EntityNotFoundException;
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
    private final KisUtil kisUtil;
    private final OkHttpClient client;
    private final ObjectMapper objectMapper;
    private final UserAccountService userAccountService;

    @Override
    public CompanyCodeResponseDto getCodeByName(String companyName) {
        Optional<Company> company = companyRepository.findByCompanyName(companyName);
        if (company.isEmpty()) throw new EntityNotFoundException("회사 정보가 없습니다: " + companyName);

        CompanyCodeResponseDto companyCode = CompanyCodeResponseDto.builder().build();
        companyCode.setCompanyCode(company.get().getCompanyCode());

        return companyCode;
    }

    @Override
    public CompanyLogoResponseDto getLogoByName(String companyName) {
        Optional<Company> company = companyRepository.findByCompanyName(companyName);
        if (company.isEmpty()) throw new EntityNotFoundException("회사 정보가 없습니다: " + companyName);

        CompanyLogoResponseDto companyLogo = CompanyLogoResponseDto.builder().build();
        companyLogo.setLogoImage(company.get().getLogoImage());

        return companyLogo;
    }

    @Override
    public CompanyInfoResponseDto getCompanyInfoByCode(String companyCode, Long userId) {

        userAccountService.refreshKisToken(userId);

        Optional<User> user = userAccountService.getUserById(userId);

        Optional<Company> company = companyRepository.findByCompanyCode(companyCode);
        if(company.isEmpty()) throw new EntityNotFoundException("회사 정보가 없습니다: " + companyCode);

        // API url
        String endpoint = "/uapi/domestic-stock/v1/quotations/inquire-price";

        // API 쿼리 파라미터
        String url = kisUtil.buildUrl(endpoint,
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

            return companyInfo;

        } catch (Exception e) {
            throw new RuntimeException("한투에서 온 응답 내용이 예상된 양식과 불일치합니다.");
        }
    }

    @Override
    public CurrentPriceResponseDto getCurrentPriceByCode(String companyCode, Long userId){

        userAccountService.refreshKisToken(userId);

        Optional<User> user = userAccountService.getUserById(userId);

        Optional<Company> company = companyRepository.findByCompanyCode(companyCode);
        if(company.isEmpty()) throw new EntityNotFoundException("회사 정보가 없습니다: " + companyCode);

        // API url
        String endpoint = "/uapi/domestic-stock/v1/quotations/inquire-price";

        // API 쿼리 파라미터
        String url = kisUtil.buildUrl(endpoint,
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

            currentPrice.setCurrentPrice(output.path("stck_prpr").asLong());   // 현재가

            return currentPrice;

        } catch (Exception e) {
            throw new RuntimeException("한투에서 온 응답 내용이 예상된 양식과 불일치합니다.");
        }
    }

    @Override
    public PeriodPriceResponseDto getPeriodPriceByCode(String companyCode, String startDate, String endDate, Long userId){

        userAccountService.refreshKisToken(userId);

        Optional<User> user = userAccountService.getUserById(userId);

        Optional<Company> company = companyRepository.findByCompanyCode(companyCode);
        if(company.isEmpty()) throw new EntityNotFoundException("회사 정보가 없습니다: " + companyCode);

        // API url
        String endpoint = "/uapi/domestic-stock/v1/quotations/inquire-daily-itemchartprice";

        // API 쿼리 파라미터
        String url = kisUtil.buildUrl(endpoint,
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
                dailyPrice.setStartPrice(dailyNode.path("stck_oprc").asLong());   // 시가
                dailyPrice.setClosePrice(dailyNode.path("stck_clpr").asLong());   // 종가
                dailyPrice.setHighPrice(dailyNode.path("stck_hgpr").asLong());   // 고가
                dailyPrice.setLowPrice(dailyNode.path("stck_lwpr").asLong());   // 저가
                dailyPrice.setTradingVolume(dailyNode.path("acml_vol").asLong());   // 거래량

                dailyPriceList.add(dailyPrice);
            }

            periodPrice.setPeriodPrice(dailyPriceList);

            return periodPrice;

        } catch (Exception e) {
            throw new RuntimeException("한투에서 온 응답 내용이 예상된 양식과 불일치합니다.");
        }
    }

    @Override
    public List<popularStockResponseDto> getPopularStocks() {
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

            return popularStocks;

        } catch (Exception e) {
            throw new RuntimeException("인기 종목을 불러올 수 없습니다. (네이버 증권 구성 변경 등)");
        }
    }

    @Override
    public RealTimeStockDto getRealTimeStock(Long userId, RealTimeStockDto dto) {
        String companyName = dto.getCompanyName();
        String companyCode = getCodeByName(companyName).getCompanyCode();
        dto.setLatestPrice(getCurrentPriceByCode(companyCode, userId).getCurrentPrice());
        return dto;
    }
}
