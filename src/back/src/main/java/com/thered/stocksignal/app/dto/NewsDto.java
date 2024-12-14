package com.thered.stocksignal.app.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;
import java.util.List;

public class NewsDto {

    @Getter
    @Setter
    @Builder
    public static class NewsResponseDto {
        private String title;
        private String url;
        private String pubDate;
    }

}

