package com.thered.stocksignal.service;

import com.thered.stocksignal.app.dto.MyBalanceDto;
import com.thered.stocksignal.domain.entity.UserStock;
import com.thered.stocksignal.repository.UserStockRepository;
import com.thered.stocksignal.service.myBalance.MyBalanceService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
public class MyBalanceServiceTest {

    @Autowired
    private UserStockRepository userStockRepository;

    @Autowired
    private MyBalanceService myBalanceService;

    @Test
    @DisplayName("내 잔고 조회 API 테스트")
    public void testGetMyBalance() throws Exception {

        String accountNumber = "계좌번호";
        String accessToken = "토큰";
        String appKey = "앱키";
        String appSecret = "앱시크릿";

        MyBalanceDto.MyBalanceResponseDto result = myBalanceService.getMyBalance(accountNumber, accessToken, appKey, appSecret);
        assertNotNull(result);

        System.out.println(result);
    }

    @Test
    @DisplayName("잔고 정보가 DB에 저장되는지 확인")
    //테스트시 MyBalanceService의 updateUserStock()을 public으로 수정
    public void testUpdate() {

        myBalanceService.updateUserStock(1L,null,1L,1L);

        UserStock userStock = userStockRepository.findByUserIdAndCompanyId(1L, 1L);
        assertNotNull(userStock);

        System.out.println("user_id: " + userStock.getUser().getId());
        System.out.println("stock_id: " + userStock.getCompany().getId());
        System.out.println("stock_count: " + userStock.getStockCount());
        System.out.println("total_price: " + userStock.getTotalPrice());
    }
}


