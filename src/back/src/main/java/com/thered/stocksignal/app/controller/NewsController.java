package com.thered.stocksignal.app.controller;

import com.thered.stocksignal.apiPayload.ApiResponse;
import com.thered.stocksignal.apiPayload.Status;
import com.thered.stocksignal.app.dto.NewsDto.NewsResponseDto;
import com.thered.stocksignal.service.news.NewsService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/news")
public class NewsController {

    private final NewsService newsService;

    @GetMapping("/{stockName}")
    @Operation(summary = "뉴스 조회", description = "해당 종목의 뉴스를 조회합니다.")
    public ApiResponse<List<NewsResponseDto>> getNews(@PathVariable String stockName) {

        List<NewsResponseDto> responseDto;

        try{
            responseDto = newsService.searchNews(stockName);
        }catch (RuntimeException e){
            return ApiResponse.onFailure(Status.NEWS_NOT_FOUND);
        }

        return ApiResponse.onSuccess(Status.NEWS_FOUND, responseDto);
    }
}
