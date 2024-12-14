package com.thered.stocksignal.service.scenario;

import com.thered.stocksignal.app.dto.StockDto;
import com.thered.stocksignal.app.dto.TradeDto;
import com.thered.stocksignal.domain.entity.Company;
import com.thered.stocksignal.domain.entity.Scenario;
import com.thered.stocksignal.domain.entity.ScenarioCondition;
import com.thered.stocksignal.domain.enums.BuysellType;
import com.thered.stocksignal.domain.enums.MethodType;
import com.thered.stocksignal.domain.enums.OrderType;
import com.thered.stocksignal.repository.ScenarioConditionRepository;
import com.thered.stocksignal.repository.ScenarioRepository;
import com.thered.stocksignal.service.trade.TradeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@Service
@RequiredArgsConstructor
@Transactional
public class ScenarioTradeImpl implements ScenarioTrade{

    private final ScenarioRepository scenarioRepository;
    private final ScenarioConditionRepository scenarioConditionRepository;
    private final TradeService tradeService;
    private final ConcurrentHashMap<Long, Lock> userLocks = new ConcurrentHashMap<>(); // 유저 ID에 따라 Lock 관리;

    public boolean checkAutoTrade(Long userId, StockDto.RealTimeStockDto stockInfoDto) {

        List<Scenario> scenarios = scenarioRepository.findByUserId(userId);
        for(Scenario scenario : scenarios){
            Company company = scenario.getCompany();
            String companyName = company.getCompanyName();
            String companyCode = company.getCompanyCode();
            List<ScenarioCondition> conditions = scenarioConditionRepository.findByScenarioId(scenario.getId());

            Long buyPrice = null;
            Long sellPrice = null;

            if (stockInfoDto.getCompanyName().equals(companyName)) {
                buyPrice = stockInfoDto.getBuyPrice1(); // 매수호가1
                sellPrice = stockInfoDto.getSellPrice1(); // 매도호가1
            }

            if (buyPrice != null && sellPrice != null) {
                executeAutoTrade(userId, companyCode, conditions, sellPrice, buyPrice);
            }
        }

        return false;
    }

    private void executeAutoTrade(Long userId, String companyCode, List<ScenarioCondition> conditions, Long sellPrice, Long buyPrice) {
        Lock lock = userLocks.computeIfAbsent(userId, k -> new ReentrantLock());
        lock.lock();

        int status;
        try{
            if(conditions.size() == 1){
                if(!conditions.getFirst().isFinished()){
                    status = excuteByRule(userId, companyCode, conditions.getFirst(), sellPrice, buyPrice);
                    if(status == 1) {
                        conditions.getFirst().setFinished(true);
                        scenarioConditionRepository.save(conditions.getFirst());
                    }
                }
            }
            else if(conditions.size() == 2){
                if(!conditions.getFirst().isFinished()){
                    status = excuteByRule(userId, companyCode, conditions.getFirst(), sellPrice, buyPrice);
                    if(status == 1) {
                        conditions.getFirst().setFinished(true);
                        conditions.getLast().setFinished(false);
                        scenarioConditionRepository.save(conditions.getFirst());
                        scenarioConditionRepository.save(conditions.getLast());
                    }
                }
                if(!conditions.getLast().isFinished()){
                    status = excuteByRule(userId, companyCode, conditions.getLast(), buyPrice, sellPrice);
                    if(status == 1) {
                        conditions.getFirst().setFinished(false);
                        conditions.getLast().setFinished(true);
                        scenarioConditionRepository.save(conditions.getFirst());
                        scenarioConditionRepository.save(conditions.getLast());
                    }
                }
            }
        }finally {
            lock.unlock();
        }
    }

    private int excuteByRule(Long userId, String companyCode, ScenarioCondition sc, Long sellPrice, Long buyPrice){

        TradeDto dto = TradeDto.builder().scode(companyCode).orderType(OrderType.SIJANG).price(0L).week(sc.getQuantity()).build();

        if (sc.getMethodType() == MethodType.RATE || sc.getMethodType() == MethodType.PRICE) {

            if (sc.getBuysellType() == BuysellType.BUY) {

                if (sc.getTargetPrice1() != null && sellPrice >= sc.getTargetPrice1()) {
                    tradeService.buy(userId, dto);
                    return 1;
                }
                if (sc.getTargetPrice2() != null && sellPrice <= sc.getTargetPrice2()) {
                    tradeService.buy(userId, dto);
                    return 1;
                }

            } else if (sc.getBuysellType() == BuysellType.SELL) {

                if (sc.getTargetPrice1() != null && buyPrice >= sc.getTargetPrice1()) {
                    tradeService.sell(userId, dto);
                    return 1;
                }
                if (sc.getTargetPrice2() != null && buyPrice <= sc.getTargetPrice2()) {
                    tradeService.sell(userId, dto);
                    return 1;
                }
            }
        }

        if (sc.getMethodType() == MethodType.TRADING) {

            if (sc.getBuysellType() == BuysellType.BUY) {

                // 상승 -> 하락
                if (sc.getTargetPrice1() != null && !sc.isPrice1Reached() && sellPrice >= sc.getTargetPrice1()) {
                    sc.setPrice1Reached(true);
                    scenarioConditionRepository.save(sc);
                    return 0;
                }
                else if (sc.getTargetPrice2() != null && sc.isPrice1Reached() && sellPrice <= sc.getTargetPrice2()) {
                    tradeService.buy(userId, dto);
                    return 1;
                }

                // 하락 -> 상승
                if (sc.getTargetPrice3() != null && !sc.isPrice3Reached() && sellPrice <= sc.getTargetPrice3()) {
                    sc.setPrice3Reached(true);
                    scenarioConditionRepository.save(sc);
                    return 0;
                }
                else if (sc.getTargetPrice4() != null && sc.isPrice3Reached() && sellPrice >= sc.getTargetPrice4()) {
                    tradeService.buy(userId, dto);
                    return 1;
                }

            } else if (sc.getBuysellType() == BuysellType.SELL) {

                // 상승 -> 하락
                if (sc.getTargetPrice1() != null && !sc.isPrice1Reached() && buyPrice >= sc.getTargetPrice1()) {
                    sc.setPrice1Reached(true);
                    scenarioConditionRepository.save(sc);
                    return 0;
                }
                if (sc.getTargetPrice2() != null && sc.isPrice1Reached() && buyPrice <= sc.getTargetPrice2()) {
                    tradeService.sell(userId, dto);
                    return 1;
                }

                // 하락 -> 상승
                if (sc.getTargetPrice3() != null && !sc.isPrice3Reached() && buyPrice <= sc.getTargetPrice3()) {
                    sc.setPrice3Reached(true);
                    scenarioConditionRepository.save(sc);
                    return 0;
                }
                else if (sc.getTargetPrice4() != null && sc.isPrice3Reached() && buyPrice >= sc.getTargetPrice4()) {
                    tradeService.sell(userId, dto);
                    return 1;
                }
            }
        }
        return 0;
    }
}
