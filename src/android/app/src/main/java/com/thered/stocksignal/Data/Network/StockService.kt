package com.thered.stocksignal.data.network

import com.thered.stocksignal.domain.entites.StockBalance
import com.thered.stocksignal.domain.entites.StockList
import com.thered.stocksignal.domain.entites.StockListResponse
import retrofit2.Call
import retrofit2.http.GET

interface StockService {
    @GET("api/mybalance")
    fun getStockList(): Call<StockListResponse>

    @GET("api/mybalance")
    fun getMyBalance(): Call<StockListResponse>
}