package com.thered.stocksignal.app.controller;

import com.thered.stocksignal.apiPayload.ApiResponse;
import com.thered.stocksignal.apiPayload.Status;
import com.thered.stocksignal.app.dto.user.UserInfoDto;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.service.user.UserAccountService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserInfoController {

    private final UserAccountService userAccountService;

    @Operation(summary = "회원 정보 조회", description = "Header에 token을 담아야 합니다.")
    @GetMapping("/info/detail")
    public ApiResponse<?> getUserInfo(@RequestHeader("Authorization") String token){
        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onSuccess(Status.TOKEN_INVALID, null);
        Optional<User> user = userAccountService.getUserById(userId);
        UserInfoDto.InfoResponseDto infoResponseDto = new UserInfoDto.InfoResponseDto().builder()
                .nickname(user.get().getNickname())
                .build();

        return ApiResponse.onSuccess(Status.GET_USERINFO_SUCCESS, infoResponseDto);
    }

    @Operation(summary = "회원 정보 수정")
    @PatchMapping("/info/edit")
    public ApiResponse<?> setUserInfo(@RequestBody UserInfoDto.InfoRequestDto dto, @RequestHeader("Authorization") String token){
        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onSuccess(Status.TOKEN_INVALID, null);
        userAccountService.editUserNickname(userId, dto.getNickname());
        return ApiResponse.onSuccess(Status.SET_USERINFO_SUCCESS, null);
    }

    @Operation(summary = "닉네임 중복 확인")
    @GetMapping("/{nickname}/exists")
    public ApiResponse<?> isNicknameExists(@Parameter @PathVariable(value = "nickname") String nickname){
        Boolean isExists = userAccountService.isExistNickname(nickname);
        if(!isExists) return ApiResponse.onSuccess(Status.NICKNAME_SUCCESS, null);
        return ApiResponse.onSuccess(Status.NICKNAME_INVALID, null);
    }

    @Operation(summary = "한국투자증권 계좌 연동")
    @PostMapping("/kis/connect")
    public ApiResponse<?> connectKisAccount(@RequestHeader("Authorization") String token,
                                            @RequestBody UserInfoDto.kisAccountRequestDto dto){

        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onSuccess(Status.TOKEN_INVALID, null);

        Optional<User> user = userAccountService.getUserById(userId);
        if(!user.get().getIsKisLinked()) userAccountService.connectKisAccount(userId, dto);

        return ApiResponse.onSuccess(Status.KIS_CONNECT_SUCCESS, null);
    }
}
