package com.thered.stocksignal.app.dto.kis;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.result.Output;

public class KisTradeDto {

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class TradeResponseDto{

        @JsonProperty("rt_cd")
        String rt_cd;
        @JsonProperty("msg_cd")
        String msg_cd;
        @JsonProperty("msg1")
        String msg1;
        @JsonProperty("output")
        Output output;

        @Getter
        @AllArgsConstructor
        @NoArgsConstructor
        public static class Output {
            @JsonProperty("KRX_FWDG_ORD_ORGNO")
            String KRX_FWDG_ORD_ORGNO;
            @JsonProperty("ODNO")
            String ODNO;
            @JsonProperty("ORD_TMD")
            String ORD_TMD;
        }

    }
}
