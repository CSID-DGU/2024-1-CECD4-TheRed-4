package com.thered.stocksignal.service.company;

import static com.thered.stocksignal.app.dto.CompanyDto.*;
import static com.thered.stocksignal.app.dto.StockDto.*;

public interface CompanyService {

    // 회사명 -> 종목 코드 조회
    CompanyCodeResponseDto findCodeByName(String companyName);

    // 회사명 -> 로고 조회
    CompanyLogoResponseDto findLogoByName(String companyName);

    // 종목 코드 -> 회사 정보 (분석 탭에 들어갈 내용)
    CompanyInfoResponseDto findCompanyInfoByCode(String companyCode, String accessToken, String appKey, String appSecret);

    // 종목 코드 -> 현재가 조회
    CurrentPriceResponseDto findCurrentPriceByCode(String companyCode, String accessToken, String appKey, String appSecret);

    // 종목 코드 -> 일봉 조회
    PeriodPriceResponseDto findPeriodPriceByCode(String companyCode, String startDate, String endDate, String accessToken, String appKey, String appSecret);
}

