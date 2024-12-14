package com.thered.stocksignal.service.company;

import com.thered.stocksignal.app.dto.StockDto.popularStockResponseDto;

import java.util.List;

import static com.thered.stocksignal.app.dto.CompanyDto.*;
import static com.thered.stocksignal.app.dto.StockDto.*;

public interface CompanyService {

    // 회사명 -> 종목 코드 조회
    CompanyCodeResponseDto getCodeByName(String companyName);

    // 회사명 -> 로고 조회
    CompanyLogoResponseDto getLogoByName(String companyName);

    // 종목 코드 -> 회사 정보 (분석 탭에 들어갈 내용)
    CompanyInfoResponseDto getCompanyInfoByCode(String companyCode, Long userId);

    // 종목 코드 -> 현재가 조회
    CurrentPriceResponseDto getCurrentPriceByCode(String companyCode, Long userId);

    // 종목 코드 -> 일봉 조회
    PeriodPriceResponseDto getPeriodPriceByCode(String companyCode, String startDate, String endDate, Long userId);

    // 인기 종목 10개 조회
    List<popularStockResponseDto> getPopularStocks();

    // 실시간 호가
    RealTimeStockDto getRealTimeStock(Long userId, RealTimeStockDto dto);
}

