package com.thered.stocksignal.repository;

import com.thered.stocksignal.domain.entity.UserStock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserStockRepository extends JpaRepository<UserStock, Long> {
    @Query("SELECT us FROM UserStock us WHERE us.user.id = :userId AND us.stock.id = :stockId")
    UserStock findByUserIdAndStockId(@Param("userId") Long userId, @Param("stockId") Long stockId);
}

