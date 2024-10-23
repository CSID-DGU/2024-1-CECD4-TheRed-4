package com.thered.stocksignal.app.dto;

import com.thered.stocksignal.domain.enums.BuysellType;
import com.thered.stocksignal.domain.enums.MethodType;
import lombok.*;

public class ScenarioDto {

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ScenarioRequestDto {
        private String scenarioName;
        private String companyName;
        private BuysellType buysellType;
        private MethodType methodType;
        private Long initialPrice;

        private Long targetPrice1;
        private Long targetPrice2;
        private Long targetPrice3;
        private Long targetPrice4;
        private Long quantity;
    }

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ConditionRequestDto {
        private Long scenarioId;
        private BuysellType buysellType;
        private MethodType methodType;
        private Long targetPrice1;
        private Long targetPrice2;
        private Long targetPrice3;
        private Long targetPrice4;
        private Long quantity;
    }

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ScenarioResponseDto {
        private Long scenarioId;
        private String scenarioName;
        private String companyName;
        private Long initialPrice;
        private Long currentPrice;
    }

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ConditionResponseDto {
        private Long conditionId;
        private BuysellType buysellType; // BUY, SELL
        private MethodType methodType;  // RATE, PRICE, TRADING
        private Long initialPrice;
        private Long currentPrice;
        private Long targetPrice1;
        private Long targetPrice2;
        private Long targetPrice3;
        private Long targetPrice4;
        private Long quantity;
    }
}
