package com.thered.stocksignal.app.controller;

import com.thered.stocksignal.apiPayload.ApiResponse;
import com.thered.stocksignal.apiPayload.Status;
import com.thered.stocksignal.service.company.CompanyService;
import com.thered.stocksignal.app.dto.CompanyDto.*;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import static com.thered.stocksignal.app.dto.StockDto.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/company")
public class CompanyController {

    private final CompanyService companyService;

    @GetMapping("/code/{companyName}")
    @Operation(summary = "종목 코드 조회", description = "회사명으로 종목 코드를 가져옵니다.")
    public ApiResponse<CompanyCodeResponseDto> getCompanyCode(@PathVariable String companyName) {
        CompanyCodeResponseDto responseDto = companyService.findCodeByName(companyName);

        return ApiResponse.onSuccess(Status.COMPANY_CODE_SUCCESS, responseDto);
    }

    @GetMapping("/logo/{companyName}")
    @Operation(summary = "로고 이미지 URL 조회", description = "회사명으로 로고 이미지 URL을 가져옵니다.")
    public ApiResponse<CompanyLogoResponseDto> getCompanyLogo(@PathVariable String companyName) {
        CompanyLogoResponseDto responseDto = companyService.findLogoByName(companyName);

        return ApiResponse.onSuccess(Status.COMPANY_LOGO_SUCCESS, responseDto);
    }

    @GetMapping("/{companyCode}")
    @Operation(summary = "회사 정보 조회(분석 탭)", description = "종목 코드로 회사 정보 조회")
    public ApiResponse<CompanyInfoResponseDto> getCompanyInfo(
            @PathVariable String companyCode,

            // TODO : 아래정보는 토큰 및 User테이블에서 받게변경할것
            @RequestParam String accessToken,
            @RequestParam String appKey,
            @RequestParam String appSecret
    ) {

        CompanyInfoResponseDto responseDto = companyService.findCompanyInfoByCode(companyCode,accessToken, appKey, appSecret);

        return ApiResponse.onSuccess(Status.COMPANY_INFO_SUCCESS, responseDto);
    }

    @GetMapping("/current-price/{companyCode}")
    @Operation(summary = "현재가 조회", description = "종목 코드로 현재가 조회")
    public ApiResponse<CurrentPriceResponseDto> getCurrentPrice(
            @PathVariable String companyCode,

            // TODO : 아래정보는 토큰 및 User테이블에서 받게변경할것
            @RequestParam String accessToken,
            @RequestParam String appKey,
            @RequestParam String appSecret
    ){

        CurrentPriceResponseDto responseDto = companyService.findCurrentPriceByCode(companyCode,accessToken, appKey, appSecret);

        return ApiResponse.onSuccess(Status.CURRENT_PRICE_SUCCESS, responseDto);
    }

    @GetMapping("/period-price")
    @Operation(summary = "일봉 조회", description = "종목 코드로 일봉 조회")
    public ApiResponse<PeriodPriceResponseDto> getPeriodPrice(
            @RequestParam  String companyCode,
            @RequestParam  String startDate,
            @RequestParam  String endDate,

            // TODO : 아래정보는 토큰 및 User테이블에서 받게변경할것
            @RequestParam String accessToken,
            @RequestParam String appKey,
            @RequestParam String appSecret
    ){

        PeriodPriceResponseDto responseDto = companyService.findPeriodPriceByCode(companyCode, startDate, endDate, accessToken, appKey, appSecret);

        return ApiResponse.onSuccess(Status.PERIOD_PRICE_SUCCESS, responseDto);
    }
}
