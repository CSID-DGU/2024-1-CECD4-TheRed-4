package com.thered.stocksignal.app.dto.kis;

import lombok.*;

public class KisAccountDto {

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class AccessTokenResponseDto {
        private String access_token;
        private String token_type;
        private Integer expires_in;
        private String access_token_token_expired;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class SocketKeyResponseDto {
        private String approval_key;
    }
}

