package com.thered.stocksignal.app.controller;

import com.thered.stocksignal.apiPayload.ApiResponse;
import com.thered.stocksignal.apiPayload.Status;
import com.thered.stocksignal.service.myBalance.MyBalanceService;
import com.thered.stocksignal.service.user.UserAccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import io.swagger.v3.oas.annotations.Operation;

import java.util.Optional;

import static com.thered.stocksignal.app.dto.MyBalanceDto.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/mybalance")
public class MyBalanceController {

    private final MyBalanceService myBalanceService;
    private final UserAccountService userAccountService;

    @GetMapping
    @Operation(summary = "주식 잔고 조회", description = "사용자의 주식 잔고 정보를 조회합니다.")
    public ApiResponse<MyBalanceResponseDto> getMyBalance(
            @RequestHeader("Authorization") String token)
    {
        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onFailure(Status.TOKEN_INVALID);

        Optional<MyBalanceResponseDto> responseDto = myBalanceService.getMyBalance(
                userId
        );

        return responseDto.map(dto -> ApiResponse.onSuccess(Status.MY_BALANCE_SUCCESS, dto))
                .orElseGet(() -> ApiResponse.onFailure(Status.MY_BALANCE_NOT_FOUND));
    }
}




