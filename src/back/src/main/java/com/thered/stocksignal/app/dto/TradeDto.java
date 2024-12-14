package com.thered.stocksignal.app.dto;

import com.thered.stocksignal.domain.enums.OrderType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TradeDto {
    public String scode; // 종목코드
    public OrderType orderType; // 지정가/시장가 구분
    public Long price; // 주문단가
    public Long week; // 주문수량
}
