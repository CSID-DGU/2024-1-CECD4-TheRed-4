package com.thered.stocksignal.apiPayload;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

import static lombok.AccessLevel.PRIVATE;



@Getter
@RequiredArgsConstructor(access = PRIVATE)
public enum Status {

    /**
     * SUCCESS CODE
     * 200 : OK
     * 201 : CREATED
     * 204 : NO CONTENT
     * ...
     */

    /**
     * FAILURE CODE
     * 400 :
     * 401 :
     * 404 :
     * ...
     */

    LOGIN_SUCCESS("200", "SUCCESS", "로그인이 완료되었습니다."),

    QUESTION_FOUND("200", "SUCCESS", "답변 정보를 찾았습니다."),

    NEWS_SEARCH_SUCCESS("200", "SUCCESS", "뉴스 검색에 성공하였습니다."),

    COMPANY_INFO_SUCCESS("200", "SUCCESS", "회사 정보 조회에 성공하였습니다."),
    COMPANY_CODE_SUCCESS("200", "SUCCESS", "종목 코드 조회에 성공했습니다."),
    COMPANY_LOGO_SUCCESS("200", "SUCCESS", "회사 로고 조회에 성공했습니다."),

    CURRENT_PRICE_SUCCESS("200", "SUCCESS", "현재가 조회에 성공했습니다."),
    PERIOD_PRICE_SUCCESS("200", "SUCCESS", "기간별 조회에 성공했습니다."),
    AI_PREDICTION_SUCCESS("200", "SUCCESS", "AI 예상 주가 조회에 성공했습니다."),

    MY_BALANCE_SUCCESS("200", "SUCCESS", "잔고 조회에 성공했습니다."),

    GET_USERINFO_SUCCESS("200", "SUCCESS", "회원 정보가 조회되었습니다."),
    SET_USERINFO_SUCCESS("200", "SUCCESS", "회원 정보가 수정되었습니다."),
    NICKNAME_SUCCESS("200", "SUCCESS", "사용 가능한 닉네임입니다."),
  
    TRADE_BUY_SUCCESS("200", "SUCCESS", "매수를 성공했습니다."),
    TRADE_SELL_SUCCESS("200", "SUCCESS", "매도를 성공했습니다."),
  
    MYSTOCK_SUCCESS("200", "SUCCESS", "나의 전체 주식현황을 읽는데 성공했습니다."),
    MYSTOCK_SHORT_SUCCESS("200", "SUCCESS", "나의 주식현황 요약을 읽는데 성공했습니다.");

    private final String code;
    private final String result;
    private final String message;
}
