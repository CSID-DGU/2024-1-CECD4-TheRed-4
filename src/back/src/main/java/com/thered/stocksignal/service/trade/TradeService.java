package com.thered.stocksignal.service.trade;

import com.thered.stocksignal.app.dto.TradeDto;

public interface TradeService {
    String buy(Long userId, TradeDto dto);

    String sell(Long userId, TradeDto dto);

}
