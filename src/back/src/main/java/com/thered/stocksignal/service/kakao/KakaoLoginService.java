package com.thered.stocksignal.service.kakao;

import com.thered.stocksignal.app.dto.kakao.KakaoLoginDto;

public interface KakaoLoginService {

    String getKakaoToken(String code);
    KakaoLoginDto.KakaoUserInfoDto getKakaoUserInfo(String token);
    void isValidToken(String token);
    
}
