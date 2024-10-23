package com.thered.stocksignal.service.myBalance;

import java.util.Optional;

import static com.thered.stocksignal.app.dto.MyBalanceDto.*;

public interface MyBalanceService {

    // 내 잔고 조회
    Optional<MyBalanceResponseDto> getMyBalance(Long userId);

}
