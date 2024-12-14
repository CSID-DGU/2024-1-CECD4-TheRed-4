package com.thered.stocksignal.app.controller;

import com.thered.stocksignal.apiPayload.ApiResponse;
import com.thered.stocksignal.apiPayload.Status;
import com.thered.stocksignal.app.dto.StockDto.popularStockResponseDto;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.service.company.CompanyService;
import com.thered.stocksignal.app.dto.CompanyDto.*;
import com.thered.stocksignal.service.user.UserAccountService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.persistence.EntityNotFoundException;
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

        CompanyCodeResponseDto codeResponse = null;

        try{
            codeResponse = companyService.getCodeByName(companyName);
        }
        catch (EntityNotFoundException e){
            return ApiResponse.onFailure(Status.COMPANY_NOT_FOUND);
        }

        return ApiResponse.onSuccess(Status.COMPANY_CODE_SUCCESS, codeResponse);
    }

    @GetMapping("/{companyName}/logo")
    @Operation(summary = "로고 이미지 URL 조회", description = "종목명으로 로고 이미지 경로를 불러옵니다.")
    public ApiResponse<CompanyLogoResponseDto> getCompanyLogo(@PathVariable String companyName) {

        CompanyLogoResponseDto logoResponse = null;

        try{
            logoResponse = companyService.getLogoByName(companyName);
        }
        catch (EntityNotFoundException e){
            return ApiResponse.onFailure(Status.COMPANY_NOT_FOUND);
        }

        return ApiResponse.onSuccess(Status.COMPANY_LOGO_SUCCESS, logoResponse);
    }

    @GetMapping("/{companyName}")
    @Operation(summary = "회사 정보 조회(분석 탭)", description = "종목명으로 회사 정보를 조회합니다.")
    public ApiResponse<CompanyInfoResponseDto> getCompanyInfo(
            @PathVariable String companyName,
            @RequestHeader("Authorization") String token
    ) {
        CompanyCodeResponseDto codeResponse = null;
        CompanyInfoResponseDto infoResponse = null;

        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onFailure(Status.TOKEN_INVALID);

        try{
            codeResponse = companyService.getCodeByName(companyName);
            infoResponse = companyService.getCompanyInfoByCode(
                    codeResponse.getCompanyCode(),
                    userId
            );
        }catch (IllegalArgumentException e){
            return ApiResponse.onFailure(Status.USER_NOT_FOUND);
        }catch (EntityNotFoundException e){
            return ApiResponse.onFailure(Status.COMPANY_NOT_FOUND);
        }catch (RuntimeException e) {
            return ApiResponse.onFailure(Status.KIS_CONNECT_INVALID);
        }

        return ApiResponse.onSuccess(Status.COMPANY_INFO_SUCCESS, infoResponse);
    }

    @GetMapping("/{companyName}/current-price")
    @Operation(summary = "현재가 조회", description = "종목명으로 현재가를 조회합니다.")
    public ApiResponse<CurrentPriceResponseDto> getCurrentPrice(
            @PathVariable String companyName,
            @RequestHeader("Authorization") String token
    ){
        CompanyCodeResponseDto codeResponse = null;
        CurrentPriceResponseDto priceResponse = null;

        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onFailure(Status.TOKEN_INVALID);

        try{
            codeResponse = companyService.getCodeByName(companyName);
            priceResponse = companyService.getCurrentPriceByCode(
                    codeResponse.getCompanyCode(),
                    userId
            );
        }catch (IllegalArgumentException e){
            return ApiResponse.onFailure(Status.USER_NOT_FOUND);
        }catch (EntityNotFoundException e){
            return ApiResponse.onFailure(Status.COMPANY_NOT_FOUND);
        }catch (RuntimeException e) {
            return ApiResponse.onFailure(Status.KIS_CONNECT_INVALID);
        }

        return ApiResponse.onSuccess(Status.CURRENT_PRICE_SUCCESS, priceResponse);
    }

    @GetMapping("/{companyName}/period-price")
    @Operation(summary = "일봉 조회", description = "종목명으로 일봉을 조회합니다.")
    public ApiResponse<PeriodPriceResponseDto> getPeriodPrice(
            @PathVariable String companyName,
            @RequestParam  String startDate,
            @RequestParam  String endDate,
            @RequestHeader("Authorization") String token
    ){
        CompanyCodeResponseDto codeResponse = null;
        PeriodPriceResponseDto priceResponse = null;

        Long userId = userAccountService.getUserIdFromToken(token);
        if(userId == -1) return ApiResponse.onFailure(Status.TOKEN_INVALID);

        try{
            codeResponse = companyService.getCodeByName(companyName);
            priceResponse = companyService.getPeriodPriceByCode(
                    codeResponse.getCompanyCode(),
                    startDate,
                    endDate,
                    userId
            );
        }catch (IllegalArgumentException e){
            return ApiResponse.onFailure(Status.USER_NOT_FOUND);
        }catch (EntityNotFoundException e){
            return ApiResponse.onFailure(Status.COMPANY_NOT_FOUND);
        }catch (RuntimeException e) {
            return ApiResponse.onFailure(Status.KIS_CONNECT_INVALID);
        }

        return ApiResponse.onSuccess(Status.PERIOD_PRICE_SUCCESS, priceResponse);
    }

    @GetMapping("/popular")
    @Operation(summary = "상위 10개 인기 주식 조회", description = "상위 10개 인기 종목을 가져옵니다.")
    public ApiResponse<List<popularStockResponseDto>> getPopularStocks() {

        List<popularStockResponseDto> responseDto;
        try{
            responseDto = companyService.getPopularStocks();
        }catch(RuntimeException e){
            return ApiResponse.onFailure(Status.COMPANY_RANKING_FAILED);
        }

        return ApiResponse.onSuccess(Status.COMPANY_RANKING_SUCCESS, responseDto);
    }
}
