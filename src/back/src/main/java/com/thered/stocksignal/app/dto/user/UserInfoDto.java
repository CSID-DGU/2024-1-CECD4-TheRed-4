package com.thered.stocksignal.app.dto.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

public class UserInfoDto {

    @Getter
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    public static class InfoResponseDto{
        public String nickname;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class InfoRequestDto{
        public String nickname;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class LoginRequestDto{
        public String email;
    }

    @Getter
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    public static class kisAccountRequestDto{
        public String appKey;
        public String secretKey;
        public String account;
    }
}
