package com.thered.stocksignal.util;

import lombok.RequiredArgsConstructor;
import okhttp3.HttpUrl;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class KisUtil {

    private static final String baseUrl = "https://openapivts.koreainvestment.com:29443";

    public static String getCANO(String account) {
        return account.substring(0, 8);
    }

    public static String getACNT_PRDT_CD(String account) {
        return account.substring(9, 11);
    }

    // @param endpoint : API url
    // @param params : 쿼리 파라미터
    public String buildUrl(String endpoint, String... params) {
        HttpUrl.Builder urlBuilder = HttpUrl.parse(baseUrl + endpoint).newBuilder();

        for (String param : params) {
            String[] keyValue = param.split("=");

            if (keyValue.length >= 1) {

                // 키-값에서 값이 비어있으면 값에 ""을 넣음
                String value = keyValue.length == 2 ? keyValue[1] : "";

                // 키-값을 쿼리 파라미터로 추가함
                urlBuilder.addQueryParameter(keyValue[0], value);
            }
        }

        return urlBuilder.build().toString();
    }
}
