package com.thered.stocksignal.app.controller;

import com.thered.stocksignal.apiPayload.ApiResponse;
import com.thered.stocksignal.apiPayload.Status;
import com.thered.stocksignal.app.dto.StockDto.popularStockResponseDto;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.service.company.CompanyService;
import com.thered.stocksignal.app.dto.CompanyDto.*;
import com.thered.stocksignal.service.user.UserAccountService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

import static com.thered.stocksignal.app.dto.StockDto.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/company")
public class CompanyController {

    private final CompanyService companyService;
    private final UserAccountService userAccountService;

    @GetMapping("/{companyName}/code")
    @Operation(summary = "종목 코드 조회", description = "종목명으로 종목 코드를 가져옵니다.")
    public ApiResponse<CompanyCodeResponseDto> getCompanyCode(@PathVariable String companyName) {

        Optional<CompanyCodeResponseDto> responseDto = companyService.findCodeByName(companyName);

        return responseDto
                .map(dto -> ApiResponse.onSuccess(Status.COMPANY_CODE_SUCCESS, dto))
                .orElseGet(() -> ApiResponse.onFailure(Status.COMPANY_NOT_FOUND));
    }

    @GetMapping("/{companyName}/logo")
    @Operation(summary = "로고 이미지 URL 조회", description = "종목명으로 로고 이미지 경로를 불러옵니다.")
    public ApiResponse<CompanyLogoResponseDto> getCompanyLogo(@PathVariable String companyName) {

        Optional<CompanyLogoResponseDto> responseDto = companyService.findLogoByName(companyName);
        return responseDto
                .map(dto -> ApiResponse.onSuccess(Status.COMPANY_LOGO_SUCCESS, dto))
                .orElseGet(() -> ApiResponse.onFailure(Status.COMPANY_NOT_FOUND));
    }

    @GetMapping("/{companyName}")
    @Operation(summary = "회사 정보 조회(분석 탭)", description = "종목명으로 회사 정보를 조회합니다.")
    public ApiResponse<CompanyInfoResponseDto> getCompanyInfo(
            @PathVariable String companyName,
            @RequestHeader("Authorization") String token
    ) {
        Optional<CompanyCodeResponseDto> companyCode = companyService.findCodeByName(companyName);
        if(companyCode.isEmpty()) return ApiResponse.onFailure(Status.COMPANY_NOT_FOUND);

        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onFailure(Status.TOKEN_INVALID);

        Optional<CompanyInfoResponseDto> responseDto = companyService.findCompanyInfoByCode(
                companyCode.get().getCompanyCode(),
                userId
        );

        return responseDto
                .map(dto -> ApiResponse.onSuccess(Status.COMPANY_INFO_SUCCESS, dto))
                .orElseGet(() -> ApiResponse.onFailure(Status.COMPANY_NOT_FOUND));
    }

    @GetMapping("/{companyName}/current-price")
    @Operation(summary = "현재가 조회", description = "종목명으로 현재가를 조회합니다.")
    public ApiResponse<CurrentPriceResponseDto> getCurrentPrice(
            @PathVariable String companyName,
            @RequestHeader("Authorization") String token
    ){
        Optional<CompanyCodeResponseDto> companyCode = companyService.findCodeByName(companyName);
        if(companyCode.isEmpty()) return ApiResponse.onFailure(Status.COMPANY_NOT_FOUND);

        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onFailure(Status.TOKEN_INVALID);

        Optional<CurrentPriceResponseDto> responseDto = companyService.findCurrentPriceByCode(
                companyCode.get().getCompanyCode(),
                userId
        );

        return responseDto
                .map(dto -> ApiResponse.onSuccess(Status.CURRENT_PRICE_SUCCESS, dto))
                .orElseGet(() -> ApiResponse.onFailure(Status.COMPANY_NOT_FOUND));
    }

    @GetMapping("/{companyName}/period-price")
    @Operation(summary = "일봉 조회", description = "종목명으로 일봉을 조회합니다.")
    public ApiResponse<PeriodPriceResponseDto> getPeriodPrice(
            @PathVariable String companyName,
            @RequestParam  String startDate,
            @RequestParam  String endDate,
            @RequestHeader("Authorization") String token
    ){
        Optional<CompanyCodeResponseDto> companyCode = companyService.findCodeByName(companyName);
        if(companyCode.isEmpty()) return ApiResponse.onFailure(Status.COMPANY_NOT_FOUND);

        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onFailure(Status.TOKEN_INVALID);

        Optional<User> user = userAccountService.findById(userId);
        if (user.isEmpty()) return ApiResponse.onFailure(Status.USER_NOT_FOUND);

        Optional<PeriodPriceResponseDto> responseDto = companyService.findPeriodPriceByCode(
                companyCode.get().getCompanyCode(),
                startDate,
                endDate,
                userId
        );

        return responseDto
                .map(dto -> ApiResponse.onSuccess(Status.PERIOD_PRICE_SUCCESS, dto))
                .orElseGet(() -> ApiResponse.onFailure(Status.COMPANY_NOT_FOUND));
    }

    @GetMapping("/popular")
    @Operation(summary = "상위 10개 인기 주식 조회", description = "상위 10개 인기 종목을 가져옵니다.")
    public ApiResponse<List<popularStockResponseDto>> getPopularStocks() {

        Optional<List<popularStockResponseDto>> responseDto = companyService.getPopularStocks();

        return responseDto
                .map(dto -> ApiResponse.onSuccess(Status.COMPANY_RANKING_SUCCESS, dto))
                .orElseGet(() -> ApiResponse.onFailure(Status.COMPANY_RANKING_FAILED));
    }
}
