package com.thered.stocksignal.service.news;

import com.thered.stocksignal.app.dto.NewsDto.NewsResponseDto;

import java.util.List;

public interface NewsService {

    List<NewsResponseDto> searchNews(String query);
}
