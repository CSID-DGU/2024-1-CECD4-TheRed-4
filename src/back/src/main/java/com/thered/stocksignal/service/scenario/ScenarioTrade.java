package com.thered.stocksignal.service.scenario;

import com.thered.stocksignal.app.dto.StockDto;

public interface ScenarioTrade {
    boolean checkAutoTrade(Long userId, StockDto.RealTimeStockDto stockInfoDto);
}
