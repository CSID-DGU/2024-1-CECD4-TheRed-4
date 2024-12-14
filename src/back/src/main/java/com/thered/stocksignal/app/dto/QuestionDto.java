package com.thered.stocksignal.app.dto;

import lombok.Builder;
import lombok.Getter;

public class QuestionDto {

    @Getter
    @Builder
    public static class QuestionResponseDto {
        private String answer;
    }
}
