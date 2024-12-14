package com.thered.stocksignal.Data.Network


import com.thered.stocksignal.Data.model.NewsResponse
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Path

interface NewsApiService {
    @GET("api/news/{stockName}") // 실제 API 엔드포인트를 사용하세요.
    fun getNews(
        @Path("stockName") stockName: String,
//        @Header("Authorization") authHeader: String
    ): Call<NewsResponse>
}
