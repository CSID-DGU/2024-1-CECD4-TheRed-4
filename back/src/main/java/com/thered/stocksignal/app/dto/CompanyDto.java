package com.thered.stocksignal.app.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

public class CompanyDto {

    @Getter
    @Setter
    @Builder
    public static class CompanyCodeResponseDto {
        private String companyCode;  // 종목 코드
    }

    @Getter
    @Setter
    @Builder
    public static class CompanyLogoResponseDto {
        private String logoImage;     // 로고 이미지 URL
    }

    @Getter
    @Setter
    @Builder
    public static class CompanyInfoResponseDto {
        private Long openPrice;
        private Long closePrice;
        private Long lowPrice;
        private Long highPrice;
        private Long tradingVolume;
        private Long tradingValue;
        private Long oneYearLowPrice;
        private Long oneYearHighPrice;
    }

}


