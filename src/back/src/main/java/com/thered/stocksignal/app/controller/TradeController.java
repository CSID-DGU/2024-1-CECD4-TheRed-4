package com.thered.stocksignal.app.controller;

import com.thered.stocksignal.apiPayload.ApiResponse;
import com.thered.stocksignal.apiPayload.Status;
import com.thered.stocksignal.app.dto.TradeDto;
import com.thered.stocksignal.service.trade.TradeService;
import com.thered.stocksignal.service.user.UserAccountService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/trade")
public class TradeController {

    private final TradeService tradeService;
    private final UserAccountService userAccountService;

    @Operation(summary = "주식 매수")
    @PostMapping("/buy")
    public ApiResponse<?> buyStock(@RequestHeader("Authorization") String token,
                                   @RequestBody TradeDto dto){
        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onSuccess(Status.TOKEN_INVALID, null);

        String message = tradeService.buy(userId, dto);
        if(!message.equals("true")) return ApiResponse.onFailure(Status.TRADE_BUY_FAILED, message);
        return ApiResponse.onSuccess(Status.TRADE_BUY_SUCCESS, null);
    }

    @Operation(summary = "주식 매도")
    @PostMapping("/sell")
    public ApiResponse<?> sellStock(@RequestHeader("Authorization") String token,
                                    @RequestBody TradeDto dto){
        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onSuccess(Status.TOKEN_INVALID, null);

        String message = tradeService.sell(userId, dto);
        if(!message.equals("true")) return ApiResponse.onFailure(Status.TRADE_SELL_FAILED, message);
        return ApiResponse.onSuccess(Status.TRADE_SELL_SUCCESS, null);
    }



}
