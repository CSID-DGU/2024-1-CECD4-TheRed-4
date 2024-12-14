package com.thered.stocksignal.app.dto;

import lombok.*;

import java.util.List;

public class StockDto {

    @Getter
    @Setter
    @Builder
    // 현재가 정보
    public static class CurrentPriceResponseDto {
        private Long currentPrice;    // 현재가
    }

    @Getter
    @Setter
    @Builder
    // 일봉
    public static class DailyPriceResponseDto {
        private String date;      // 날짜
        private Long startPrice; // 시가
        private Long closePrice; // 종가
        private Long highPrice; // 고가
        private Long lowPrice; // 저가
        private Long tradingVolume;    //거래량
    }

    @Getter
    @Setter
    @Builder
    // 일봉 리스트
    public static class PeriodPriceResponseDto {
        private List<DailyPriceResponseDto> periodPrice;
    }

    @Getter
    @Setter
    @Builder
    // 주식 순위
    public static class popularStockResponseDto {
        private Integer rank;
        private String companyName;
    }

    @Getter
    @Setter
    @Builder
    // 실시간 정보
    public static class RealTimeStockDto {
        private String companyName;
        private String time;
        private Long latestPrice;   // 체결가

        private Long buyPrice1; // 매수호가 1~6 (1 = 가장 비쌈)
        private Long buyPrice2;
        private Long buyPrice3;
        private Long buyPrice4;
        private Long buyPrice5;
        private Long buyPrice6;

        private Long buyQuantity1;  // 매수호가별 잔량
        private Long buyQuantity2;
        private Long buyQuantity3;
        private Long buyQuantity4;
        private Long buyQuantity5;
        private Long buyQuantity6;

        private Long sellPrice1;    // 매도호가 1~6 (1 = 가장 쌈)
        private Long sellPrice2;
        private Long sellPrice3;
        private Long sellPrice4;
        private Long sellPrice5;
        private Long sellPrice6;

        private Long sellQuantity1; // 매도호가별 잔량
        private Long sellQuantity2;
        private Long sellQuantity3;
        private Long sellQuantity4;
        private Long sellQuantity5;
        private Long sellQuantity6;

    }
}

