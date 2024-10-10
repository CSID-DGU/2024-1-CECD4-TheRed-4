package com.thered.stocksignal.app.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

public class MyBalanceDto {

    @Getter
    @Setter
    @Builder
    @ToString
    public static class StockResponseDto {
        private String stockName;  // 종목명
        private Long quantity;  // 보유 수량
        private Long avgPrice;  // 매입 평균가
        private Long currentPrice;  // 현재가
        private Long PL;  // 손익 금액
    }

    @Getter
    @Setter
    @Builder
    @ToString
    public static class MyBalanceResponseDto {
        private Long cash;  // 예수금 총 금액
        private List<StockResponseDto> stocks;  // 보유 주식 목록
        private Long totalStockPrice;  // 보유 주식 전체 가치 (금액)
        private Long totalStockPL;  // 보유 주식 전체 손익 (금액)
    }
}
