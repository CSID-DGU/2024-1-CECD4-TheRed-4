package com.thered.stocksignal.repository;

import com.thered.stocksignal.domain.entity.Trade;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TradeRepository extends JpaRepository<Trade, Long> {

}
