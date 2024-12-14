package com.thered.stocksignal.service.myBalance;

import static com.thered.stocksignal.app.dto.MyBalanceDto.*;

public interface MyBalanceService {

    // 내 잔고 조회
    MyBalanceResponseDto getMyBalance(Long userId);

}
