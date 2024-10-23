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
        private Long closePrice; // 종가
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
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    public static class MyStockResponseDto{
        public String companyName;
        public Integer totalPrice;
        public String rate;
    }


}

