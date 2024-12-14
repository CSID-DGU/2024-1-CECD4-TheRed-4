package com.thered.stocksignal.app.controller;

import com.thered.stocksignal.apiPayload.ApiResponse;
import com.thered.stocksignal.apiPayload.Status;
import com.thered.stocksignal.app.dto.kakao.KakaoLoginDto;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.jwt.JWTUtil;
import com.thered.stocksignal.service.kakao.KakaoLoginService;
import com.thered.stocksignal.service.user.UserAccountService;
import io.swagger.v3.oas.annotations.Parameter;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import io.swagger.v3.oas.annotations.Operation;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth/kakao")
public class KakaoLoginController {

    private final KakaoLoginService kakaoLoginService;
    private final UserAccountService userAccountService;
    private final JWTUtil jwtUtil;

    @Operation(summary = "프론트로부터 카카오 인가코드 전달받기")
    @Parameter(name = "code", description = "카카오에서 받은 인카코드, RequestParam")
    @PostMapping("/login/code")
    public ApiResponse<?> kakaoLoginCode(@RequestParam("code") String code){

        String token = kakaoLoginService.getKakaoToken(code);
        KakaoLoginDto.KakaoUserInfoDto kakaoUserInfoDto = kakaoLoginService.getKakaoUserInfo(token);

        if(userAccountService.findByEmail(kakaoUserInfoDto.getEmail()).isEmpty()) userAccountService.saveKakaoUser(kakaoUserInfoDto.getEmail());
        User user = userAccountService.findByEmail(kakaoUserInfoDto.getEmail()).get();

        String jwtToken = jwtUtil.createJwt(user.getId(), user.getNickname());
        KakaoLoginDto.LoginResponseDto dto = new KakaoLoginDto.LoginResponseDto().builder()
                .userId(user.getId())
                .token(jwtToken)
                .build();

        return ApiResponse.onSuccess(Status.LOGIN_SUCCESS, dto);
    }

    @Operation(summary = "프론트로부터 카카오 토큰 전달받기")
    @Parameter(name = "token", description = "카카오에서 받은 토큰, RequestParam")
    @PostMapping("/login/token")
    public ApiResponse<?> kakaoLoginToken(@RequestParam("token") String token){

        KakaoLoginDto.KakaoUserInfoDto kakaoUserInfoDto = kakaoLoginService.getKakaoUserInfo(token);

        if(userAccountService.findByEmail(kakaoUserInfoDto.getEmail()).isEmpty()) userAccountService.saveKakaoUser(kakaoUserInfoDto.getEmail());
        User user = userAccountService.findByEmail(kakaoUserInfoDto.getEmail()).get();

        String jwtToken = jwtUtil.createJwt(user.getId(), user.getNickname());
        KakaoLoginDto.LoginResponseDto dto = new KakaoLoginDto.LoginResponseDto().builder()
                .userId(user.getId())
                .token(jwtToken)
                .build();

        return ApiResponse.onSuccess(Status.LOGIN_SUCCESS, dto);
    }

    @Operation(summary = "인가코드 발급 API")
    @GetMapping("/callback")
    public ApiResponse<?> testInga(@RequestParam("code") String code){

        return ApiResponse.onSuccess(Status.INGA_SUCCESS, code);
    }

    @Operation(summary = "백엔드에서 토큰 정보 확인용으로, 사용하지 않는 API입니다.")
    @GetMapping("/valid")
    public void testToken(@RequestParam("code") String token){
        kakaoLoginService.isValidToken(token);
    }

}
