package com.thered.stocksignal.Data.model

data class NewsResponse(
    val code: String, // 응답에서 200을 String으로 받는 것 확인
    val result: String,
    val message: String,
    val data: List<Article> // data를 배열로 변경
)

data class Article(
    val title: String,
    val url: String,
    val pubDate: String // pubDate 추가
)
