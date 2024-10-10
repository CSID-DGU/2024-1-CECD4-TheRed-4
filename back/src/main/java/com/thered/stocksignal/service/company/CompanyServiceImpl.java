package com.thered.stocksignal.service.company;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thered.stocksignal.domain.entity.Company;
import com.thered.stocksignal.kisApi.KisApiRequest;
import com.thered.stocksignal.repository.CompanyRepository;
import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static com.thered.stocksignal.app.dto.CompanyDto.*;
import static com.thered.stocksignal.app.dto.StockDto.*;

@Service
@RequiredArgsConstructor
public class CompanyServiceImpl implements CompanyService {

    private final CompanyRepository companyRepository;
    private final KisApiRequest apiRequest;
    private final OkHttpClient client;
    private final ObjectMapper objectMapper;

    @Override
    public CompanyCodeResponseDto findCodeByName(String companyName) {
        Company company = companyRepository.findByCompanyName(companyName);
        CompanyCodeResponseDto companyCode = CompanyCodeResponseDto.builder().build();

        companyCode.setCompanyCode(company != null ? company.getCompanyCode() : null);
        return companyCode;
    }

    @Override
    public CompanyLogoResponseDto findLogoByName(String companyName) {
        Company company = companyRepository.findByCompanyName(companyName);
        CompanyLogoResponseDto companyLogo = CompanyLogoResponseDto.builder().build();

        companyLogo.setLogoImage(company != null ? company.getLogoImage() : null);
        return companyLogo;
    }

    @Override
    public CompanyInfoResponseDto findCompanyInfoByCode(String companyCode, String accessToken, String appKey, String appSecret) {

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
                .addHeader("authorization", "Bearer " + accessToken)
                .addHeader("appkey", appKey)
                .addHeader("appsecret", appSecret)
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

        } catch (IOException e) {
            return null;
            // TODO : 실패 시 Status 반환
            // ApiResponse.onFailure(Status.);
        }
    }

    @Override
    public CurrentPriceResponseDto findCurrentPriceByCode(String companyCode, String accessToken, String appKey, String appSecret){

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
                .addHeader("authorization", "Bearer " + accessToken)
                .addHeader("appkey", appKey)
                .addHeader("appsecret", appSecret)
                .addHeader("tr_id", "FHKST01010100")
                .build();

        try (Response response = client.newCall(request).execute()) {

            // 응답 본문을 JsonNode로 변환
            String jsonResponse = Objects.requireNonNull(response.body()).string();
            JsonNode jsonNode = objectMapper.readTree(jsonResponse);
            JsonNode output = jsonNode.path("output");

            CurrentPriceResponseDto currentPrice = CurrentPriceResponseDto.builder().build();

            currentPrice.setCurrentPrice(output.path("stck_oprc").asLong());   // 현재가

            return currentPrice;

        } catch (IOException e) {
            return null;
            // TODO : 실패 시 Status 반환
            // ApiResponse.onFailure(Status.);
        }
    }

    @Override
    public PeriodPriceResponseDto findPeriodPriceByCode(String companyCode, String startDate, String endDate, String accessToken, String appKey, String appSecret){

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
                .addHeader("authorization", "Bearer " + accessToken)
                .addHeader("appkey", appKey)
                .addHeader("appsecret", appSecret)
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

            return periodPrice;

        } catch (IOException e) {
            return null;
            // TODO : 실패 시 Status 반환
            // ApiResponse.onFailure(Status.);
        }
    }
}
