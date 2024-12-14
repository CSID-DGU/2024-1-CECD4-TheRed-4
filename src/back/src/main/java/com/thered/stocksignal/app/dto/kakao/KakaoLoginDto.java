package com.thered.stocksignal.app.dto.kakao;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Properties;


public class KakaoLoginDto {

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class KakaoTokenResponseDto{
        private String access_token;
        private String token_type;
        private String refresh_token;
        private int expires_in;
        private String scope;
        private int refresh_token_expires_in;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class KakaoUserInfoResponseDto{
        private Long id;
        private String connected_at;
        private KakaoAccount kakao_account;
        private Properties properties;
        @Getter
        @AllArgsConstructor
        @NoArgsConstructor
        public static class KakaoAccount{
            private Boolean has_email;
            private Boolean email_needs_agreement;
            private Boolean is_email_valid;
            private Boolean is_email_verified;
            private String email;
        }

    }

    @Getter
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    public static class KakaoUserInfoDto{ // 카카오 토큰을 이용해서 읽어온 유저 정보
        private String email;
    }

    @Getter
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    public static class LoginResponseDto{

        private Long userId;
        private String token ;

    }
}
